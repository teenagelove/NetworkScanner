//
//  ErrorLottieView.swift
//  NetworkScanner
//
//  Created by Danil Kazakov on 2025/11/28.
//

import Lottie
import SwiftUI

// MARK: - Error Lottie View

struct ErrorLottieView: View {
    
    // MARK: - Body
    var body: some View {
        LottieView(animation: .named(Constants.LottieAnimations.errorImage))
            .playing(loopMode: .loop)
            .resizable()
            .frame(width: 100, height: 100)
    }
}

#Preview {
    ErrorLottieView()
}
