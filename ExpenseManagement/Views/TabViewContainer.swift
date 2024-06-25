import SwiftUI

class FloatingButtonViewModel: ObservableObject {
    @Published var action: (() -> Void)?
    @Published var visible: Bool = false
}

struct TabViewContainer: View {
    
    @StateObject var floatingButtonViewModel = FloatingButtonViewModel()
    
    init() {
        UITabBar.appearance().backgroundColor = UIColor.white
    }
    
    var body: some View {
        ZStack {
            TabView {
                ReportsView()
                    .environmentObject(floatingButtonViewModel)
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
            if floatingButtonViewModel.visible {
                VStack {
                    Spacer()
                    HStack {
                        VStack {
                            Button(action: {
                                floatingButtonViewModel.action?()
                            }) {
                                Image(systemName: "plus.circle.fill")
                                    .resizable()
                                    .frame(width: 55, height: 55)
                                    .foregroundColor(.oceanBlue)
                            }
                            .zIndex(1)
                            Text("Add Report")
                                .font(.system(size: 10).weight(.semibold))
                                .foregroundColor(.oceanBlue)
                        }
                    }
                }
            }
        }.tint(.oceanBlue)
    }
}

#Preview {
    TabViewContainer()
        .environmentObject(AuthenticationManager())
}

