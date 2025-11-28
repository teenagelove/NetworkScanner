//
//  HistoryViewModel+Mock.swift
//  NetworkScanner
//
//  Created by Danil Kazakov on 2025/11/29.
//

import Foundation

extension HistoryViewModel {
    static var mock: HistoryViewModel {
        return HistoryViewModel(coreDataService: CoreDataServiceMock())
    }
}
