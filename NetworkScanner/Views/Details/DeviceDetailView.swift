//
//  DeviceDetailView.swift
//  NetworkScanner
//
//  Created by Danil Kazakov on 2025/11/27.
//

import SwiftUI

// MARK: - Device Detail View

struct DeviceDetailView: View {
    
    // MARK: - Properties
    
    let device: ScannedDevice
    
    // MARK: - Body
    
    var body: some View {
        List {
            generalSection
            
            technicalSection
        }
        .navigationTitle(Constants.Titles.deviceDetails)
    }
}

private extension DeviceDetailView {

    // MARK: - View Components

    var generalSection: some View {
        Section(header: Text(Constants.Titles.generalInfo)) {
            DetailRowView(label: Constants.Labels.name, value: device.name ?? Constants.Placeholders.unknown)
            DetailRowView(label: Constants.Labels.type, value: device.type.rawValue)
            DetailRowView(label: Constants.Labels.discoveryDate, value: device.discoveryDate.formatted())
        }
    }
    
    var technicalSection: some View {
        Section(header: Text(Constants.Titles.technicalDetails)) {
            if let ip = device.ipAddress {
                DetailRowView(label: Constants.Labels.ipAddress, value: ip)
            }

            if let mac = device.macAddress {
                DetailRowView(label: Constants.Labels.macAddress, value: mac)
            }

            DetailRowView(label: Constants.Labels.uuid, value: device.id.uuidString)

            if device.rssi != 0 {
                DetailRowView(label: Constants.Labels.rssi, value: "\(device.rssi)" + Constants.Labels.rssiUnit)
            }

            if let status = device.connectionStatus {
                DetailRowView(label: Constants.Labels.connectionStatus, value: status.displayText)
            }
        }
    }
}

#Preview("DeviceDetailView") {
    DeviceDetailView(device: .mock)
}
