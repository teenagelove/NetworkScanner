//
//  ScanSession+Map.swift
//  NetworkScanner
//
//  Created by Danil Kazakov on 2025/11/27.
//

import CoreData
import Foundation

// MARK: - Scan Session Mapping

extension ScanSession {
    func mapToModel() -> ScanSessionModel {
        let deviceEntities = self.devices?.allObjects as? [Device] ?? []
        let deviceModels = deviceEntities.map { $0.mapToScannedDevice() }
        
        return ScanSessionModel(
            id: self.id ?? UUID(),
            date: self.date ?? Date(),
            devices: deviceModels.sorted(by: { $0.discoveryDate > $1.discoveryDate })
        )
    }
}
