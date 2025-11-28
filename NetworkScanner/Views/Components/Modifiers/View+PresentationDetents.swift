//
//  View+PresentationDetents.swift
//  NetworkScanner
//
//  Created by Danil Kazakov on 2025/11/29.
//

import SwiftUI

extension View {
    @ViewBuilder
    func presentationDetents() -> some View {
        if #available(iOS 16.0, *) {
            self.presentationDetents([.height(350)])
        } else {
            self
        }
    }
}
