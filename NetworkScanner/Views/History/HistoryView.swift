//
//  HistoryView.swift
//  NetworkScanner
//
//  Created by Danil Kazakov on 2025/11/27.
//

import SwiftUI

// MARK: - History View

struct HistoryView: View {
    
    // MARK: - State
    
    @StateObject private var viewModel: HistoryViewModel
    @State private var showDatePicker = false
    
    // MARK: - Init

    init() {
        self.init(viewModel: HistoryViewModel())
    }

    init(viewModel: HistoryViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    // MARK: - Body
    
    var body: some View {
        Group {
            switch viewModel.state {
            // Too fast loading, so removed loading state & ProgressView
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
            ToolbarItem(placement: .topBarTrailing) {
                filterView
            }
        }
        .sheet(isPresented: $showDatePicker) {
            DatePickerSheet(
                selectedDate: $viewModel.selectedDate,
                isPresented: $showDatePicker
            ) {
                viewModel.isDateFilterEnabled = true
                viewModel.fetchSessions()
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
        Group {
            if sessions.isEmpty {
                emptyStateView
            } else {
                ZStack {
                    List(sessions) { session in
                        NavigationLink(destination: SessionDetailView(session: session)) {
                            SessionRowView(session: session)
                        }
                        .swipeActions(edge: .trailing) {
                            DeleteButton { viewModel.deleteSession(session) }
                        }
                    }
                }
            }
        }
    }
    
    var emptyStateView: some View {
        VStack(spacing: 16) {
            EmptyLottieView()

            Text(Constants.Messages.noSessionsFound)
                .font(.headline)
                .foregroundColor(.gray)
            
            Text(Constants.Messages.startScanningToSeeHistory)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    var filterView: some View {
        HStack {
            Button {
                showDatePicker = true
            } label: {
                HStack {
                    Image(systemName: Constants.SFSymbols.calendar)
                    if viewModel.isDateFilterEnabled {
                        Text(viewModel.selectedDate.formatted(date: .numeric, time: .shortened))
                            .font(.caption)
                    }
                }
                .padding(8)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
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
        HistoryView(viewModel: .mock)
    }
}
