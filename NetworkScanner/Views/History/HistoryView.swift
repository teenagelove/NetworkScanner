//
//  HistoryView.swift
//  NetworkScanner
//
//  Created by Danil Kazakov on 2025/11/27.
//

import SwiftUI

struct HistoryView: View {
    
    // MARK: - State
    
    @StateObject private var viewModel = HistoryViewModel()
    
    // MARK: - Body
    
    var body: some View {
        Group {
            switch viewModel.state {
            case .idle, .loading:
                ProgressView()
            case .success(let sessions):
                sessionsList(sessions)
            case .error(let message):
                ErrorView(message: message) {
                    viewModel.fetchSessions()
                }
            }
        }
        .navigationTitle(Constants.Titles.history)
        .toolbar {
            ToolbarItem(placement: .title) {
                filterView
            }
        }
        .task {
            viewModel.fetchSessions()
        }
    }
}

private extension HistoryView {
    
    // MARK: - View Components
    
    func sessionsList(_ sessions: [ScanSessionModel]) -> some View {
        List(sessions) { session in
            NavigationLink(destination: SessionDetailView(session: session)) {
                SessionRow(session: session)
            }
            .swipeActions(edge: .trailing) {
                DeleteButton {viewModel.deleteSession( session) }
            }
        }
    }
    
    var filterView: some View {
        HStack {
            DatePicker(Constants.Labels.selectDate, selection: $viewModel.selectedDate, displayedComponents: [.date, .hourAndMinute])
                .datePickerStyle(CompactDatePickerStyle())
                .labelsHidden()
                .onChange(of: viewModel.selectedDate) { _ in
                    viewModel.isDateFilterEnabled = true
                    viewModel.fetchSessions()
                }
            
            if viewModel.isDateFilterEnabled {
                Button {
                    viewModel.isDateFilterEnabled = false
                    viewModel.fetchSessions()
                } label: {
                    Image(systemName: Constants.SFSymbols.xmark)
                        .foregroundColor(.gray)
                }
            }
        }
    }
}

#Preview("HistoryView") {
    NavigationView {
        HistoryView()
    }
}

