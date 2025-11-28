//
//  ScanningProgressView.swift
//  NetworkScanner
//
//  Created by Danil Kazakov on 2025/11/28.
//

import SwiftUI

// MARK: - Scanning Progress View

struct ScanningProgressView: View {
    
    // MARK: - Properties
    
    let value: CGFloat
    
    // MARK: - Body
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.secondary.opacity(0.2))

                Capsule()
                    .fill(Color.blue)
                    .frame(width: min(CGFloat(value) * geometry.size.width, geometry.size.width))
            }
        }
        .frame(height: 4)
    }
}


#Preview {
    ScanningProgressView(value:0.5)
}
