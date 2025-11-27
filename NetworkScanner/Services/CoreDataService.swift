//
//  CoreDataService.swift
//  NetworkScanner
//
//  Created by Danil Kazakov on 2025/11/27.
//

import CoreData
import Foundation

actor CoreDataService {
    
    static let shared = CoreDataService()
    
    private let persistentContainer: NSPersistentContainer
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "NetworkScanner")
        persistentContainer.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    func saveSession(devices: [ScannedDevice]) async {
        let context = persistentContainer.newBackgroundContext()
        await context.perform {
            let session = ScanSession(context: context)
            session.id = UUID()
            session.date = Date()
            
            for deviceData in devices {
                _ = deviceData.mapToEntity(context: context, session: session)
            }
            
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    print("Error saving session: \(error)")
                }
            }
        }
    }
    
    func fetchSessions(dateFilter: Date? = nil) async -> [ScanSessionModel] {
        let context = persistentContainer.newBackgroundContext()
        return await context.perform {
            let request: NSFetchRequest<ScanSession> = ScanSession.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(keyPath: \ScanSession.date, ascending: false)]
            
            if let date = dateFilter {
                // Create a range for the specific minute of the selected date
                let calendar = Calendar.current
                let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
                
                if let startDate = calendar.date(from: components),
                   let endDate = calendar.date(byAdding: .minute, value: 1, to: startDate) {
                    request.predicate = NSPredicate(format: "date >= %@ AND date < %@", startDate as NSDate, endDate as NSDate)
                }
            }
            
            do {
                let sessions = try context.fetch(request)
                return sessions.map { $0.mapToModel() }
            } catch {
                print("Error fetching sessions: \(error)")
                return []
            }
        }
    }
    
    func fetchDevices(forSessionId sessionId: UUID, nameFilter: String? = nil) async -> [ScannedDevice] {
        let context = persistentContainer.newBackgroundContext()
        return await context.perform {
            let request: NSFetchRequest<Device> = Device.fetchRequest()
            
            var predicates: [NSPredicate] = [
                NSPredicate(format: "session.id == %@", sessionId as CVarArg)
            ]
            
            if let nameFilter = nameFilter, !nameFilter.isEmpty {
                predicates.append(NSPredicate(format: "name CONTAINS[cd] %@", nameFilter))
            }
            
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
            request.sortDescriptors = [NSSortDescriptor(keyPath: \Device.name, ascending: true)]
            
            do {
                let devices = try context.fetch(request)
                return devices.map { $0.mapToScannedDevice() }
            } catch {
                print("Error fetching devices: \(error)")
                return []
            }
        }
    }
    
    func deleteSession(withId id: UUID) async {
        let context = persistentContainer.newBackgroundContext()
        await context.perform {
            let request: NSFetchRequest<ScanSession> = ScanSession.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            
            do {
                let sessions = try context.fetch(request)
                if let sessionToDelete = sessions.first {
                    context.delete(sessionToDelete)
                    try context.save()
                }
            } catch {
                print("Error deleting session: \(error)")
            }
        }
    }
}
