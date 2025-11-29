//
//  DeleteButton.swift
//  NetworkScanner
//
//  Created by Danil Kazakov on 2025/11/28.
//

import SwiftUI

// MARK: - Delete Button

struct DeleteButton: View {
    
    // MARK: - Properties
    
    let action: (() -> Void)?
    
    // MARK: - Body

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
