//
//  CoreDataService.swift
//  NetworkScanner
//
//  Created by Danil Kazakov on 2025/11/27.
//

import CoreData
import Foundation

// MARK: - Core Data Service

actor CoreDataService: CoreDataServiceProtocol {
    
    // MARK: - Shared Instance
    
    static let shared = CoreDataService()
    
    // MARK: - Private Properties
    
    private let persistentContainer: NSPersistentContainer
    
    // MARK: - Init
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "NetworkScanner")
        persistentContainer.loadPersistentStores { _, error in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        }
        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    // MARK: - Public Methods
    
    func saveSession(devices: [ScannedDevice]) async throws {
        let context = persistentContainer.newBackgroundContext()
        try await context.perform {
            let session = ScanSession(context: context)
            session.id = UUID()
            session.date = Date()
            
            for deviceData in devices {
                _ = deviceData.mapToEntity(context: context, session: session)
            }
            
            if context.hasChanges {
                try context.save()
            }
        }
    }
    
    func fetchSessions(dateFilter: Date? = nil) async throws -> [ScanSessionModel] {
        let context = persistentContainer.newBackgroundContext()
        return try await context.perform {
            let request: NSFetchRequest<ScanSession> = ScanSession.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(keyPath: \ScanSession.date, ascending: false)]
            
            if let date = dateFilter {
                let calendar = Calendar.current
                let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
                
                if let startDate = calendar.date(from: components),
                   let endDate = calendar.date(byAdding: .minute, value: 1, to: startDate) {
                    request.predicate = NSPredicate(format: "date >= %@ AND date < %@", startDate as NSDate, endDate as NSDate)
                }
            }
            
            let sessions = try context.fetch(request)
            return sessions.map { $0.mapToModel() }
        }
    }
    
    func fetchDevices(forSessionId sessionId: UUID, nameFilter: String? = nil) async throws -> [ScannedDevice] {
        let context = persistentContainer.newBackgroundContext()
        return try await context.perform {
            let request: NSFetchRequest<Device> = Device.fetchRequest()
            
            var predicates: [NSPredicate] = [
                NSPredicate(format: "session.id == %@", sessionId as CVarArg)
            ]
            
            if let nameFilter = nameFilter, !nameFilter.isEmpty {
                predicates.append(NSPredicate(format: "name CONTAINS[cd] %@", nameFilter))
            }
            
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
            request.sortDescriptors = [NSSortDescriptor(keyPath: \Device.name, ascending: true)]
            
            let devices = try context.fetch(request)
            return devices.map { $0.mapToScannedDevice() }
        }
    }
    
    func deleteSession(withId id: UUID) async throws {
        let context = persistentContainer.newBackgroundContext()
        try await context.perform {
            let request: NSFetchRequest<ScanSession> = ScanSession.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            
            let sessions = try context.fetch(request)
            if let sessionToDelete = sessions.first {
                context.delete(sessionToDelete)
                try context.save()
            }
        }
    }
}
