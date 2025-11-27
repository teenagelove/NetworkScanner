//
//  BluetoothConnectionStatus.swift
//  NetworkScanner
//
//  Created by Danil Kazakov on 2025/11/27.
//

enum BluetoothConnectionStatus: String {
    case disconnected = "Disconnected"
    case connecting = "Connecting..."
    case connected = "Connected"
    case disconnecting = "Disconnecting..."
    
    // MARK: - Properties
    
    var displayText: String {
        return self.rawValue
    }
}
