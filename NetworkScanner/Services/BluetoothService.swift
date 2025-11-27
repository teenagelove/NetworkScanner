//
//  BluetoothService.swift
//  NetworkScanner
//
//  Created by Danil Kazakov on 2025/11/27.
//

import CoreBluetooth

// MARK: - Bluetooth Errors

enum BluetoothError: LocalizedError {
    case bluetoothOff
    case unauthorized
    case unsupported
    
    var errorDescription: String? {
        switch self {
        case .bluetoothOff:
            return "Bluetooth is turned off. Please enable Bluetooth in Settings."
        case .unauthorized:
            return "Bluetooth access denied. Please allow Bluetooth access in Settings."
        case .unsupported:
            return "This device does not support Bluetooth."
        }
    }
}

// MARK: - Bluetooth Service

final class BluetoothService: NSObject {
    
    // MARK: - Private Properties
    
    private var continuation: CheckedContinuation<[ScannedDevice], Error>?
    private var centralManager: CBCentralManager!
    private var devices: [ScannedDevice] = []
    private var discoveredIDs = Set<UUID>()
    
    // MARK: - Public Methods

    func scan(duration: TimeInterval = 15) async throws -> [ScannedDevice] {
        devices.removeAll()
        discoveredIDs.removeAll()
        
        return try await withCheckedThrowingContinuation { continuation in
            self.continuation = continuation
            self.centralManager = CBCentralManager(delegate: self, queue: nil)
            
            Task {
                try? await Task.sleep(nanoseconds: UInt64(duration * 1_000_000_000))
                self.stopAndReturn()
            }
        }
    }
}

// MARK: - Private Methods

private extension BluetoothService {
    func stopAndReturn() {
        centralManager?.stopScan()
        continuation?.resume(returning: devices)
        continuation = nil
    }
    
    func retrieveConnectedDevices() {
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
        
        for peripheral in connectedPeripherals {
            addDevice(peripheral, rssi: 0, isConnected: true)
        }
    }
    
    func addDevice(_ peripheral: CBPeripheral, rssi: Int, isConnected: Bool = false) {
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
        
        devices.append(device)
    }
}

// MARK: - CBCentralManagerDelegate

extension BluetoothService: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            retrieveConnectedDevices()
            central.scanForPeripherals(withServices: nil)
            
        case .poweredOff:
            continuation?.resume(throwing: BluetoothError.bluetoothOff)
            
        case .unauthorized:
            continuation?.resume(throwing: BluetoothError.unauthorized)
            
        case .unsupported:
            continuation?.resume(throwing: BluetoothError.unsupported)
            
        default:
            break
        }
    }
    
    func centralManager(
        _ central: CBCentralManager,
        didDiscover peripheral: CBPeripheral,
        advertisementData: [String: Any],
        rssi RSSI: NSNumber
    ) {
        addDevice(peripheral, rssi: RSSI.intValue)
    }
}

// MARK: - BluetoothConnectionStatus Extension

extension BluetoothConnectionStatus {
    init(from peripheralState: CBPeripheralState) {
        switch peripheralState {
        case .connected:
            self = .connected
        case .connecting:
            self = .connecting
        case .disconnected:
            self = .disconnected
        case .disconnecting:
            self = .disconnecting
        @unknown default:
            self = .disconnected
        }
    }
}
