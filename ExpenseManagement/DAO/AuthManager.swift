import SwiftUI
import Combine
import JWTDecode

protocol AuthenticationManagerProtocol: ObservableObject {
    var accessToken: String? { get set }
    var refreshToken: String? { get set }
    var isSignedIn: Bool { get set }
    var loginFailed: Bool { get set }
    var user: User? { get set }
    var isDataLoading: Bool { get set }
    var email: String? { get set }

    func signIn(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void)
    func verifyMFA(code: String, completion: @escaping (Result<Void, Error>) -> Void)
    func loadUserData(completion: @escaping (Result<Void, Error>) -> Void)
    func createCreditCard(cardNumber: String, expirationDate: String, completion: @escaping (Result<Void, Error>) -> Void)
    func register(email: String, password: String, firstName: String, lastName: String, phoneNumber: String, department: String, currency: String, completion: @escaping (Result<String, Error>) -> Void)
    func refreshAccessTokenIfNeeded(completion: @escaping (Result<Void, Error>) -> Void)
    func signOut()
    func dateFromString(_ string: String) -> Date?
}

class AuthenticationManager: AuthenticationManagerProtocol {
    @Published var accessToken: String? {
        didSet {
            saveToken(accessToken, forKey: "accessToken")
        }
    }
    @Published var refreshToken: String? {
        didSet {
            saveToken(refreshToken, forKey: "refreshToken")
        }
    }
    @Published var isSignedIn: Bool = false
    @Published var loginFailed: Bool = false
    @Published var user: User? = nil
    @Published var isDataLoading: Bool = false
    @Published var email: String?

    private let dao = DAO.instance
    private let commonDataManager = CommonDataManager.instance

    init() {
        self.accessToken = loadToken(forKey: "accessToken")
        self.refreshToken = loadToken(forKey: "refreshToken")
        if let token = accessToken, isAccessTokenValid(token) {
            self.isSignedIn = true
            loadUserDataAndCommonData { _ in }
        } else {
            self.isSignedIn = false
        }
    }

    func signIn(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        self.email = email
        dao.authenticateUser(email: email, password: password) { result in
            switch result {
            case .success(let loginResponse):
                self.accessToken = loginResponse.access
                self.refreshToken = loginResponse.refresh
                self.isSignedIn = true
                self.isDataLoading = true
                self.loadUserDataAndCommonData { userResult in
                    self.isDataLoading = false
                    switch userResult {
                    case .success:
                        completion(.success(()))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                print(error)
                if let nsError = error as NSError?, nsError.code == -1, nsError.userInfo["code"] as? String == "second_factor_required" {
                    print("Second Factor Required")
                } else {
                    self.loginFailed = true
                }
                completion(.failure(error))
            }
        }
    }

    func verifyMFA(code: String, completion: @escaping (Result<Void, Error>) -> Void) {
        dao.verifyMFA(email: self.email ?? "", mfaCode: code, completion: { result in
            switch result {
            case .success(let loginResponse):
                self.accessToken = loginResponse.access
                self.refreshToken = loginResponse.refresh
                self.isSignedIn = true
                self.isDataLoading = true
                self.loadUserDataAndCommonData { userResult in
                    self.isDataLoading = false
                    switch userResult {
                    case .success:
                        completion(.success(()))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                self.loginFailed = true
                completion(.failure(error))
            }
        })
    }

    public func loadUserData(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let accessToken = accessToken else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No access token available"])))
            return
        }

        dao.fetchUserData(accessToken: accessToken) { result in
            switch result {
            case .success(let user):
                self.user = user
                completion(.success(()))
            case .failure(let error):
                print("Failed to fetch user data: \(error)")
                completion(.failure(error))
            }
        }
    }
    
    func createCreditCard(cardNumber: String, expirationDate: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let accessToken = accessToken else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No access token available"])))
            return
        }

        let creditCard = CreditCard(cardNumber: cardNumber, expirationDate: expirationDate)
        dao.createCreditCard(creditCard: creditCard, accessToken: accessToken) { result in
            switch result {
            case .success:
                self.loadUserData { userResult in
                    switch userResult {
                    case .success:
                        completion(.success(()))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    private func loadCommonData(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let accessToken = accessToken else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No access token available"])))
            return
        }

        commonDataManager.loadCommonData(accessToken: accessToken) { result in
            switch result {
            case .success:
                print("Common data loaded successfully")
                completion(.success(()))
            case .failure(let error):
                print("Failed to load common data: \(error)")
                completion(.failure(error))
            }
        }
    }

    private func loadUserDataAndCommonData(completion: @escaping (Result<Void, Error>) -> Void) {
        let dispatchGroup = DispatchGroup()

        var userDataError: Error?
        var commonDataError: Error?

        dispatchGroup.enter()
        loadUserData { result in
            if case .failure(let error) = result {
                userDataError = error
            }
            dispatchGroup.leave()
        }

        dispatchGroup.enter()
        loadCommonData { result in
            if case .failure(let error) = result {
                commonDataError = error
            }
            dispatchGroup.leave()
        }

        dispatchGroup.notify(queue: .main) {
            if let userDataError = userDataError {
                completion(.failure(userDataError))
            } else if let commonDataError = commonDataError {
                completion(.failure(commonDataError))
            } else {
                completion(.success(()))
            }
        }
    }

    func register(email: String, password: String, firstName: String, lastName: String, phoneNumber: String, department: String, currency: String, completion: @escaping (Result<String, Error>) -> Void) {
        let user = RegisterUser(first_name: firstName, last_name: lastName, email: email, password: password, phone_number: phoneNumber, department: department, currency: currency)

        dao.registerUser(user) { result in
            switch result {
            case .success(let registerResponse):
                if registerResponse.detail == "Two-factor authentication required" {
                    completion(.success(("Two-factor authentication required")))
                } else {
                    completion(.success(""))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func refreshAccessTokenIfNeeded(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let accessToken = accessToken, isAccessTokenValid(accessToken) else {
            guard let refreshToken = refreshToken else {
                signOut()
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Session expired. Please sign in again."])))
                return
            }

            dao.refreshAccessToken(refreshToken: refreshToken) { result in
                switch result {
                case .success(let loginResponse):
                    self.accessToken = loginResponse.access
                    self.refreshToken = loginResponse.refresh
                    completion(.success(()))
                case .failure(let error):
                    self.signOut()
                    completion(.failure(error))
                }
            }
            return
        }

        completion(.success(()))
    }

    func signOut() {
        self.accessToken = nil
        self.refreshToken = nil
        self.isSignedIn = false
        self.user = nil
        self.email = nil
        deleteToken(forKey: "accessToken")
        deleteToken(forKey: "refreshToken")
    }
    
    func dateFromString(_ string: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/yy"
        return dateFormatter.date(from: string)
    }

    private func isAccessTokenValid(_ token: String) -> Bool {
        do {
            let jwt = try decode(jwt: token)
            return !jwt.expired
        } catch {
            return false
        }
    }

    private func saveToken(_ token: String?, forKey key: String) {
        guard let token = token else {
            KeychainHelper.delete(key: key)
            return
        }
        KeychainHelper.save(token, forKey: key)
    }

    private func loadToken(forKey key: String) -> String? {
        return KeychainHelper.load(key: key) as? String ?? nil
    }

    private func deleteToken(forKey key: String) {
        KeychainHelper.delete(key: key)
    }
}
