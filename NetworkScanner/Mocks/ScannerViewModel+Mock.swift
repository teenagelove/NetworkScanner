//
//  ScannerViewModel+Mock.swift
//  NetworkScanner
//
//  Created by Danil Kazakov on 2025/11/29.
//

import Foundation

extension ScannerViewModel {
    static var mock: ScannerViewModel {
        let viewModel = ScannerViewModel()
        viewModel.scannedDevices = ScannedDevice.mocks
        return viewModel
    }
}
