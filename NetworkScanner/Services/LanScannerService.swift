//
//  LanScannerService.swift
//  NetworkScanner
//
//  Created by Danil Kazakov on 2025/11/27.
//

import Foundation

// MARK: - LAN Scanner Service

final class LanScannerService {
    
    // MARK: - Private Properties
    
    private var devices: [ScannedDevice] = []
    private var continuation: CheckedContinuation<[ScannedDevice], Never>?
    
    // MARK: - Public Methods
    
    /// Scans the local network for the specified duration
    /// - Parameter duration: Scan duration in seconds
    /// - Returns: Array of discovered devices
    func scan(duration: TimeInterval = 15) async -> [ScannedDevice] {
        devices.removeAll()
        
        return await withCheckedContinuation { continuation in
            self.continuation = continuation
            
            Task {
                await simulateScan(duration: duration)
                self.stopAndReturn()
            }
        }
    }
}

// MARK: - Private Methods

private extension LanScannerService {
    func simulateScan(duration: TimeInterval) async {
        let totalSteps = Int(duration * 10)
        
        for step in 0..<totalSteps {
            if step % 20 == 0 && step > 0 && step < totalSteps - 10 {
                addMockDevice()
            }
            
            try? await Task.sleep(nanoseconds: Constants.Timing.progressUpdateInterval)
        }
    }
    
    func addMockDevice() {
        let device = ScannedDevice(
            id: UUID(),
            name: "LAN Device \(Int.random(in: 1...100))",
            ipAddress: "192.168.1.\(Int.random(in: 2...254))",
            macAddress: "00:1A:2B:3C:4D:\(String(format: "%02X", Int.random(in: 10...99)))",
            rssi: 0,
            type: .lan,
            discoveryDate: Date(),
            connectionStatus: nil
        )
        
        devices.append(device)
    }
    
    func stopAndReturn() {
        continuation?.resume(returning: devices)
        continuation = nil
    }
}
