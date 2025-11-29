//
//  MainTabView.swift
//  NetworkScanner
//
//  Created by Danil Kazakov on 2025/11/27.
//

import SwiftUI

// MARK: - Main Tab View

struct MainTabView: View {
    
    // MARK: - Body
    var body: some View {
        TabView {
            NavigationView {
                ScannerView()
            }
            .tabItem {
                Label(Constants.Titles.scanner, systemImage: Constants.SFSymbols.scannerTab)
            }
            
            NavigationView {
                HistoryView()
            }
            .tabItem {
                Label(Constants.Titles.history, systemImage: Constants.SFSymbols.historyTab)
            }
        }
    }
}

#Preview {
    MainTabView()
}
