//
//  SessionRow.swift
//  NetworkScanner
//
//  Created by Danil Kazakov on 2025/11/27.
//

import SwiftUI

struct SessionRow: View {
    let session: ScanSessionModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(session.date.formatted(date: .long, time: .shortened))
                .font(.headline)
            
            Text(Constants.Labels.devicesFound(session.devices.count))
                .font(.caption)
                .foregroundColor(.gray)
        }
    }
}

#Preview {
    SessionRow(session: .mock)
        .padding()
}
