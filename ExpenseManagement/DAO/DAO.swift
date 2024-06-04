//
//  DAO.swift
//  ExpenseManagement
//
//  Created by infra on 31/05/24.
//

import Foundation
import CodableExtensions

let dao = DAO.instance

@Observable class DAO: Codable {
    static var instance = (try? DAO.load()) ?? DAO()
    
    var lastLoginDate: Date?
    
    var isPassed = false
    
    var user: User?
    
    var isAuthenticated: Bool = false
    
    var cities: [City]?
    
    func mockCall() async {
        isPassed = false
        do {
            let url = URL(string: "https://www.xyz123zyx321.com")!
            let (data, urlResponse) = try await URLSession.shared.data(from: url)
        }
        catch {
            Task {
                try await Task.sleep(for: Duration(secondsComponent: 2, attosecondsComponent: 0))
                // return the mock data
                let data: AllUsers = try! Bundle.main.decode(file: "mockData.json") as AllUsers
                let user: User = data.users[0]
                self.user = user
                let reports: [Reports] = try! Bundle.main.decode(file: "reports.json") as [Reports]
                self.user?.reports = reports
                let items: [ExpenseItem] = try! Bundle.main.decode(file: "report_items.json") as [ExpenseItem]
                for i in 0..<reports.count {
                    self.user?.reports[i].expenseItems = items
                }
                
                let citiesJson: [City] = try! Bundle.main.decode(file: "allCities.json") as [City]
                cities = citiesJson
                
                
                
                isPassed = true
                print("Returned the mock data")
                return
            }
        }
    }
    
    func authentication(email: String, password: String) -> Int {
        let data: AllUsers = try! Bundle.main.decode(file: "mockData.json") as AllUsers
        let user: User = data.users[0]
        if email != user.email || password != user.password {
            print("Sign in failed")
            return 0
        }
        
        // Do the logic of authenticating the user
//        self.user = user
        lastLoginDate = Date()
        isAuthenticated = true
        return 1
    }
    
    func hasThirtyMinutesPassed(since date: Date) {
        let currentDate = Date()
        let thirtyMinutes: TimeInterval = 30 * 60 // 30 minutos em segundos
        
        let timeElapsed = currentDate.timeIntervalSince(date)
        
        if timeElapsed >= thirtyMinutes {
            isAuthenticated = false
        }
        
        return
    }
}

enum BundleDecodingError: Error, CustomStringConvertible {
    case fileNotFound(String)
    case couldNotLoadData(String)
    case decodingFailure(String, Error)
    
    var description: String {
        switch self {
        case .fileNotFound(let message),
             .couldNotLoadData(let message):
            return message
        case .decodingFailure(let message, let error):
            return "\(message): \(error)"
        }
    }
}

extension Bundle {
    func decode<T: Decodable>(file: String) throws -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            throw BundleDecodingError.fileNotFound("Could not find \(file) in bundle.")
        }
        
        print("Found file at url: \(url)")
        
        guard let data = try? Data(contentsOf: url) else {
            throw BundleDecodingError.couldNotLoadData("Could not load \(file) from bundle.")
        }
        
        print("Loaded data: \(data)")
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        do {
            let loadedData = try decoder.decode(T.self, from: data)
            return loadedData
        } catch {
            throw BundleDecodingError.decodingFailure("Could not decode \(file) from bundle", error)
        }
    }
}
