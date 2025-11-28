//
//  HistoryViewModel.swift
//  NetworkScanner
//
//  Created by Danil Kazakov on 2025/11/27.
//

import Combine
import Foundation

// MARK: - History View Model

@MainActor
final class HistoryViewModel: ObservableObject {

    // MARK: - State

    enum State: Equatable {
        case success([ScanSessionModel])
        case error(String)
    }

    // MARK: - Published Properties

    @Published var state: State = .success([])
    @Published var selectedDate: Date = Date()
    @Published var isDateFilterEnabled = false

    // MARK: - Private Properties

    private let coreDataService: CoreDataServiceProtocol

    // MARK: - Init

    init(coreDataService: CoreDataServiceProtocol = CoreDataService.shared) {
        self.coreDataService = coreDataService
    }

    // MARK: - Public Methods

    func fetchSessions() {
        Task {
            do {
                let dateFilter = isDateFilterEnabled ? selectedDate : nil
                let sessions = try await coreDataService.fetchSessions(dateFilter: dateFilter)
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
                try await coreDataService.deleteSession(withId: session.id)
                state = .success(currentSessions)
            } catch {
                state = .error(error.localizedDescription)
            }
        }
    }
}
