//
//  ScannedDevice.swift
//  NetworkScanner
//
//  Created by Danil Kazakov on 2025/11/27.
//

import Foundation

// MARK: - Scanned Device

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
}

// MARK: - Device Type

extension ScannedDevice {
    enum DeviceType: String {
        case bluetooth = "Bluetooth"
        case lan = "LAN"
    }
}
