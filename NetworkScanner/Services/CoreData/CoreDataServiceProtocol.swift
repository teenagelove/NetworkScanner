//
//  CoreDataServiceProtocol.swift
//  NetworkScanner
//
//  Created by Danil Kazakov on 2025/11/28.
//

import Foundation

// MARK: - Core Data Service Protocol

protocol CoreDataServiceProtocol: Actor {
    func saveSession(devices: [ScannedDevice]) async throws
    func fetchSessions(dateFilter: Date?) async throws -> [ScanSessionModel]
    func fetchDevices(forSessionId sessionId: UUID, nameFilter: String?) async throws -> [ScannedDevice]
    func deleteSession(withId id: UUID) async throws
}
