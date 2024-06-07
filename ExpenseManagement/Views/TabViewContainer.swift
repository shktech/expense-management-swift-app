import SwiftUI

struct TabViewContainer: View {
    
//    @EnvironmentObject var authManager: AuthenticationManager
//    @EnvironmentObject var expenseDataManager: ExpenseDataManager
//    @State private var isLoading = false
//    @State private var reports: [Report] = []

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
                
                UserView()
                    .tabItem {
                        Image(systemName: "person.circle.fill")
                        Text("User")
                    }
            }
            
//            if isLoading {
//                LoadingOverlayView()
//            }
        }
    }
}

//#Preview {
//    TabViewContainer()
//}
