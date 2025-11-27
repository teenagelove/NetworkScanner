//
//  ScannerViewModel.swift
//  NetworkScanner
//
//  Created by Danil Kazakov on 2025/11/27.
//

import Combine
import Foundation
import CoreBluetooth

enum ScanType: CaseIterable, Identifiable {
    case bluetooth
    case lan
    
    var id: Self { self }
    
    var title: String {
        switch self {
        case .bluetooth: return Constants.ScanTypes.bluetooth
        case .lan: return Constants.ScanTypes.lan
        }
    }
}

enum ScannerViewState: Equatable {
    case idle
    case scanning
    case error(String)
}

//@MainActor
class ScannerViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var devices: [ScannedDevice] = []
    @Published var state: ScannerViewState = .idle
    @Published var scanType: ScanType = .bluetooth
    @Published var progress: Double = 0.0
    
    // MARK: - Private Properties
    
    private let bluetoothService = BluetoothService()
    private let lanScannerService = LanScannerService()
    private var cancellables = Set<AnyCancellable>()
    
    private var scanTimer: Timer?
    private let scanDuration: TimeInterval = 15.0
    
    // MARK: - Initialization
    
    init() {
        setupBindings()
    }
    
    // MARK: - Public Methods
    
    func startScanning() {
        devices.removeAll()
        state = .scanning
        progress = 0.0
        
        if scanType == .bluetooth {
            bluetoothService.startScanning()
            startTimer()
        } else {
            lanScannerService.startScanning()
        }
    }
    
    func stopScanning() {
        scanTimer?.invalidate()
        scanTimer = nil
        
        scanType == .bluetooth ? bluetoothService.stopScanning() : lanScannerService.stopScanning()

        state = .idle
    }
    
    func clear() {
        devices.removeAll()
        state = .idle
        progress = 0.0
    }
}

// MARK: - Private Methods

private extension ScannerViewModel {
    func setupBindings() {
        // Bluetooth Bindings
        bluetoothService.$devices
            .receive(on: DispatchQueue.main)
            .sink { [weak self] devices in
                if self?.scanType == .bluetooth {
                    self?.devices = devices
                }
            }
            .store(in: &cancellables)
            
        bluetoothService.$isScanning
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isScanning in
                if self?.scanType == .bluetooth {
                    if isScanning {
                        self?.state = .scanning
                    } else if self?.state == .scanning {
                        // Bluetooth service stopped on its own or we stopped it
                        // We handle the finish logic via the timer usually, but if it stops early:
                        if self?.progress ?? 0 >= 1.0 {
                             self?.finishScanning()
                        }
                    }
                }
            }
            .store(in: &cancellables)
            
        // LAN Bindings
        lanScannerService.$devices
            .receive(on: DispatchQueue.main)
            .sink { [weak self] devices in
                if self?.scanType == .lan {
                    self?.devices = devices
                }
            }
            .store(in: &cancellables)
            
        lanScannerService.$isScanning
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isScanning in
                if self?.scanType == .lan {
                    if isScanning {
                        self?.state = .scanning
                    } else if self?.state == .scanning {
                         self?.finishScanning()
                    }
                }
            }
            .store(in: &cancellables)
            
        lanScannerService.$progress
            .receive(on: DispatchQueue.main)
            .assign(to: \.progress, on: self)
            .store(in: &cancellables)
            
        // Clear list on scan type change
        $scanType
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.clear()
            }
            .store(in: &cancellables)
    }
    
    func startTimer() {
        scanTimer?.invalidate()
        let startTime = Date()
        
        scanTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            let elapsed = Date().timeIntervalSince(startTime)
            
            if elapsed >= self.scanDuration {
                self.progress = 1.0
                self.stopScanningAndFinish()
            } else {
                self.progress = elapsed / self.scanDuration
            }
        }
    }
    
    func stopScanningAndFinish() {
        scanTimer?.invalidate()
        scanTimer = nil
        
        if scanType == .bluetooth {
            bluetoothService.stopScanning()
        } else {
            lanScannerService.stopScanning()
        }
        finishScanning()
    }
    
    func finishScanning() {
        state = .idle
        saveSession()
    }
    
    func saveSession() {
        guard !devices.isEmpty else { return }
        Task {
            await CoreDataService.shared.saveSession(devices: devices)
        }
    }
}
