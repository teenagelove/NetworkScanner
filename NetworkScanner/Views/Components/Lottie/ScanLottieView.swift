//
//  ScanLottieView.swift
//  NetworkScanner
//
//  Created by Danil Kazakov on 2025/11/28.
//

import Lottie
import SwiftUI

// MARK: - Scan Lottie View

struct ScanLottieView: View {
    
    // MARK: - Body
    var body: some View {
        LottieView(animation: .named(Constants.LottieAnimations.loadingImage))
            .playing(loopMode: .loop)
            .resizable()
            .scaledToFit()
    }
}

#Preview {
    ScanLottieView()
}
