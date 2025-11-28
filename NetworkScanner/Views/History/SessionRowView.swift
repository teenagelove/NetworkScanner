//
//  SessionRowView.swift
//  NetworkScanner
//
//  Created by Danil Kazakov on 2025/11/27.
//

import SwiftUI

// MARK: - Session Row

struct SessionRowView: View {
    
    // MARK: - Properties
    
    let session: ScanSessionModel
    
    // MARK: - Body
    
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
    SessionRowView(session: .mock)
        .padding()
}
