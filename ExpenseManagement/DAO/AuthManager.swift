import SwiftUI
import Combine

class AuthenticationManager: ObservableObject {
    @Published var accessToken: String?
    @Published var refreshToken: String?
    @Published var isSignedIn: Bool = false
    @Published var loginFailed: Bool = false
    @Published var user: User? = nil
    @Published var isDataLoading: Bool = false
    @Published var email: String?
    
    private let dao = DAO.instance
    private let commonDataManager = CommonDataManager.instance
    
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
                    print("Second Factor Required");
                } else {
                    self.loginFailed = true
                }
                completion(.failure(error))
            }
        }
    }
    
    func verifyMFA(code: String, completion: @escaping (Result<Void, Error>) -> Void) {
        dao.verifyMFA(email: self.email ?? "", mfaCode: code, completion: {result in
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
}
