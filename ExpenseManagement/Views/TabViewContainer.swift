import SwiftUI

struct TabViewContainer: View {
        
    init() {
        UITabBar.appearance().backgroundColor = UIColor.white
    }
    
    var body: some View {
        ZStack {
            TabView {
                ReportsView()
                    .tabItem {
                        Image(systemName: "house")
                        Text("Home")
                    }
                UserView<AuthenticationManager>()
                    .tabItem {
                        Image(systemName: "person.circle.fill")
                        Text("User")
                    }
            }
        }.tint(.oceanBlue)
    }
}

#Preview {
    TabViewContainer()
        .environmentObject(AuthenticationManager())
}

