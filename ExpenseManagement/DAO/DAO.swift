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
    
    var user: User?
    
    func authentication(email: String, password: String) -> Int {
        let data: AllUsers = try! Bundle.main.decode(file: "mockData.json") as AllUsers
        let user: User = data.users[0]
        if email != user.email || password != user.password {
            print("Sign in failed")
            return 0
        }
        self.user = user
        return 1
    }
    
    func addReports() {
        let reports = [
            Reports(name: "Exp 1019", date: Calendar.current.date(byAdding: .day, value: -31, to: Date())!, purpose: "LA Conference", value: 120.89, status: false),
            Reports(name: "Exp 1020", date: Date(), purpose: "LA Conference", value: 120.89, status: true),
            Reports(name: "Exp 1021", date: Calendar.current.date(byAdding: .day, value: -15, to: Date())!, purpose: "LA Conference", value: 120.89, status: true),
            Reports(name: "Exp 1022", date: Date(), purpose: "LA Conference", value: 120.89, status: false)
        ]
        
        for report in reports {
            user?.reports.append(report)
        }
        
        return
    }
}


enum BundleDecodingError: Error {
    case fileNotFound(String)
    case couldNotLoadData(String)
    case decodingFailure(String)
}


extension Bundle {
    func decode<T: Decodable>(file: String) throws -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            throw BundleDecodingError.fileNotFound("Could not find \(file) in bundle.")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            throw BundleDecodingError.couldNotLoadData("Could not load \(file) from bundle.")
        }
        
        guard let loadedData = try? JSONDecoder().decode(T.self, from: data) else {
            throw BundleDecodingError.decodingFailure("Could not decode \(file) from bundle.")
        }
        
        return loadedData
    }
}
