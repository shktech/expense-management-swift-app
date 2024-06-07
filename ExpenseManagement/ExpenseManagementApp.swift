//
//  ExpenseManagementApp.swift
//  ExpenseManagement
//
//  Created by infra on 30/05/24.
//

import SwiftUI

@main
struct ExpenseManagementApp: App {
    
    @Environment(\.scenePhase) var scenePhase
    
    @StateObject private var authManager = AuthenticationManager()
    
    var body: some Scene {
        WindowGroup {
            if authManager.isSignedIn {
                TabViewContainer()
                    .environmentObject(authManager)
            } else {
                ContentView()
                    .environmentObject(authManager)
            }
        }
    }
}
