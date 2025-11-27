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

    // MARK: - State

    enum State: Equatable {
        case idle
        case scanning
        case success([ScannedDevice])
        case error(String)
    }

    // MARK: - Published Properties

    @Published var state: State = .idle
    @Published var progress: CGFloat = 0
    @Published var scanType: ScanType = .bluetooth {
        didSet { clear() }
    }

    // MARK: - Private Properties

    private let bluetoothService = BluetoothService()
    private let lanScannerService = LanScannerService()
    private var scanTask: Task<Void, Never>?

    // MARK: - Public Methods

    func startScanning() {
        state = .scanning
        progress = 0

        scanTask = Task {
            do {
                scanType == .bluetooth ? try await scanBluetooth() : try await scanLAN()
            } catch {
                state = .error(error.localizedDescription)
            }
        }

        withAnimation(.linear(duration: Constants.Timing.scanDuration)) {
            progress = 1
        }
    }

    func stopScanning() {
        scanTask?.cancel()
        scanTask = nil
        state = .idle
    }

    func clear() {
        state = .idle
        progress = 0.0
    }
}

// MARK: - Private Methods

private extension ScannerViewModel {
    func scanBluetooth() async throws {
        let scannedDevices = try await bluetoothService.scan(duration: Constants.Timing.scanDuration)

        state = .success(scannedDevices)
        try await saveSession(devices: scannedDevices)
    }

    func scanLAN() async throws {
        let scannedDevices = await lanScannerService.scan(duration: Constants.Timing.scanDuration)

        state = .success(scannedDevices)
        try await saveSession(devices: scannedDevices)
    }

    func saveSession(devices: [ScannedDevice]) async throws {
        guard !devices.isEmpty else { return }

        try await CoreDataService.shared.saveSession(devices: devices)
    }
}
