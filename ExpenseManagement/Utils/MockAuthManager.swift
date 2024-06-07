class MockAuthenticationManager: AuthenticationManager {
    override init() {
        super.init()
        // Load user details from JSON file
        if let mockUser: User = MockDataLoader.load("user") {
            self.user = mockUser
            self.accessToken = "mockAccessToken"
        }
    }
}
