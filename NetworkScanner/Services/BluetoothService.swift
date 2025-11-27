//
//  BluetoothService.swift
//  NetworkScanner
//
//  Created by Danil Kazakov on 2025/11/27.
//

import Combine
import CoreBluetooth
import Foundation

class BluetoothService: NSObject, ObservableObject {
    @Published var devices: [ScannedDevice] = []
    @Published var isScanning = false
    @Published var state: CBManagerState = .unknown
    
    private var centralManager: CBCentralManager?
    private var shouldScan = false
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func startScanning() {
        shouldScan = true
        if centralManager?.state == .poweredOn {
            retrieveConnectedDevices()
            centralManager?.scanForPeripherals(withServices: nil, options: nil)
            isScanning = true
        }
    }
    
    func stopScanning() {
        shouldScan = false
        centralManager?.stopScan()
        isScanning = false
    }
    
    private func retrieveConnectedDevices() {
        // Common services to look for to find connected devices
        let services = [
            CBUUID(string: "1800"), // Generic Access
            CBUUID(string: "1801"), // Generic Attribute
            CBUUID(string: "180A"), // Device Information
            CBUUID(string: "180F"), // Battery
            CBUUID(string: "1812")  // HID
        ]
        
        let connectedPeripherals = centralManager?.retrieveConnectedPeripherals(withServices: services) ?? []
        
        for peripheral in connectedPeripherals {
            let device = ScannedDevice(
                id: peripheral.identifier,
                name: peripheral.name,
                ipAddress: nil,
                macAddress: nil,
                rssi: 0, // RSSI is not available for retrieved peripherals without reading it
                type: .bluetooth,
                discoveryDate: Date(),
                connectionStatus: .connected
            )
            
            if !devices.contains(where: { $0.id == device.id }) {
                devices.append(device)
            }
        }
    }
}

extension BluetoothService: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        state = central.state
        if central.state == .poweredOn && shouldScan {
            startScanning()
        } else if central.state != .poweredOn {
            stopScanning()
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        let device = ScannedDevice(
            id: peripheral.identifier,
            name: peripheral.name,
            ipAddress: nil,
            macAddress: nil,
            rssi: RSSI.intValue,
            type: .bluetooth,
            discoveryDate: Date(),
            connectionStatus: .disconnected
        )
        
        if !devices.contains(where: { $0.id == device.id }) {
            devices.append(device)
        }
    }
}
