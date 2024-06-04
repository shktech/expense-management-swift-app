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
            ZStack {
                if dao.user == nil || dao.isPassed == false {
                    ProgressView()
                } else if dao.isAuthenticated == true {
                    TabViewContainer()
                } else {
                    ContentView()
                }
            }
            .task {
                await dao.mockCall()
            }
            .onAppear {
                dao.hasThirtyMinutesPassed(since: Date())
            }
        }
        .onChange(of: scenePhase) {
            switch scenePhase {
                
            case .background:
                do {
                    try DAO.instance.save()
                } catch {
                    print("Failed to save DAO", error)
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
