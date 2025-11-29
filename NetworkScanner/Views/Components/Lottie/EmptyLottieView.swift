//
//  EmptyLottieView.swift
//  NetworkScanner
//
//  Created by Danil Kazakov on 2025/11/28.
//

import Lottie
import SwiftUI

// MARK: - Empty Lottie View

struct EmptyLottieView: View {
    
    // MARK: - Body
    var body: some View {
        LottieView(animation: .named(Constants.LottieAnimations.emptyImage))
            .playing(loopMode: .loop)
            .resizable()
            .frame(width: 200, height: 200)
    }
}

#Preview {
    EmptyLottieView()
}
