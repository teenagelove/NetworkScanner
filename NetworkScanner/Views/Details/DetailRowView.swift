//
//  DetailRowView.swift
//  NetworkScanner
//
//  Created by Danil Kazakov on 2025/11/28.
//

import SwiftUI

// MARK: - Detail Row

struct DetailRowView: View {
    
    // MARK: - Properties
    
    let label: String
    let value: String
    
    // MARK: - Body
    
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

#Preview("DetailRow") {
    DetailRowView(label: "Label", value: "Value")
        .padding()
}
