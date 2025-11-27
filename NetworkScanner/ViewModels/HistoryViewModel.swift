//
//  HistoryViewModel.swift
//  NetworkScanner
//
//  Created by Danil Kazakov on 2025/11/27.
//

import Combine
import Foundation

@MainActor
class HistoryViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var sessions: [ScanSessionModel] = []
    @Published var selectedDate: Date = Date()
    @Published var isDateFilterEnabled = false
    
    // MARK: - Public Methods
    
    func fetchSessions() {
        Task {
            let dateFilter = isDateFilterEnabled ? selectedDate : nil
            let fetchedSessions = await CoreDataService.shared.fetchSessions(dateFilter: dateFilter)
            self.sessions = fetchedSessions
        }
    }
    
    func deleteSession(_ session: ScanSessionModel) {
        Task {
            await CoreDataService.shared.deleteSession(withId: session.id)
            fetchSessions()
        }
    }
}
