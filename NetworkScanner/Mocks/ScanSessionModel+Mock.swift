//
//  ScanSessionModel+Mock.swift
//  NetworkScanner
//
//  Created by Danil Kazakov on 2025/11/27.
//

import Foundation

extension ScanSessionModel {
    static let mock = ScanSessionModel(
        id: UUID(),
        date: Date(),
        devices: ScannedDevice.mocks
    )
    
    static let mocks: [ScanSessionModel] = [
        mock,
        ScanSessionModel(
            id: UUID(),
            date: Date().addingTimeInterval(-86400),
            devices: Array(ScannedDevice.mocks.prefix(3))
        )
    ]
}
