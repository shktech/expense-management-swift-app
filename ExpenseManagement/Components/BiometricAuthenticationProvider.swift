import LocalAuthentication

class BiometricAuthenticationProvider: ObservableObject {
    @Published var isAuthenticated = false
    @Published var showAlert = false
    @Published var isBiometricEnabled = false

    func authenticate(completion: @escaping (Bool) -> Void) {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Log in to your account"

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        self.isAuthenticated = true
                        completion(true)
                    } else {
                        self.showAlert = true
                        completion(false)
                    }
                }
            }
        } else {
            self.showAlert = true
            completion(false)
        }
    }
    
    func retryAuthentication(completion: @escaping (Bool) -> Void) {
        self.isAuthenticated = false
        self.showAlert = false
        self.authenticate(completion: completion)
    }

    func saveCredentials(email: String, password: String, biometricEnabled: Bool, rememberEmail: Bool) {
        let credentials: [String: Any] = [
            "password": password,
            "biometricEnabled": biometricEnabled,
            "rememberEmail": rememberEmail
        ]
        KeychainHelper.save(credentials, forKey: "default")
    }

    func getCredentials(for email: String) -> (password: String, biometricEnabled: Bool, rememberEmail: Bool)? {
        guard let credentials = KeychainHelper.load(key: email) as? [String: Any],
              let password = credentials["password"] as? String,
              let biometricEnabled = credentials["biometricEnabled"] as? Bool,
              let rememberEmail = credentials["rememberEmail"] as? Bool else {
            return nil
        }
        return (password, biometricEnabled, rememberEmail)
    }

    func deleteCredentials(for email: String) {
        KeychainHelper.delete(key: email)
    }

    func deleteSpecificItem(for email: String, itemKey: String) {
        KeychainHelper.deleteItem(fromDictionaryWithKey: email, forItemKey: itemKey)
    }

    func loadBiometricEnabled(for email: String) {
        if let credentials = getCredentials(for: email) {
            isBiometricEnabled = credentials.biometricEnabled
        }
    }

    func saveBiometricEnabled(_ enabled: Bool, for email: String) {
        if var credentials = getCredentials(for: email) {
            credentials.biometricEnabled = enabled
            saveCredentials(email: email, password: credentials.password, biometricEnabled: enabled, rememberEmail: credentials.rememberEmail)
        }
    }
}
