import SwiftUI
import Combine
import JWTDecode

class AuthenticationManager: ObservableObject {
    @Published var accessToken: String? {
        didSet {
            saveToken(accessToken, forKey: "pfu_expense_accessToken")
        }
    }
    @Published var refreshToken: String? {
        didSet {
            saveToken(refreshToken, forKey: "pfu_expense_refreshToken")
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
        self.accessToken = loadToken(forKey: "pfu_expense_accessToken")
        self.refreshToken = loadToken(forKey: "pfu_expense_refreshToken")
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

    private func loadUserDataAndCommonData(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let accessToken = accessToken else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No access token available"])))
            return
        }

        let dispatchGroup = DispatchGroup()

        dispatchGroup.enter()
        dao.fetchUserData(accessToken: accessToken) { result in
            switch result {
            case .success(let user):
                self.user = user
            case .failure(let error):
                print("Failed to fetch user data: \(error)")
            }
            dispatchGroup.leave()
        }

        dispatchGroup.enter()
        commonDataManager.loadCommonData(accessToken: accessToken) { result in
            switch result {
            case .success:
                print("Common data loaded successfully")
            case .failure(let error):
                print("Failed to load common data: \(error)")
            }
            dispatchGroup.leave()
        }

        dispatchGroup.notify(queue: .main) {
            completion(.success(()))
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
        deleteToken(forKey: "pfu_expense_accessToken")
        deleteToken(forKey: "pfu_expense_refreshToken")
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
        return KeychainHelper.load(key: key)
    }

    private func deleteToken(forKey key: String) {
        KeychainHelper.delete(key: key)
    }
}
