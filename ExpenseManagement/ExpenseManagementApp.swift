import SwiftUI

@main
struct ExpenseManagementApp: App {
    
    @Environment(\.scenePhase) var scenePhase
    
    @StateObject private var authManager = AuthenticationManager()
    @StateObject private var globalState = GlobalStateManager()
    @StateObject private var commonDataManager = CommonDataManager.instance
    
    var body: some Scene {
        WindowGroup {
            if authManager.isSignedIn {
                TabViewContainer()
                    .environmentObject(authManager)
                    .environmentObject(globalState)
                    .environmentObject(commonDataManager)
                    .overlay(
                        SwiftMessagesView()
                            .environmentObject(globalState)
                    )
            } else {
                ContentView()
                    .environmentObject(authManager)
                    .environmentObject(globalState)
                    .environmentObject(commonDataManager)
                    .overlay(
                        SwiftMessagesView()
                            .environmentObject(globalState)
                    )
            }
        }
    }
}
