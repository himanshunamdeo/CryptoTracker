//
//  CryptoTrackerApp.swift
//  CryptoTracker
//
//  Created by Himanshu Namdeo on 28/10/25.
//

import SwiftUI
import CoreData

@main
struct CryptoTrackerApp: App {
    let persistenceController = PersistenceController.shared

    @StateObject private var homeViewModel = HomeViewModel()
    
    init() {
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(Color.theme.accent)]
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(Color.theme.accent)]
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomeView()
                    .toolbar(.hidden)
            }
            .environmentObject(homeViewModel)
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
