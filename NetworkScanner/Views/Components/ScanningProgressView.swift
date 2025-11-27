//
//  ScanningProgressView.swift
//  NetworkScanner
//
//  Created by Danil Kazakov on 2025/11/28.
//

import SwiftUI

struct ScanningProgressView: View {
    let value: CGFloat

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
    }
}


#Preview {
    ScanningProgressView(value:0.5)
}
