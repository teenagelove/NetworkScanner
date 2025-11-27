//
//  LanScannerService.swift
//  NetworkScanner
//
//  Created by Danil Kazakov on 2025/11/27.
//

import Combine
import Foundation

class LanScannerService: ObservableObject {
    @Published var devices: [ScannedDevice] = []
    @Published var isScanning = false
    @Published var progress: Double = 0.0
    
    private var timer: Timer?
    
    // Placeholder for actual LanScan library integration
    // Since we cannot fetch external dependencies without internet/user action,
    // we simulate scanning for demonstration purposes.
    
    func startScanning() {
        guard !isScanning else { return }
        isScanning = true
        progress = 0.0
        devices.removeAll()
        
        // Simulate scanning process
        var currentProgress = 0.0
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            currentProgress += 0.01
            self.progress = min(currentProgress, 1.0)
            
            if currentProgress >= 1.0 {
                self.stopScanning()
            }
            
            // Simulate finding devices
            if Int(currentProgress * 100) % 20 == 0 && currentProgress < 0.9 {
                self.addMockDevice()
            }
        }
    }
    
    func stopScanning() {
        isScanning = false
        timer?.invalidate()
        timer = nil
        progress = 1.0
    }
    
    private func addMockDevice() {
        let id = UUID()
        let device = ScannedDevice(
            id: id,
            name: "LAN Device \(Int.random(in: 1...100))",
            ipAddress: "192.168.1.\(Int.random(in: 2...254))",
            macAddress: "00:1A:2B:3C:4D:\(Int.random(in: 10...99))",
            rssi: 0,
            type: .lan,
            discoveryDate: Date(),
            connectionStatus: nil
        )
        devices.append(device)
    }
}
