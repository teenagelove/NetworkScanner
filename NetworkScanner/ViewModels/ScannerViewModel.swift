//
//  ScannerViewModel.swift
//  NetworkScanner
//
//  Created by Danil Kazakov on 2025/11/27.
//

import Combine
import Foundation
import SwiftUI

// MARK: - Scanner ViewModel

@MainActor
final class ScannerViewModel: ObservableObject {

    // MARK: - Published Properties

    @Published var scannedDevices: [ScannedDevice] = []
    @Published var isScanning = false
    @Published var errorMessage: String?
    @Published var progress: CGFloat = .zero
    @Published var animationID = UUID()
    @Published var scanType: ScanType = .bluetooth {
        didSet { clear() }
    }

    // MARK: - Private Properties

    private let bluetoothService: BluetoothServiceProtocol
    private let lanScannerService: LanScannerServiceProtocol
    private let coreDataService: CoreDataServiceProtocol
    private var scanTask: Task<Void, Never>?
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Init

    convenience init() {
        self.init(
            bluetoothService: BluetoothService(),
            lanScannerService: LanScannerService(),
            coreDataService: CoreDataService.shared
        )
    }

    init(
        bluetoothService: BluetoothServiceProtocol,
        lanScannerService: LanScannerServiceProtocol,
        coreDataService: CoreDataServiceProtocol
    ) {
        self.bluetoothService = bluetoothService
        self.lanScannerService = lanScannerService
        self.coreDataService = coreDataService
    }

    // MARK: - Public Methods

    func toggleScanning() {
        if isScanning {
            stopScanning()
        } else {
            startScanning()
        }
    }

    func startScanning() {
        clear()

        animationID = UUID()

        scanTask = Task {
            do {
                scanType == .bluetooth ? try await scanBluetooth() : try await scanLAN()
            } catch is CancellationError {
                isScanning = false
            } catch {
                errorMessage = error.localizedDescription
                isScanning = false
            }
        }

        if scanType == .bluetooth {
            withAnimation(.linear(duration: Constants.Timing.scanDuration)) {
                progress = 15
            }
        }
    }

    func stopScanning() {
        isScanning = false
        scanTask?.cancel()
        scanTask = nil
        scanType == .bluetooth ? bluetoothService.stopScan() : lanScannerService.stopScan()
        cancellables.removeAll()
    }

    func clear() {
        scannedDevices = []
        progress = 0
        errorMessage = nil
        cancellables.removeAll()
    }
}

// MARK: - Private Methods

private extension ScannerViewModel {
    func scanBluetooth() async throws {
        // Subscribe to devices
        bluetoothService.devices
            .receive(on: DispatchQueue.main)
            .sink { [weak self] device in
                self?.scannedDevices.append(device)
            }
            .store(in: &cancellables)

        // Bind scanning state
        bluetoothService.isScanning
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isScanning in
                self?.isScanning = isScanning
            }
            .store(in: &cancellables)

        // Subscribe to errors
        bluetoothService.error
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                    self?.stopScanning()
                }
            }
            .store(in: &cancellables)

        bluetoothService.startScan()

        try await Task.sleep(nanoseconds: UInt64(Constants.Timing.scanDuration * 1_000_000_000))

        bluetoothService.stopScan()

        try await saveSession(devices: scannedDevices)
    }

    func scanLAN() async throws {
        // Subscribe to devices
        lanScannerService.devices
            .receive(on: DispatchQueue.main)
            .sink { [weak self] device in
                self?.scannedDevices.append(device)
            }
            .store(in: &cancellables)

        // Subscribe to progress
        lanScannerService.progress
            .receive(on: DispatchQueue.main)
            .sink { [weak self] progress in
                withAnimation {
                    self?.progress = progress
                }
            }
            .store(in: &cancellables)

        // Subscribe to errors
        lanScannerService.error
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                self?.errorMessage = error.localizedDescription
                self?.stopScanning()
            }
            .store(in: &cancellables)

        // Bind scanning state
        lanScannerService.isScanning
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isScanning in
                self?.isScanning = isScanning
            }
            .store(in: &cancellables)

        lanScannerService.startScan()

        // Wait until scanning is finished
        for await isScanning in lanScannerService.isScanning.values {
            if !isScanning { break }
        }

        try await saveSession(devices: scannedDevices)
    }

    func saveSession(devices: [ScannedDevice]) async throws {
        guard !devices.isEmpty else { return }

        try await coreDataService.saveSession(devices: devices)
    }
}
