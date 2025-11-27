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
    
    var body: some View {
        VStack {
            pickerView
            
            contentView
        }
        .navigationTitle(Constants.Titles.networkScanner)
    }
}

private extension ScannerView {
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
    
    @ViewBuilder
    var contentView: some View {
        switch viewModel.state {
        case .idle:
            devicesList
        case .scanning:
            scanningView
        case .error(let message):
            ErrorView(message: message) {
                viewModel.startScanning()
            }
        }
    }
    
    var scanningView: some View {
        VStack {
            ProgressView()
                .scaleEffect(2)
                .padding()
            
            Text(Constants.Labels.scanning)
                .font(.headline)
            
            ProgressView(value: viewModel.progress)
                .padding()
        }
        .frame(maxHeight: .infinity)
    }
    
    var devicesList: some View {
        ZStack {
//            if viewModel.devices.isEmpty {
//                emptyStateView
//            } else {
                List(viewModel.devices) { device in
                    NavigationLink(destination: DeviceDetailView(device: device)) {
                        DeviceRow(device: device)
                    }
                }
                .padding(.bottom, 80)
//            }

            if case .error = viewModel.state {
                EmptyView()
            } else {
                VStack {
                    Spacer()

                    actionButton
                }
            }
        }
    }
    
    var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "antenna.radiowaves.left.and.right")
                .font(.system(size: 60))
                .foregroundColor(.gray)

            Text("No devices found yet")
                .font(.headline)
                .foregroundColor(.gray)

            Text("Tap 'Start Scanning' to search for nearby devices")
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
    
    var isScanning: Bool {
        if case .scanning = viewModel.state {
            return true
        }
        return false
    }
    
    func toggleScanning() {
        if isScanning {
            viewModel.stopScanning()
        } else {
            viewModel.startScanning()
        }
    }
}

#Preview() {
    ScannerView()
}

