import SwiftUI

@main
struct ExpenseManagementApp: App {
    
    @Environment(\.scenePhase) var scenePhase
    
    @StateObject private var authManager = AuthenticationManager()
    @StateObject private var globalState = GlobalStateManager()
    @StateObject private var commonDataManager = CommonDataManager.instance
    
    @State var didLoad = false
    
    var body: some Scene {
        WindowGroup {
            ZStack {
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
                SplashScreenView()
                    .opacity(didLoad ? 0 : 1)
            }.onAppear {
                // THis is where you put the condition to go to the app, out of the splash screen,  usually when somehting is done loading
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    withAnimation() {
                        didLoad.toggle()
                    }
                }
            }
            .animation(.default, value: didLoad)
        }
    }
}
