//
//  ScannedDevice+Mock.swift
//  NetworkScanner
//
//  Created by Danil Kazakov on 2025/11/27.
//

import Foundation

extension ScannedDevice {
    static let mock = mocks[0]
    
    static let mocks: [ScannedDevice] = [
        ScannedDevice(
            id: UUID(),
            name: "iPhone 13 Pro",
            ipAddress: "192.168.1.10",
            macAddress: "00:1A:2B:3C:4D:5E",
            rssi: -45,
            type: .lan,
            discoveryDate: Date(),
            connectionStatus: nil
        ),
        ScannedDevice(
            id: UUID(),
            name: "MacBook Pro",
            ipAddress: "192.168.1.11",
            macAddress: "A1:B2:C3:D4:E5:F6",
            rssi: -60,
            type: .lan,
            discoveryDate: Date().addingTimeInterval(-3600),
            connectionStatus: nil
        ),
        ScannedDevice(
            id: UUID(),
            name: "Smart TV",
            ipAddress: "192.168.1.15",
            macAddress: "11:22:33:44:55:66",
            rssi: -75,
            type: .lan,
            discoveryDate: Date().addingTimeInterval(-7200),
            connectionStatus: nil
        ),
        ScannedDevice(
            id: UUID(),
            name: "Unknown Device",
            ipAddress: "192.168.1.20",
            macAddress: "AA:BB:CC:DD:EE:FF",
            rssi: 0,
            type: .lan,
            discoveryDate: Date().addingTimeInterval(-10000),
            connectionStatus: nil
        ),
        ScannedDevice(
            id: UUID(),
            name: "Bluetooth Speaker",
            ipAddress: nil,
            macAddress: "BB:CC:DD:EE:FF:00",
            rssi: -50,
            type: .bluetooth,
            discoveryDate: Date(),
            connectionStatus: .connected
        ),
        ScannedDevice(
            id: UUID(),
            name: "Apple Watch",
            ipAddress: nil,
            macAddress: "CC:DD:EE:FF:00:11",
            rssi: -80,
            type: .bluetooth,
            discoveryDate: Date().addingTimeInterval(-500),
            connectionStatus: .disconnected
        ),
        ScannedDevice(
            id: UUID(),
            name: "iPad Air",
            ipAddress: "192.168.1.12",
            macAddress: "DD:EE:FF:00:11:22",
            rssi: -55,
            type: .lan,
            discoveryDate: Date().addingTimeInterval(-1500),
            connectionStatus: nil
        ),
        ScannedDevice(
            id: UUID(),
            name: "Printer",
            ipAddress: "192.168.1.50",
            macAddress: "EE:FF:00:11:22:33",
            rssi: -70,
            type: .lan,
            discoveryDate: Date().addingTimeInterval(-3000),
            connectionStatus: nil
        ),
        ScannedDevice(
            id: UUID(),
            name: "Game Console",
            ipAddress: "192.168.1.30",
            macAddress: "FF:00:11:22:33:44",
            rssi: -65,
            type: .lan,
            discoveryDate: Date().addingTimeInterval(-4000),
            connectionStatus: nil
        ),
        ScannedDevice(
            id: UUID(),
            name: "Thermostat",
            ipAddress: "192.168.1.40",
            macAddress: "00:11:22:33:44:55",
            rssi: -85,
            type: .lan,
            discoveryDate: Date().addingTimeInterval(-5000),
            connectionStatus: nil
        )
    ]
}
