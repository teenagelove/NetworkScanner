//
//  ScanType.swift
//  NetworkScanner
//
//  Created by Danil Kazakov on 2025/11/27.
//

// MARK: - Scan Type

enum ScanType: CaseIterable, Identifiable {
    case bluetooth
    case lan
    
    // MARK: - Identifiable
    
    var id: Self { self }
    
    // MARK: - Properties
    
    var title: String {
        switch self {
        case .bluetooth: return Constants.ScanTypes.bluetooth
        case .lan: return Constants.ScanTypes.lan
        }
    }
}
