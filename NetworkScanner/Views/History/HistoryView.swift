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
        List(viewModel.sessions) { session in
            NavigationLink(destination: SessionDetailView(session: session)) {
                SessionRow(session: session)
            }
            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                Button(role: .destructive) {
                    viewModel.deleteSession(session)
                } label: {
                    Label(Constants.Actions.delete, systemImage: Constants.SFSymbols.trash)
                }
            }
        }
        .navigationTitle(Constants.Titles.history)
        .toolbar {
            ToolbarItem(placement: .title) {
                filterView
            }
        }
        .onAppear {
            viewModel.fetchSessions()
        }
    }
}

private extension HistoryView {
    
    // MARK: - View Components
    
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
                    Image(systemName: "xmark.circle.fill")
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

