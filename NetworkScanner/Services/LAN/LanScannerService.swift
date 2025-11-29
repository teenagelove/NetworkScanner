//
//  LanScannerService.swift
//  NetworkScanner
//
//  Created by Danil Kazakov on 2025/11/27.
//

import Combine
import Foundation
import MMLanScan

// MARK: - LAN Scanner Errors

enum LanScannerError: LocalizedError {
    case scanFailed
    
    var errorDescription: String? {
        switch self {
        case .scanFailed:
            return Constants.Errors.lanScanFailed
        }
    }
}

// MARK: - LAN Scanner Service

final class LanScannerService: NSObject, LanScannerServiceProtocol {
    
    // MARK: - Publishers
    
    let devices = PassthroughSubject<ScannedDevice, Never>()
    let isScanning = CurrentValueSubject<Bool, Never>(false)
    let progress = CurrentValueSubject<Double, Never>(0.0)
    let error = PassthroughSubject<LanScannerError, Never>()
    
    // MARK: - Private Properties
    
    private var scanner: MMLANScanner?
    private var discoveredIPs = Set<String>()
    
    // MARK: - Init
    
    override init() {
        super.init()
        self.scanner = MMLANScanner(delegate: self)
    }
    
    deinit {
        stopScan()
        scanner?.delegate = nil
        scanner = nil
    }
    
    // MARK: - Public Methods
    
    func startScan() {
        stopScan()
        
        discoveredIPs.removeAll()
        isScanning.send(true)

        scanner?.start()
    }
    
    func stopScan() {
        scanner?.stop()
        isScanning.send(false)
        progress.send(0.0)
    }
}

// MARK: - Private Methods

private extension LanScannerService {
    func publishDevice(_ device: MMDevice) {
        guard let ip = device.ipAddress, !discoveredIPs.contains(ip) else { return }
        discoveredIPs.insert(ip)

        let scannedDevice = ScannedDevice(
            id: UUID(),
            name: deviceName(for: device),
            ipAddress: ip,
            macAddress: device.macAddress,
            rssi: 0,
            type: .lan,
            discoveryDate: Date(),
            connectionStatus: nil
        )
        
        devices.send(scannedDevice)
    }
    
    func deviceName(for device: MMDevice) -> String {
        if let hostname = device.hostname, !hostname.isEmpty {
            return hostname
        }
        
        if let brand = device.brand, !brand.isEmpty {
            return brand
        }
        
        return Constants.Devices.unknownDevice
    }
}

// MARK: - MMLANScannerDelegate

extension LanScannerService: MMLANScannerDelegate {
    func lanScanDidFindNewDevice(_ device: MMDevice!) {
        guard let device = device else { return }
        publishDevice(device)
    }
    
    func lanScanDidFinishScanning(with status: MMLanScannerStatus) {
        isScanning.send(false)
        progress.send(0)
    }
    
    func lanScanDidFailedToScan() {
        isScanning.send(false)
        error.send(.scanFailed)
    }
    
    func lanScanProgressPinged(_ pingedHosts: Float, from overallHosts: Int) {
        let currentProgress = Double(pingedHosts) / Double(overallHosts)
        progress.send(currentProgress)
    }
}
