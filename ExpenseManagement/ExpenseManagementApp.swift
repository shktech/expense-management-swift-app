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
    
    var body: some Scene {
        WindowGroup {
            if dao.user != nil {
                TabViewContainer()
            } else {
                ContentView()
            }
        }
        .onChange(of: scenePhase) {
            switch scenePhase {
                
            case .background:
                do {
                    try DAO.instance.save()
                } catch {
                    print("Se ferrou!", error)
                }
            case .inactive:
                break
            case .active:
                break
            @unknown default:
                break
            }
        }
    }
}
