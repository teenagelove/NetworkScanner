//
//  HistoryViewModel.swift
//  NetworkScanner
//
//  Created by Danil Kazakov on 2025/11/27.
//

import Combine
import Foundation

@MainActor
final class HistoryViewModel: ObservableObject {

    // MARK: - State

    enum State: Equatable {
        case idle
        case loading
        case success([ScanSessionModel])
        case error(String)
    }

    // MARK: - Published Properties

    @Published var state: State = .idle
    @Published var selectedDate: Date = Date()
    @Published var isDateFilterEnabled = false

    // MARK: - Public Methods

    func fetchSessions() {
        state = .loading

        Task {
            do {
                let dateFilter = isDateFilterEnabled ? selectedDate : nil
                let sessions = try await CoreDataService.shared.fetchSessions(dateFilter: dateFilter)
                state = .success(sessions)
            } catch {
                state = .error(error.localizedDescription)
            }
        }
    }

    func deleteSession(_ session: ScanSessionModel) {
        guard case .success(var currentSessions) = state else { return }

        currentSessions.removeAll(where: { $0.id == session.id } )

        Task {
            do {
                try await CoreDataService.shared.deleteSession(withId: session.id)
                state = .success(currentSessions)
            } catch {
                state = .error(error.localizedDescription)
            }
        }
    }
}
