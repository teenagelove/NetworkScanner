//
//  DeleteButton.swift
//  NetworkScanner
//
//  Created by Danil Kazakov on 2025/11/28.
//

import SwiftUI

struct DeleteButton: View {
    let action: (() -> Void)?

    var body: some View {
        Button(role: .destructive) {
            action?()
        } label: {
            Image(systemName: Constants.SFSymbols.trash)
        }
    }
}

#Preview {
    DeleteButton { }
}
