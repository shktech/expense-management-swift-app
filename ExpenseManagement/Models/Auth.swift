//
//  Auth.swift
//  ExpenseManagement
//
//  Created by Sung-Hyun Kang on 6/5/24.
//

import Foundation

struct LoginRequest: Encodable {
    var email: String
    var password: String
}

struct VerifyMFARequest: Codable {
    let email: String
    let code: String
}

struct LoginResponseData: Decodable {
    var refresh: String
    var access: String
}
