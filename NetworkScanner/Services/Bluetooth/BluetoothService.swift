//
//  BluetoothService.swift
//  NetworkScanner
//
//  Created by Danil Kazakov on 2025/11/27.
//

import Combine
import CoreBluetooth

// MARK: - Bluetooth Errors

enum BluetoothError: LocalizedError {
    case bluetoothOff
    case unauthorized
    case unsupported
    
    var errorDescription: String? {
        switch self {
        case .bluetoothOff:
            return Constants.Errors.bluetoothOff
        case .unauthorized:
            return Constants.Errors.bluetoothUnauthorized
        case .unsupported:
            return Constants.Errors.bluetoothUnsupported
        }
    }
}

final class BluetoothService: NSObject, BluetoothServiceProtocol {
    
    // MARK: - Publishers
    
    let devices = PassthroughSubject<ScannedDevice, Never>()
    let error = CurrentValueSubject<BluetoothError?, Never>(nil)
    let isScanning = CurrentValueSubject<Bool, Never>(false)
    
    // MARK: - Private Properties
    
    private var centralManager: CBCentralManager?
    private var discoveredIDs = Set<UUID>()

    // MARK: - Init
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    deinit {
        stopScan()
        centralManager?.delegate = nil
        centralManager = nil
    }
    
    // MARK: - Public Methods
    
    func startScan() {
        guard let centralManager else { return }

        isScanning.send(true)
        discoveredIDs.removeAll()
        
        if centralManager.state == .poweredOn {
            startCoreBluetoothScan()
        }
    }
    
    func stopScan() {
        isScanning.send(false)
        centralManager?.stopScan()
    }
}

// MARK: - Private Methods

private extension BluetoothService {
    func startCoreBluetoothScan() {
        retrieveConnectedDevices()
        centralManager?.scanForPeripherals(withServices: nil)
    }
    
    func retrieveConnectedDevices() {
        guard let centralManager else { return }

        let services = [
            CBUUID(string: "1800"), // Generic Access
            CBUUID(string: "1801"), // Generic Attribute
            CBUUID(string: "180A"), // Device Information
            CBUUID(string: "180F"), // Battery
            CBUUID(string: "1812"), // HID
            CBUUID(string: "110A"), // A2DP (Audio)
            CBUUID(string: "110B"), // A2DP Sink
            CBUUID(string: "110C"), // AVRCP (Remote Control)
            CBUUID(string: "111E"), // HFP (Handsfree)
        ]
        
        let connectedPeripherals = centralManager.retrieveConnectedPeripherals(withServices: services)
        connectedPeripherals.forEach { publishDevice($0, rssi: 0, isConnected: true) }
    }
    
    func publishDevice(_ peripheral: CBPeripheral, rssi: Int, isConnected: Bool = false) {
        guard !discoveredIDs.contains(peripheral.identifier) else { return }
        discoveredIDs.insert(peripheral.identifier)
        
        let status: BluetoothConnectionStatus = isConnected ? .connected : BluetoothConnectionStatus(from: peripheral.state)
        
        let device = ScannedDevice(
            id: peripheral.identifier,
            name: peripheral.name,
            ipAddress: nil,
            macAddress: nil,
            rssi: rssi,
            type: .bluetooth,
            discoveryDate: Date(),
            connectionStatus: status
        )
        
        devices.send(device)
    }
}

// MARK: - CBCentralManagerDelegate

extension BluetoothService: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            error.send(nil)
            if isScanning.value {
                startCoreBluetoothScan()
            }
        case .poweredOff:
            error.send(.bluetoothOff)
        case .unauthorized:
            error.send(.unauthorized)
        case .unsupported:
            error.send(.unsupported)
        default:
            break
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        publishDevice(peripheral, rssi: RSSI.intValue)
    }
}

// MARK: - BluetoothConnectionStatus Extension

extension BluetoothConnectionStatus {
    init(from peripheralState: CBPeripheralState) {
        switch peripheralState {
        case .connected: self = .connected
        case .connecting: self = .connecting
        case .disconnected: self = .disconnected
        case .disconnecting: self = .disconnecting
        @unknown default: self = .disconnected
        }
    }
}
