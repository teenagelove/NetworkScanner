//
//  Constants.swift
//  NetworkScanner
//
//  Created by Danil Kazakov on 2025/11/27.
//

import Foundation

enum Constants {
    enum SFSymbols {
        static let scannerTab = "antenna.radiowaves.left.and.right"
        static let historyTab = "clock.arrow.circlepath"
        static let bluetoothIcon = "wave.3.right"
        static let lanIcon = "network"
        static let triangle = "exclamationmark.triangle"
        static let clockwise = "arrow.clockwise"
        static let trash = "trash"
    }
    
    enum Titles {
        static let scanner = "Scanner"
        static let history = "History"
        static let networkScanner = "Network Scanner"
        static let sessionDetails = "Session Details"
        static let scanType = "Scan Type"
        static let scanComplete = "Scan Complete"
    }
    
    enum Actions {
        static let delete = "Delete"
        static let ok = "OK"
        static let stopScanning = "Stop Scanning"
        static let startScanning = "Start Scanning"
        static let repeatAction = "Repeat"
    }
    
    enum Placeholders {
        static let searchDeviceName = "Search by device name"
        static let unknown = "Unknown"
    }
    
    enum Labels {
        static let filterByDate = "Filter by Date"
        static let selectDate = "Select Date"
        static let scanning = "Scanning..."
        static let ipPrefix = "IP: "
        static let macPrefix = "MAC: "
        static let rssiPrefix = "RSSI: "
        static let datePrefix = "Date: "
        static let rssiUnit = " dBm"
        
        static func devicesFound(_ count: Int) -> String {
            "\(count) devices found"
        }
        
        static func foundDevices(_ count: Int) -> String {
            "Found \(count) devices."
        }
    }
    
    enum ScanTypes {
        static let bluetooth = "Bluetooth"
        static let lan = "LAN"
    }
}
