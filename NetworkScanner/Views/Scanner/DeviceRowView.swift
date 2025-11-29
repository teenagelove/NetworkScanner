//
//  DeviceRowView.swift
//  NetworkScanner
//
//  Created by Danil Kazakov on 2025/11/27.
//

import SwiftUI

// MARK: - Device Row

struct DeviceRowView: View {
    
    // MARK: - Properties
    
    let device: ScannedDevice
    
    // MARK: - Body

    var body: some View {
        HStack {
            iconView

            deviceInfoView

            Spacer()

            rssiView
        }
    }
}

private extension DeviceRowView {

    // MARK: - View Components

    var iconView: some View {
        Image(systemName: device.type == .bluetooth
              ? Constants.SFSymbols.bluetoothIcon
              : Constants.SFSymbols.lanIcon)
        .foregroundColor(iconColor)
    }

    var iconColor: Color {
        if let status = device.connectionStatus {
            return statusColor(for: status)
        }
        return .blue
    }

    var deviceInfoView: some View {
        VStack(alignment: .leading) {
            Text(device.name ?? Constants.Placeholders.unknown)
                .font(.headline)

            if let ip = device.ipAddress {
                Text(ip)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            } else {
                Text(device.id.uuidString)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .lineLimit(1)
            }

            if let mac = device.macAddress {
                Text(mac)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }

            if let status = device.connectionStatus {
                Text(status.displayText)
                    .font(.caption)
                    .foregroundColor(statusColor(for: status))
            }
        }
    }

    func statusColor(for status: BluetoothConnectionStatus) -> Color {
        switch status {
        case .connected:
            return .green
        case .connecting, .disconnecting:
            return .orange
        case .disconnected:
            return .gray
        }
    }

    @ViewBuilder
    var rssiView: some View {
        if device.rssi != 0 {
            Text("\(device.rssi)" + Constants.Labels.rssiUnit)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    DeviceRowView(device: .mock)
        .padding()
}
