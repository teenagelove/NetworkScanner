//
//  ScanSessionModel.swift
//  NetworkScanner
//
//  Created by Danil Kazakov on 2025/11/27.
//

import Foundation

struct ScanSessionModel: Identifiable, Hashable {
    
    // MARK: - Properties
    
    let id: UUID
    let date: Date
    let devices: [ScannedDevice]
}
