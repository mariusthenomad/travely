import Foundation
import XCTest

/// Test configuration and utilities for PathFinder authentication tests
/// Provides shared configuration, constants, and helper methods for all test classes
class TestConfiguration {
    
    // MARK: - Test Constants
    
    /// Standard test email addresses
    struct TestEmails {
        static let valid = "test@example.com"
        static let validWithSpecialChars = "test+tag@example-domain.co.uk"
        static let invalid = "invalid-email"
        static let empty = ""
        static let nonExistent = "nonexistent@example.com"
        static let googleUser = "test@google.com"
    }
    
    /// Standard test passwords
    struct TestPasswords {
        static let valid = "securePassword123"
        static let short = "123"
        static let empty = ""
        static let wrong = "wrongPassword"
    }
    
    /// Test timeouts for async operations
    struct Timeouts {
        static let short = 2.0
        static let standard = 5.0
        static let long = 10.0
        static let performance = 2.0
    }
    
    /// Mock data constants
    struct MockData {
        static let googleIdToken = "mock_google_id_token_12345"
        static let accessToken = "mock_access_token_67890"
        static let refreshToken = "mock_refresh_token_abcdef"
        static let userId = "mock_user_id_123"
        static let userName = "Test User"
    }
    
    // MARK: - Test Utilities
    
    /// Creates a mock user with the specified email
    /// - Parameter email: The email address for the mock user
    /// - Returns: A MockUser instance
    static func createMockUser(email: String) -> MockUser {
        return MockUser(email: email)
    }
    
    /// Creates a mock Google user with the specified details
    /// - Parameters:
    ///   - email: The email address
    ///   - name: The display name
    ///   - idToken: The ID token (optional, uses default if nil)
    /// - Returns: A MockGoogleUser instance
    static func createMockGoogleUser(email: String, name: String, idToken: String? = nil) -> MockGoogleUser {
        return MockGoogleUser(
            idToken: idToken ?? MockData.googleIdToken,
            email: email,
            name: name
        )
    }
    
    /// Creates a mock authentication response
    /// - Parameters:
    ///   - email: The user's email address
    ///   - includeSession: Whether to include a session in the response
    /// - Returns: A MockAuthResponse instance
    static func createMockAuthResponse(email: String, includeSession: Bool = false) -> MockAuthResponse {
        let user = createMockUser(email: email)
        let session = includeSession ? MockSession() : nil
        return MockAuthResponse(user: user, session: session)
    }
    
    /// Creates a mock session
    /// - Returns: A MockSession instance
    static func createMockSession() -> MockSession {
        return MockSession()
    }
    
    // MARK: - Validation Helpers
    
    /// Validates email format
    /// - Parameter email: The email to validate
    /// - Returns: True if the email format is valid
    static func isValidEmail(_ email: String) -> Bool {
        return email.contains("@") && email.contains(".") && !email.isEmpty
    }
    
    /// Validates password strength
    /// - Parameter password: The password to validate
    /// - Returns: True if the password meets minimum requirements
    static func isValidPassword(_ password: String) -> Bool {
        return password.count >= 6 && !password.isEmpty
    }
    
    /// Validates that a user object has the expected properties
    /// - Parameters:
    ///   - user: The user object to validate
    ///   - expectedEmail: The expected email address
    static func validateUser(_ user: MockUser, expectedEmail: String) {
        XCTAssertNotNil(user, "User should not be nil")
        XCTAssertEqual(user.email, expectedEmail, "User email should match expected value")
        XCTAssertNotNil(user.id, "User ID should not be nil")
    }
    
    /// Validates that a session object has the expected properties
    /// - Parameter session: The session object to validate
    static func validateSession(_ session: MockSession) {
        XCTAssertNotNil(session, "Session should not be nil")
        XCTAssertFalse(session.accessToken.isEmpty, "Access token should not be empty")
        XCTAssertFalse(session.refreshToken.isEmpty, "Refresh token should not be empty")
        XCTAssertGreaterThan(session.expiresIn, 0, "Expires in should be greater than 0")
    }
    
    // MARK: - Async Test Helpers
    
    /// Creates a standard expectation for async tests
    /// - Parameter description: Description of what the test is waiting for
    /// - Returns: An XCTestExpectation configured with standard timeout
    static func createExpectation(description: String) -> XCTestExpectation {
        return XCTestExpectation(description: description)
    }
    
    /// Waits for an expectation with standard timeout
    /// - Parameters:
    ///   - expectation: The expectation to wait for
    ///   - timeout: Optional timeout (uses standard if nil)
    static func waitForExpectation(_ expectation: XCTestExpectation, timeout: TimeInterval? = nil) async {
        await fulfillment(of: [expectation], timeout: timeout ?? Timeouts.standard)
    }
    
    /// Performs an async operation with error handling
    /// - Parameters:
    ///   - operation: The async operation to perform
    ///   - expectation: The expectation to fulfill
    ///   - shouldSucceed: Whether the operation should succeed
    static func performAsyncOperation<T>(
        operation: @escaping () async throws -> T,
        expectation: XCTestExpectation,
        shouldSucceed: Bool = true
    ) {
        Task {
            do {
                let result = try await operation()
                if shouldSucceed {
                    XCTAssertNotNil(result, "Operation result should not be nil")
                } else {
                    XCTFail("Operation should have failed but succeeded")
                }
                expectation.fulfill()
            } catch {
                if shouldSucceed {
                    XCTFail("Operation should succeed but failed: \(error)")
                } else {
                    XCTAssertNotNil(error, "Expected error should not be nil")
                }
                expectation.fulfill()
            }
        }
    }
    
    // MARK: - Mock Configuration Helpers
    
    /// Configures a mock auth client for success scenarios
    /// - Parameter mockClient: The mock client to configure
    static func configureMockForSuccess(_ mockClient: MockAuthClient) {
        mockClient.shouldSucceed = true
        mockClient.mockError = nil
    }
    
    /// Configures a mock auth client for failure scenarios
    /// - Parameters:
    ///   - mockClient: The mock client to configure
    ///   - error: The error to return (optional, uses default if nil)
    static func configureMockForFailure(_ mockClient: MockAuthClient, error: Error? = nil) {
        mockClient.shouldSucceed = false
        mockClient.mockError = error ?? TestAuthError.unknownError
    }
    
    /// Configures a mock Google Sign-In manager for success scenarios
    /// - Parameter mockManager: The mock manager to configure
    static func configureMockForSuccess(_ mockManager: MockGoogleSignInManager) {
        mockManager.shouldSucceed = true
        mockManager.mockError = nil
    }
    
    /// Configures a mock Google Sign-In manager for failure scenarios
    /// - Parameters:
    ///   - mockManager: The mock manager to configure
    ///   - error: The error to return (optional, uses default if nil)
    static func configureMockForFailure(_ mockManager: MockGoogleSignInManager, error: Error? = nil) {
        mockManager.shouldSucceed = false
        mockManager.mockError = error ?? TestAuthError.userCancelled
    }
    
    // MARK: - Performance Testing Helpers
    
    /// Measures the performance of an async operation
    /// - Parameter operation: The async operation to measure
    static func measureAsyncOperation(_ operation: @escaping () async throws -> Void) {
        measure {
            let expectation = createExpectation(description: "Performance test")
            
            Task {
                do {
                    try await operation()
                    expectation.fulfill()
                } catch {
                    XCTFail("Performance test should succeed: \(error)")
                }
            }
            
            wait(for: [expectation], timeout: Timeouts.performance)
        }
    }
    
    // MARK: - State Management Helpers
    
    /// Resets the authentication state of a SupabaseManager
    /// - Parameter manager: The manager to reset
    @MainActor
    static func resetAuthenticationState(_ manager: SupabaseManager) {
        manager.isAuthenticated = false
        manager.currentUser = nil
        manager.isLoading = false
    }
    
    /// Sets up an authenticated state for a SupabaseManager
    /// - Parameters:
    ///   - manager: The manager to configure
    ///   - email: The email for the authenticated user
    @MainActor
    static func setupAuthenticatedState(_ manager: SupabaseManager, email: String) {
        let user = createMockUser(email: email)
        manager.currentUser = user
        manager.isAuthenticated = true
        manager.isLoading = false
    }
    
    /// Validates the authentication state of a SupabaseManager
    /// - Parameters:
    ///   - manager: The manager to validate
    ///   - shouldBeAuthenticated: Whether the manager should be authenticated
    ///   - expectedEmail: The expected email if authenticated (optional)
    static func validateAuthenticationState(
        _ manager: SupabaseManager,
        shouldBeAuthenticated: Bool,
        expectedEmail: String? = nil
    ) {
        XCTAssertEqual(manager.isAuthenticated, shouldBeAuthenticated, "Authentication state should match expected value")
        
        if shouldBeAuthenticated {
            XCTAssertNotNil(manager.currentUser, "Current user should not be nil when authenticated")
            if let expectedEmail = expectedEmail {
                XCTAssertEqual(manager.currentUser?.email, expectedEmail, "Current user email should match expected value")
            }
        } else {
            XCTAssertNil(manager.currentUser, "Current user should be nil when not authenticated")
        }
    }
}

// MARK: - Test Extensions

extension XCTestCase {
    
    /// Creates a test expectation with a standard description
    /// - Parameter description: The description for the expectation
    /// - Returns: An XCTestExpectation
    func createExpectation(description: String) -> XCTestExpectation {
        return TestConfiguration.createExpectation(description: description)
    }
    
    /// Waits for an expectation with standard timeout
    /// - Parameters:
    ///   - expectation: The expectation to wait for
    ///   - timeout: Optional timeout (uses standard if nil)
    func waitForExpectation(_ expectation: XCTestExpectation, timeout: TimeInterval? = nil) async {
        await TestConfiguration.waitForExpectation(expectation, timeout: timeout)
    }
}

// MARK: - Custom Assertions

/// Custom assertion for validating authentication responses
/// - Parameters:
///   - response: The authentication response to validate
///   - expectedEmail: The expected email address
///   - file: The file where the assertion is made
///   - line: The line where the assertion is made
func XCTAssertValidAuthResponse(
    _ response: MockAuthResponse,
    expectedEmail: String,
    file: StaticString = #file,
    line: UInt = #line
) {
    XCTAssertNotNil(response, "Auth response should not be nil", file: file, line: line)
    XCTAssertNotNil(response.user, "User should not be nil", file: file, line: line)
    XCTAssertEqual(response.user.email, expectedEmail, "User email should match expected value", file: file, line: line)
}

/// Custom assertion for validating session objects
/// - Parameters:
///   - session: The session to validate
///   - file: The file where the assertion is made
///   - line: The line where the assertion is made
func XCTAssertValidSession(
    _ session: MockSession,
    file: StaticString = #file,
    line: UInt = #line
) {
    XCTAssertNotNil(session, "Session should not be nil", file: file, line: line)
    XCTAssertFalse(session.accessToken.isEmpty, "Access token should not be empty", file: file, line: line)
    XCTAssertFalse(session.refreshToken.isEmpty, "Refresh token should not be empty", file: file, line: line)
    XCTAssertGreaterThan(session.expiresIn, 0, "Expires in should be greater than 0", file: file, line: line)
}
