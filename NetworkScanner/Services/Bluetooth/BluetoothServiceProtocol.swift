//
//  BluetoothServiceProtocol.swift
//  NetworkScanner
//
//  Created by Danil Kazakov on 2025/11/28.
//

import Combine

// MARK: - Bluetooth Service Protocol

protocol BluetoothServiceProtocol {
    var devices: PassthroughSubject<ScannedDevice, Never> { get }
    var error: CurrentValueSubject<BluetoothError?, Never> { get }
    var isScanning: CurrentValueSubject<Bool, Never> { get }
    
    func startScan()
    func stopScan()
}
