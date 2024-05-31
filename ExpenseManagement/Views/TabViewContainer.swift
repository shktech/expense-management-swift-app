//
//  TabView.swift
//  ExpenseManagement
//
//  Created by infra on 31/05/24.
//

import SwiftUI

struct TabViewContainer: View {
    var body: some View {
        TabView {
            ReportsView(user: dao.user)
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
    }
}

#Preview {
    TabViewContainer()
}
