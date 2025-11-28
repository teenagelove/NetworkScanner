//
//  CoreDataService+Mock.swift
//  NetworkScanner
//
//  Created by Danil Kazakov on 2025/11/29.
//

import Foundation

// MARK: - Core Data Service Mock

actor CoreDataServiceMock: CoreDataServiceProtocol {
    
    func saveSession(devices: [ScannedDevice]) async throws {
        // Mock implementation: do nothing
    }
    
    func fetchSessions(dateFilter: Date?) async throws -> [ScanSessionModel] {
        return await ScanSessionModel.mocks
    }
    
    func fetchDevices(forSessionId sessionId: UUID, nameFilter: String?) async throws -> [ScannedDevice] {
        return await ScannedDevice.mocks
    }
    
    func deleteSession(withId id: UUID) async throws {
        // Mock implementation: do nothing
    }
}
