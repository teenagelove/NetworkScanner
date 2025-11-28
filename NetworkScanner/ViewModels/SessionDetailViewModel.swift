//
//  SessionDetailViewModel.swift
//  NetworkScanner
//
//  Created by Danil Kazakov on 2025/11/27.
//

import Combine
import Foundation

// MARK: - Session Detail View Model

@MainActor
final class SessionDetailViewModel: ObservableObject {

    // MARK: - State

    enum State: Equatable {
        case success([ScannedDevice])
        case error(String)
    }

    // MARK: - Published Properties

    @Published var state: State = .success([])
    @Published var searchText = ""

    // MARK: - Private Properties

    private let sessionId: UUID
    private let coreDataService: CoreDataServiceProtocol
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization

    init(session: ScanSessionModel, coreDataService: CoreDataServiceProtocol = CoreDataService.shared) {
        self.sessionId = session.id
        self.coreDataService = coreDataService

        setupSearchSubscription()
    }

    // MARK: - Public Methods

    func fetchDevices() {
        Task {
            do {
                let devices = try await coreDataService.fetchDevices(forSessionId: sessionId, nameFilter: searchText)
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
            .sink { [weak self] text in
                self?.fetchDevices()
            }
            .store(in: &cancellables)
    }
}
