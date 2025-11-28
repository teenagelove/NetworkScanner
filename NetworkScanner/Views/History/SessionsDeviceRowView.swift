//
//  SessionsDeviceRowView.swift
//  NetworkScanner
//
//  Created by Danil Kazakov on 2025/11/27.
//

import SwiftUI

// MARK: - Device Detail Row

struct SessionsDeviceRowView: View {
    
    // MARK: - Properties
    
    let device: ScannedDevice
    
    // MARK: - Body
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(device.name ?? Constants.Placeholders.unknown)
                .font(.headline)
            
            Group {
                if let ip = device.ipAddress {
                    Text(Constants.Labels.ipPrefix + ip)
                }
                if let mac = device.macAddress {
                    Text(Constants.Labels.macPrefix + mac)
                }
                if device.rssi != 0 {
                    Text(Constants.Labels.rssiPrefix + "\(device.rssi)" + Constants.Labels.rssiUnit)
                }
                Text(Constants.Labels.datePrefix + device.discoveryDate.formatted(date: .abbreviated, time: .standard))
            }
            .font(.caption)
            .foregroundColor(.gray)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    SessionsDeviceRowView(device: .mock)
        .padding()
}
