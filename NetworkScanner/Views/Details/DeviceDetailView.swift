//
//  DeviceDetailView.swift
//  NetworkScanner
//
//  Created by Danil Kazakov on 2025/11/27.
//

import SwiftUI

struct DeviceDetailView: View {
    let device: ScannedDevice
    
    var body: some View {
        List {
            generalSection
            
            technicalSection
        }
        .navigationTitle("Device Details")
    }
}

private extension DeviceDetailView {
    var generalSection: some View {
        Section(header: Text("General Info")) {
            DetailRow(label: "Name", value: device.name ?? "Unknown")
            DetailRow(label: "Type", value: device.type.rawValue)
            DetailRow(label: "Discovery Date", value: device.discoveryDate.formatted())
        }
    }
    
    var technicalSection: some View {
        Section(header: Text("Technical Details")) {
            if let ip = device.ipAddress {
                DetailRow(label: "IP Address", value: ip)
            }
            if let mac = device.macAddress {
                DetailRow(label: "MAC Address", value: mac)
            }
            DetailRow(label: "UUID", value: device.id.uuidString)
            DetailRow(label: "RSSI", value: "\(device.rssi) dBm")
            
            if let status = device.connectionStatus {
                DetailRow(label: "Connection Status", value: status.displayText)
            }
        }
    }
}

struct DetailRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text(value)
                .multilineTextAlignment(.trailing)
        }
    }
}

#Preview("DeviceDetailView") {
    DeviceDetailView(device: ScannedDevice(
        id: UUID(),
        name: "Test Device",
        ipAddress: "192.168.1.1",
        macAddress: "00:00:00:00:00:00",
        rssi: -50,
        type: .bluetooth,
        discoveryDate: Date(),
        connectionStatus: .connected
    ))
}

#Preview("DetailRow") {
    DetailRow(label: "Label", value: "Value")
        .padding()
}

