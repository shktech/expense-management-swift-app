import SwiftUI
import Combine

class MockAuthManager: AuthenticationManagerProtocol {
    @Published var accessToken: String? = "mockAccessToken"
    @Published var refreshToken: String? = "mockRefreshToken"
    @Published var isSignedIn: Bool = true
    @Published var loginFailed: Bool = false
    @Published var user: User? = User(
        id: "mockUserId",
        first_name: "John",
        last_name: "Doe",
        email: "john.doe@example.com",
        phone_number: "123-456-7890",
        department: "Mock Department",
        currency: "USD",
        creditCard: CreditCard(cardNumber: "4111111111111111", expirationDate: "12/25")
    )
    @Published var isDataLoading: Bool = false
    @Published var email: String? = "john.doe@example.com"
    
    func signIn(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        self.email = email
        self.isSignedIn = true
        completion(.success(()))
    }
    
    func verifyMFA(code: String, completion: @escaping (Result<Void, Error>) -> Void) {
        completion(.success(()))
    }
    
    func loadUserData(completion: @escaping (Result<Void, Error>) -> Void) {
        completion(.success(()))
    }
    
    func createCreditCard(cardNumber: String, expirationDate: String, completion: @escaping (Result<Void, Error>) -> Void) {
        self.user?.creditCard = CreditCard(cardNumber: cardNumber, expirationDate: expirationDate)
        completion(.success(()))
    }
    
    func loadUserDataAndCommonData(completion: @escaping (Result<Void, Error>) -> Void) {
        completion(.success(()))
    }
    
    func register(email: String, password: String, firstName: String, lastName: String, phoneNumber: String, department: String, currency: String, completion: @escaping (Result<String, Error>) -> Void) {
        completion(.success("Two-factor authentication required"))
    }
    
    func refreshAccessTokenIfNeeded(completion: @escaping (Result<Void, Error>) -> Void) {
        completion(.success(()))
    }
    
    func signOut() {
        self.isSignedIn = false
        self.accessToken = nil
        self.refreshToken = nil
        self.user = nil
    }
    
    func dateFromString(_ string: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/yy"
        return dateFormatter.date(from: string)
    }
}

