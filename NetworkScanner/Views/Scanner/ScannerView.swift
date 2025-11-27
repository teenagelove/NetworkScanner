//
//  ScannerView.swift
//  NetworkScanner
//
//  Created by Danil Kazakov on 2025/11/27.
//

import SwiftUI

struct ScannerView: View {
    
    // MARK: - State
    
    @StateObject private var viewModel = ScannerViewModel()
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            pickerView
            contentView
        }
        .navigationTitle(Constants.Titles.networkScanner)
    }
}

// MARK: - Private Views

private extension ScannerView {
    @ViewBuilder
    var contentView: some View {
        switch viewModel.state {
        case .idle:
            emptyDevicesList
        case .scanning:
            scanningView
        case .success(let devices):
            devicesList(devices: devices)
        case .error(let message):
            ErrorView(message: message) {
                viewModel.startScanning()
            }
        }
    }
    
    var pickerView: some View {
        Picker(Constants.Titles.scanType, selection: $viewModel.scanType) {
            ForEach(ScanType.allCases) { type in
                Text(type.title).tag(type)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding()
        .disabled(isScanning)
    }
    
    var scanningView: some View {
        VStack {
            ProgressView()
                .scaleEffect(2)
                .padding()
            
            Text(Constants.Labels.scanning)
                .font(.headline)
            
            ScanningProgressView(value: viewModel.progress)
                .frame(height: 8)
                .padding(.horizontal)
        }
        .frame(maxHeight: .infinity)
    }
    
    func devicesList(devices: [ScannedDevice]) -> some View {
        ZStack {
            if devices.isEmpty {
                emptyStateView
            } else {
                List(devices) { device in
                    NavigationLink(destination: DeviceDetailView(device: device)) {
                        DeviceRow(device: device)
                    }
                }
                .safeAreaInset(edge: .bottom) {
                    Color.clear.frame(height: 80)
                }
                .refreshable { viewModel.startScanning() }
            }
            
            VStack {
                Spacer()
                actionButton
            }
        }
    }
    
    var emptyDevicesList: some View {
        ZStack {
            emptyStateView
            
            VStack {
                Spacer()
                actionButton
            }
        }
    }
    
    var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: Constants.SFSymbols.scannerTab)
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text(Constants.Messages.noDevicesFound)
                .font(.headline)
                .foregroundColor(.gray)
            
            Text(Constants.Messages.tapToStartScanning)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.bottom, 80)
    }
    
    var actionButton: some View {
        Button(action: toggleScanning) {
            Text(isScanning ? Constants.Actions.stopScanning : Constants.Actions.startScanning)
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(isScanning ? Color.red : Color.blue)
                .cornerRadius(16)
        }
        .padding()
    }
}

// MARK: - Computed Properties

private extension ScannerView {
    var isScanning: Bool {
        if case .scanning = viewModel.state {
            return true
        }
        return false
    }
}

// MARK: - Actions

private extension ScannerView {
    func toggleScanning() {
        if isScanning {
            viewModel.stopScanning()
        } else {
            viewModel.startScanning()
        }
    }
}

// MARK: - Preview

#Preview {
    ScannerView()
}
