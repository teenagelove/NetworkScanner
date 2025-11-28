//
//  Device+Map.swift
//  NetworkScanner
//
//  Created by Danil Kazakov on 2025/11/27.
//

import CoreData
import Foundation

// MARK: - Device Mapping

extension Device {
    func mapToScannedDevice() -> ScannedDevice {
        return ScannedDevice(
            id: self.id ?? UUID(),
            name: self.name,
            ipAddress: self.ipAdress,
            macAddress: self.macAdress,
            rssi: Int(self.rssi),
            type: ScannedDevice.DeviceType(rawValue: self.type ?? "") ?? .bluetooth,
            discoveryDate: self.discoveryDate ?? Date(),
            connectionStatus: nil
        )
    }
}

// MARK: - Device Mapping to Entity

extension ScannedDevice {
    func mapToEntity(context: NSManagedObjectContext, session: ScanSession) -> Device {
        let device = Device(context: context)
        device.id = self.id
        device.name = self.name
        device.ipAdress = self.ipAddress
        device.macAdress = self.macAddress
        device.rssi = Int16(self.rssi)
        device.type = self.type.rawValue
        device.discoveryDate = self.discoveryDate
        device.session = session
        return device
    }
}
