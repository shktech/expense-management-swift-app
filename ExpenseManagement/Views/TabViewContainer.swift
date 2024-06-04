//
//  TabView.swift
//  ExpenseManagement
//
//  Created by infra on 31/05/24.
//

import SwiftUI

struct TabViewContainer: View {

    init() {
        UITabBar.appearance().backgroundColor = UIColor.white
    }

    var body: some View {
        TabView {
            ReportsView(user: dao.user)
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            
            UserView(user: dao.user)
                .tabItem {
                    Image(systemName: "person.circle.fill")
                    Text("User")
                }
        }
    }
}

#Preview {
    TabViewContainer()
}
