//
//  SessionDetailViewModel.swift
//  NetworkScanner
//
//  Created by Danil Kazakov on 2025/11/27.
//

import Combine
import Foundation

@MainActor
final class SessionDetailViewModel: ObservableObject {
    
    // MARK: - State
    
    enum State: Equatable {
        case idle
        case loading
        case success([ScannedDevice])
        case error(String)
    }
    
    // MARK: - Published Properties
    
    @Published var state: State = .idle
    @Published var searchText = ""
    
    // MARK: - Private Properties
    
    private let sessionId: UUID
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    
    init(session: ScanSessionModel) {
        self.sessionId = session.id
        self.state = .success(session.devices)
        
        setupSearchSubscription()
    }
    
    func fetchDevices() {
        state = .loading
        
        Task {
            do {
                let devices = try await CoreDataService.shared.fetchDevices(forSessionId: sessionId, nameFilter: searchText)
                state = .success(devices)
            } catch {
                state = .error(error.localizedDescription)
            }
        }
    }
}

// MARK: - Private Methods

private extension SessionDetailViewModel {
    func setupSearchSubscription() {
        $searchText
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] _ in
                self?.fetchDevices()
            }
            .store(in: &cancellables)
    }
}
