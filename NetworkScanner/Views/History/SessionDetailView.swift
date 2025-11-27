//
//  SessionDetailView.swift
//  NetworkScanner
//
//  Created by Danil Kazakov on 2025/11/27.
//

import SwiftUI

struct SessionDetailView: View {
    
    // MARK: - State
    
    @StateObject private var viewModel: SessionDetailViewModel
    
    // MARK: - Initialization
    
    init(session: ScanSessionModel) {
        _viewModel = StateObject(wrappedValue: SessionDetailViewModel(session: session))
    }
    
    // MARK: - Body
    
    var body: some View {
        Group {
            switch viewModel.state {
            case .idle, .loading:
                ProgressView()
            case .success(let devices):
                List(devices) { device in
                    DeviceDetailRow(device: device)
                }
            case .error(let message):
                ErrorView(message: message) {
                    viewModel.fetchDevices()
                }
            }
        }
        .navigationTitle(Constants.Titles.sessionDetails)
        .searchable(text: $viewModel.searchText, prompt: Constants.Placeholders.searchDeviceName)
    }
}

#Preview {
    NavigationView {
        SessionDetailView(session: .mock)
    }
}