//
//  ScannerView.swift
//  NetworkScanner
//
//  Created by Danil Kazakov on 2025/11/27.
//

import SwiftUI

// MARK: - Scanner View

struct ScannerView: View {

    // MARK: - State

    @StateObject private var viewModel: ScannerViewModel

    // MARK: - Init

    init() {
        self.init(viewModel: ScannerViewModel())
    }

    init(viewModel: ScannerViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    // MARK: - Body

    var body: some View {
        VStack(spacing: 0) {
            pickerView

            progressView

            contentView
        }
        .navigationTitle(Constants.Titles.networkScanner)
    }
}

// MARK: - Private Views

private extension ScannerView {
    @ViewBuilder
    var contentView: some View {
        if let errorMessage = viewModel.errorMessage {
            ErrorView(message: errorMessage) {
                viewModel.startScanning()
            }
        } else {
            devicesList
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
        .disabled(viewModel.isScanning)
    }

    var devicesList: some View {
        ZStack {
            if viewModel.scannedDevices.isEmpty && !viewModel.isScanning {
                emptyStateView
            } else {
                List(viewModel.scannedDevices) { device in
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

    var emptyStateView: some View {
        VStack(spacing: 16) {
            EmptyLottieView()

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
        Button {
            viewModel.toggleScanning()
        } label: {
            HStack {
                if viewModel.isScanning {
                    ScanLottieView()
                        .frame(height: 20)
                }

                Text(viewModel.isScanning ? Constants.Actions.stopScanning : Constants.Actions.startScanning)
                    .font(.headline)
                    .foregroundColor(.white)
            }
            .padding()
            .background(viewModel.isScanning ? Color.red : Color.blue)
            .clipShape(RoundedRectangle(cornerRadius: 18))
        }
        .padding()
    }

    var progressView: some View {
        ScanningProgressView(value: viewModel.progress)
            .opacity(viewModel.isScanning ? 1 : 0)
            .id(viewModel.animationID)
    }
}

// MARK: - Preview

#Preview {
    ScannerView(viewModel: .mock)
}
