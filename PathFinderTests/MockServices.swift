import Foundation
import GoogleSignIn
import Auth
import PostgREST

// MARK: - Mock Google Sign-In Result
class MockGoogleSignInResult: GIDSignInResult {
    private let _user: GIDGoogleUser
    private let _serverAuthCode: String?
    
    init(user: GIDGoogleUser, serverAuthCode: String? = nil) {
        self._user = user
        self._serverAuthCode = serverAuthCode
    }
    
    override var user: GIDGoogleUser {
        return _user
    }
    
    override var serverAuthCode: String? {
        return _serverAuthCode
    }
}

// MARK: - Mock Google User
class MockGoogleUser: GIDGoogleUser {
    private let _idToken: GIDToken?
    private let _profile: GIDProfileData?
    
    init(idToken: String, email: String, name: String) {
        self._idToken = MockGIDToken(tokenString: idToken)
        self._profile = MockGIDProfileData(email: email, name: name)
        super.init()
    }
    
    override var idToken: GIDToken? {
        return _idToken
    }
    
    override var profile: GIDProfileData? {
        return _profile
    }
}

// MARK: - Mock GID Token
class MockGIDToken: GIDToken {
    private let _tokenString: String
    
    init(tokenString: String) {
        self._tokenString = tokenString
        super.init()
    }
    
    override var tokenString: String {
        return _tokenString
    }
}

// MARK: - Mock GID Profile Data
class MockGIDProfileData: GIDProfileData {
    private let _email: String
    private let _name: String
    
    init(email: String, name: String) {
        self._email = email
        self._name = name
        super.init()
    }
    
    override var email: String? {
        return _email
    }
    
    override var name: String? {
        return _name
    }
}

// MARK: - Mock Supabase Auth Response
struct MockAuthResponse: Codable {
    let user: User
    let session: Session?
    
    init(user: User, session: Session? = nil) {
        self.user = user
        self.session = session
    }
}

// MARK: - Mock User
struct MockUser: Codable {
    let id: UUID
    let email: String?
    let createdAt: String
    let updatedAt: String
    
    init(id: UUID = UUID(), email: String?, createdAt: String = "2024-01-01T00:00:00Z", updatedAt: String = "2024-01-01T00:00:00Z") {
        self.id = id
        self.email = email
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

// MARK: - Mock Session
struct MockSession: Codable {
    let accessToken: String
    let refreshToken: String
    let expiresIn: Int
    let tokenType: String
    
    init(accessToken: String = "mock_access_token", refreshToken: String = "mock_refresh_token", expiresIn: Int = 3600, tokenType: String = "bearer") {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.expiresIn = expiresIn
        self.tokenType = tokenType
    }
}

// MARK: - Mock Auth Client Protocol
protocol MockAuthClientProtocol {
    func signUp(email: String, password: String) async throws -> MockAuthResponse
    func signIn(email: String, password: String) async throws -> MockSession
    func signInWithIdToken(credentials: OpenIDConnectCredentials) async throws -> MockAuthResponse
    func signOut() async throws
}

// MARK: - Mock Auth Client
class MockAuthClient: MockAuthClientProtocol {
    var shouldSucceed = true
    var mockError: Error?
    var signUpCallCount = 0
    var signInCallCount = 0
    var signInWithIdTokenCallCount = 0
    var signOutCallCount = 0
    
    func signUp(email: String, password: String) async throws -> MockAuthResponse {
        signUpCallCount += 1
        
        if !shouldSucceed {
            throw mockError ?? AuthError.invalidEmail
        }
        
        // Simulate network delay
        try await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        
        let user = MockUser(email: email)
        return MockAuthResponse(user: user)
    }
    
    func signIn(email: String, password: String) async throws -> MockSession {
        signInCallCount += 1
        
        if !shouldSucceed {
            throw mockError ?? AuthError.invalidEmail
        }
        
        // Simulate network delay
        try await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        
        return MockSession()
    }
    
    func signInWithIdToken(credentials: OpenIDConnectCredentials) async throws -> MockAuthResponse {
        signInWithIdTokenCallCount += 1
        
        if !shouldSucceed {
            throw mockError ?? AuthError.noIdToken
        }
        
        // Simulate network delay
        try await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        
        let user = MockUser(email: "test@google.com")
        return MockAuthResponse(user: user)
    }
    
    func signOut() async throws {
        signOutCallCount += 1
        
        if !shouldSucceed {
            throw mockError ?? AuthError.unknownError
        }
        
        // Simulate network delay
        try await Task.sleep(nanoseconds: 50_000_000) // 0.05 seconds
    }
}

// MARK: - Mock Google Sign-In Manager
class MockGoogleSignInManager {
    var shouldSucceed = true
    var mockError: Error?
    var signInCallCount = 0
    var signOutCallCount = 0
    
    func signIn(withPresenting viewController: UIViewController) async throws -> MockGoogleSignInResult {
        signInCallCount += 1
        
        if !shouldSucceed {
            throw mockError ?? AuthError.noViewController
        }
        
        // Simulate network delay
        try await Task.sleep(nanoseconds: 200_000_000) // 0.2 seconds
        
        let mockUser = MockGoogleUser(
            idToken: "mock_google_id_token",
            email: "test@google.com",
            name: "Test User"
        )
        
        return MockGoogleSignInResult(user: mockUser)
    }
    
    func signOut() {
        signOutCallCount += 1
    }
}

// MARK: - Test Auth Errors
enum TestAuthError: LocalizedError {
    case networkError
    case invalidCredentials
    case userCancelled
    case serverError
    
    var errorDescription: String? {
        switch self {
        case .networkError:
            return "Network connection failed"
        case .invalidCredentials:
            return "Invalid email or password"
        case .userCancelled:
            return "User cancelled the sign-in process"
        case .serverError:
            return "Server error occurred"
        }
    }
}
