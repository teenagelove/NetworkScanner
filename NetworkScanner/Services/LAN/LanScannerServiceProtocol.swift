//
//  LanScannerServiceProtocol.swift
//  NetworkScanner
//
//  Created by Danil Kazakov on 2025/11/28.
//

import Combine

// MARK: - LAN Scanner Service Protocol

protocol LanScannerServiceProtocol {
    var devices: PassthroughSubject<ScannedDevice, Never> { get }
    var isScanning: CurrentValueSubject<Bool, Never> { get }
    var progress: CurrentValueSubject<Double, Never> { get }
    var error: PassthroughSubject<LanScannerError, Never> { get }
    
    func startScan()
    func stopScan()
}
