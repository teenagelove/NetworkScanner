//
//  ErrorView.swift
//  NetworkScanner
//
//  Created by Danil Kazakov on 2025/11/27.
//

import SwiftUI

struct ErrorView: View {

    // MARK: - Properties

    let message: String
    let action: () -> Void

    // MARK: - Body

    var body: some View {
        VStack(spacing: 12) {
            ErrorLottieView()
            errorMessage
            actionButton
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

private extension ErrorView {

    // MARK: - View Components

    var errorMessage: some View {
        Text(message)
            .font(.body)
            .multilineTextAlignment(.center)
            .foregroundColor(.secondary)
            .padding(.horizontal, 16)
    }

    var actionButton: some View {
        Button(action: action) {
            Label(
                Constants.Actions.repeatAction,
                systemImage: Constants.SFSymbols.clockwise
            )
            .font(.headline)
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.blue.opacity(0.1))
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ErrorView(message: "ERROR") { }
}
