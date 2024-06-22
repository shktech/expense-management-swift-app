import Foundation
//import CodableExtensions

let dao = DAO.instance

@Observable class DAO: Codable {
    static var instance = DAO()
    
    private let apiBaseUrl: String
    
    var lastLoginDate: Date?
    
    var isPassed = false
    
    var user: User?
    
    var isAuthenticated: Bool = false
    
    var cities: [City]?
    
    private init() {
        guard let apiBaseUrl = Bundle.main.object(forInfoDictionaryKey: "API_BASE_URL") as? String else {
            fatalError("API_BASE_URL not found in Info.plist")
        }
        self.apiBaseUrl = apiBaseUrl
    }
    
    func verifyMFA(email: String, mfaCode: String, completion: @escaping (Result<LoginResponseData, Error>) -> Void) {
        let url = URL(string: "\(apiBaseUrl)/auth/verify-mfa/")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let parameters = VerifyMFARequest(email: email, code: mfaCode)

        guard let jsonData = try? JSONEncoder().encode(parameters) else {
            print("Failed to encode parameters")
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to encode parameters"])))
            return
        }
        request.httpBody = jsonData

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                }
                return
            }

            let httpResponse = response as? HTTPURLResponse
            if httpResponse?.statusCode == 200 {
                do {
                    let verifyMFAResponse = try JSONDecoder().decode(LoginResponseData.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(verifyMFAResponse))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            } else {
                DispatchQueue.main.async {
                    let errorDescription = HTTPURLResponse.localizedString(forStatusCode: httpResponse?.statusCode ?? -1)
                    completion(.failure(NSError(domain: "", code: httpResponse?.statusCode ?? -1, userInfo: [NSLocalizedDescriptionKey: errorDescription])))
                }
            }
        }.resume()
    }
    
    func authenticateUser(email: String, password: String, completion: @escaping (Result<LoginResponseData, Error>) -> Void) {
        let url = URL(string: "\(apiBaseUrl)/auth/login/")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let parameters = LoginRequest(email: email, password: password)

        guard let jsonData = try? JSONEncoder().encode(parameters) else {
            print("Failed to encode parameters")
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to encode parameters"])))
            return
        }
        request.httpBody = jsonData

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                }
                return
            }

            let httpResponse = response as? HTTPURLResponse
            if httpResponse?.statusCode == 200 {
                do {
                    let loginResponse = try JSONDecoder().decode(LoginResponseData.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(loginResponse))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            } else {
                DispatchQueue.main.async {
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                           let errorCode = json["code"] as? String {
                            if errorCode == "second_factor_required" {
                                print("Second Factor Required - DAO")
                                let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "MFA verification required", "code": errorCode])
                                completion(.failure(error))
                            } else {
                                let errorDescription = json["error"] as? String ?? "Unknown error"
                                completion(.failure(NSError(domain: "", code: httpResponse?.statusCode ?? -1, userInfo: [NSLocalizedDescriptionKey: errorDescription, "code": errorCode])))
                            }
                        } else {
                            let errorDescription = HTTPURLResponse.localizedString(forStatusCode: httpResponse?.statusCode ?? -1)
                            completion(.failure(NSError(domain: "", code: httpResponse?.statusCode ?? -1, userInfo: [NSLocalizedDescriptionKey: errorDescription])))
                        }
                    } catch {
                        let errorDescription = HTTPURLResponse.localizedString(forStatusCode: httpResponse?.statusCode ?? -1)
                        completion(.failure(NSError(domain: "", code: httpResponse?.statusCode ?? -1, userInfo: [NSLocalizedDescriptionKey: errorDescription])))
                    }
                }
            }
        }.resume()
    }
    
    func hasThirtyMinutesPassed(since date: Date) {
        let currentDate = Date()
        let thirtyMinutes: TimeInterval = 30 * 60
        
        let timeElapsed = currentDate.timeIntervalSince(date)
        
        if timeElapsed >= thirtyMinutes {
            isAuthenticated = false
        }
        
        return
    }
    
    func fetchUserData(accessToken: String, completion: @escaping (Result<User, Error>) -> Void) {
        let url = URL(string: "\(apiBaseUrl)/auth/me/")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                }
                return
            }

            let httpResponse = response as? HTTPURLResponse
            if httpResponse?.statusCode == 200 {
                do {
                    let user = try JSONDecoder().decode(User.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(user))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            } else {
                DispatchQueue.main.async {
                    let errorDescription = HTTPURLResponse.localizedString(forStatusCode: httpResponse?.statusCode ?? -1)
                    completion(.failure(NSError(domain: "", code: httpResponse?.statusCode ?? -1, userInfo: [NSLocalizedDescriptionKey: errorDescription])))
                }
            }
        }.resume()
    }
    
    func createReport(reportData: CreateReportRequest, accessToken: String, completion: @escaping (Result<Report, Error>) -> Void) {
        let url = URL(string: "\(apiBaseUrl)/reports/")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

        guard let jsonData = try? JSONEncoder().encode(reportData) else {
            print("Failed to encode report data")
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to encode report data"])))
            return
        }
        request.httpBody = jsonData

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                }
                return
            }

            let httpResponse = response as? HTTPURLResponse
            if httpResponse?.statusCode == 201 {
                do {
                    let createdReport = try JSONDecoder().decode(Report.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(createdReport))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            } else {
                DispatchQueue.main.async {
                    let errorDescription = HTTPURLResponse.localizedString(forStatusCode: httpResponse?.statusCode ?? -1)
                    completion(.failure(NSError(domain: "", code: httpResponse?.statusCode ?? -1, userInfo: [NSLocalizedDescriptionKey: errorDescription])))
                }
            }
        }.resume()
    }
    
    func fetchReports(accessToken: String, completion: @escaping (Result<[Report], Error>) -> Void) {
        let url = URL(string: "\(apiBaseUrl)/reports/")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                }
                return
            }

            do {
                let reports = try JSONDecoder().decode([Report].self, from: data)
                DispatchQueue.main.async {
                    completion(.success(reports))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }.resume()
    }

    func fetchReportItems(reportId: String, accessToken: String, completion: @escaping (Result<[ExpenseItem], Error>) -> Void) {
        let url = URL(string: "\(apiBaseUrl)/reports/\(reportId)/items/")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                }
                return
            }

            do {
                let items = try JSONDecoder().decode([ExpenseItem].self, from: data)
                DispatchQueue.main.async {
                    completion(.success(items))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
    func addExpenseItemToReport(reportId: String, expenseItemData: CreateExpenseItemRequest, accessToken: String, selectedFileURL: URL?, completion: @escaping (Result<ExpenseItem, Error>) -> Void) {
        let url = URL(string: "\(apiBaseUrl)/reports/\(reportId)/items/")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

        guard let jsonData = try? JSONEncoder().encode(expenseItemData) else {
            print("Failed to encode expense item data")
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to encode expense item data"])))
            return
        }
        request.httpBody = jsonData

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                }
                return
            }

            let httpResponse = response as? HTTPURLResponse
            if httpResponse?.statusCode == 201 {
                do {
                    var createdExpenseItem = try JSONDecoder().decode(ExpenseItem.self, from: data)
                    if let presignedURLString = createdExpenseItem.presignedURL, let presignedURL = URL(string: presignedURLString), let selectedFileURL = selectedFileURL {
                        self.uploadFileToS3(presignedURL: presignedURL, fileURL: selectedFileURL) { result in
                            switch result {
                            case .success:
                                DispatchQueue.main.async {
                                    completion(.success(createdExpenseItem))
                                }
                            case .failure(let error):
                                DispatchQueue.main.async {
                                    completion(.failure(error))
                                }
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            completion(.success(createdExpenseItem))
                        }
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            } else {
                DispatchQueue.main.async {
                    let errorDescription = HTTPURLResponse.localizedString(forStatusCode: httpResponse?.statusCode ?? -1)
                    completion(.failure(NSError(domain: "", code: httpResponse?.statusCode ?? -1, userInfo: [NSLocalizedDescriptionKey: errorDescription])))
                }
            }
        }.resume()
    }
    
    func uploadFileToS3(presignedURL: URL, fileURL: URL, completion: @escaping (Result<Void, Error>) -> Void) {
        var request = URLRequest(url: presignedURL)
        request.httpMethod = "PUT"
        request.setValue("application/octet-stream", forHTTPHeaderField: "Content-Type")

        let task = URLSession.shared.uploadTask(with: request, fromFile: fileURL) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                let errorDescription = HTTPURLResponse.localizedString(forStatusCode: (response as? HTTPURLResponse)?.statusCode ?? -1)
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: errorDescription])))
                return
            }

            completion(.success(()))
        }
        task.resume()
    }
    
    func fetchData<T: Decodable>(endpoint: String, accessToken: String, completion: @escaping (Result<T, Error>) -> Void) {

        let url = URL(string: "\(apiBaseUrl)/\(endpoint)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                }
                return
            }

            let httpResponse = response as? HTTPURLResponse
            if httpResponse?.statusCode == 200 {
                do {
                    let result = try JSONDecoder().decode(T.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(result))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            } else {
                DispatchQueue.main.async {
                    let errorDescription = HTTPURLResponse.localizedString(forStatusCode: httpResponse?.statusCode ?? -1)
                    completion(.failure(NSError(domain: "", code: httpResponse?.statusCode ?? -1, userInfo: [NSLocalizedDescriptionKey: errorDescription])))
                }
            }
        }.resume()
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
