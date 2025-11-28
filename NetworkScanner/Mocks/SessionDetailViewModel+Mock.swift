//
//  SessionDetailViewModel+Mock.swift
//  NetworkScanner
//
//  Created by Danil Kazakov on 2025/11/29.
//

import Foundation

extension SessionDetailViewModel {
    static var mock: SessionDetailViewModel {
        return SessionDetailViewModel(
            session: .mock,
            coreDataService: CoreDataServiceMock()
        )
    }
}
