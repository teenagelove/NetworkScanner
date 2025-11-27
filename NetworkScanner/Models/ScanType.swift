//
//  ScanType.swift
//  NetworkScanner
//
//  Created by Danil Kazakov on 2025/11/27.
//

enum ScanType: CaseIterable, Identifiable {
    case bluetooth
    case lan
    
    var id: Self { self }
    
    var title: String {
        switch self {
        case .bluetooth: return Constants.ScanTypes.bluetooth
        case .lan: return Constants.ScanTypes.lan
        }
    }
}
