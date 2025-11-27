//
//  SessionDetailViewModel.swift
//  NetworkScanner
//
//  Created by Danil Kazakov on 2025/11/27.
//

import Combine
import Foundation

@MainActor
class SessionDetailViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var devices: [ScannedDevice]
    @Published var searchText = ""
    
    // MARK: - Private Properties
    
    private let sessionId: UUID
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    
    init(session: ScanSessionModel) {
        self.sessionId = session.id
        self.devices = session.devices
        
        setupSearchSubscription()
    }
    
    func fetchDevices() {
        Task {
            let fetchedDevices = await CoreDataService.shared.fetchDevices(forSessionId: sessionId, nameFilter: searchText)
            self.devices = fetchedDevices
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
