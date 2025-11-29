//
//  SessionDetailView.swift
//  NetworkScanner
//
//  Created by Danil Kazakov on 2025/11/27.
//

import SwiftUI

// MARK: - Session Detail View

struct SessionDetailView: View {
    
    // MARK: - State
    
    @StateObject private var viewModel: SessionDetailViewModel
    
    // MARK: - Initialization
    
    init(session: ScanSessionModel) {
        _viewModel = StateObject(wrappedValue: SessionDetailViewModel(session: session))
    }
    
    init(viewModel: SessionDetailViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    // MARK: - Body
    
    var body: some View {
        Group {
            switch viewModel.state {
            case .success(let devices):
                List(devices) { device in
                    NavigationLink(destination: DeviceDetailView(device: device)) {
                        SessionsDeviceRowView(device: device)
                    }
                }
            case .error(let message):
                ErrorView(message: message) {
                    viewModel.fetchDevices()
                }
            }
        }
        .navigationTitle(Constants.Titles.sessionDetails)
        .searchable(text: $viewModel.searchText, prompt: Constants.Placeholders.searchDeviceName)
        .onAppear {
            viewModel.fetchDevices()
        }
    }
}

#Preview {
    NavigationView {
        SessionDetailView(viewModel: .mock)
    }
}
