//
//  ScannedDevice.swift
//  NetworkScanner
//
//  Created by Danil Kazakov on 2025/11/27.
//

import Foundation

struct ScannedDevice: Identifiable, Hashable {
    
    // MARK: - Properties
    
    let id: UUID
    let name: String?
    let ipAddress: String?
    let macAddress: String?
    let rssi: Int
    let type: DeviceType
    let discoveryDate: Date
    let connectionStatus: BluetoothConnectionStatus?
    
    // MARK: - Types
    
    enum DeviceType: String {
        case bluetooth = "Bluetooth"
        case lan = "LAN"
    }
    
    enum BluetoothConnectionStatus: String {
        case disconnected = "Disconnected"
        case connecting = "Connecting..."
        case connected = "Connected"
        
        var displayText: String {
            return self.rawValue
        }
        
        init(from peripheralState: Int) {
            switch peripheralState {
            case 0: // CBPeripheralState.disconnected
                self = .disconnected
            case 1: // CBPeripheralState.connecting
                self = .connecting
            case 2: // CBPeripheralState.connected
                self = .connected
            default:
                self = .disconnected
            }
        }
    }
}
