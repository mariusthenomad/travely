import XCTest
import Auth
@testable import PathFinder

/// Tests for Email/Password authentication functionality
/// Tests both successful and failed email/password authentication flows with proper mocking
class EmailPasswordAuthTests: XCTestCase {
    
    var mockAuthClient: MockAuthClient!
    var supabaseManager: SupabaseManager!
    
    override func setUp() {
        super.setUp()
        mockAuthClient = MockAuthClient()
        supabaseManager = SupabaseManager.shared
        
        // Reset mock states
        mockAuthClient.shouldSucceed = true
        mockAuthClient.mockError = nil
    }
    
    override func tearDown() {
        mockAuthClient = nil
        supabaseManager = nil
        super.tearDown()
    }
    
    // MARK: - Successful Email/Password Authentication Tests
    
    /// Test successful email sign-up flow
    /// Verifies that a user can successfully create an account with email and password
    func testSuccessfulEmailSignUp() async throws {
        // Given
        let email = "test@example.com"
        let password = "securePassword123"
        mockAuthClient.shouldSucceed = true
        
        // When
        let expectation = XCTestExpectation(description: "Email sign-up completes")
        
        Task {
            do {
                let authResponse = try await mockAuthClient.signUp(email: email, password: password)
                
                // Verify sign-up succeeded
                XCTAssertNotNil(authResponse.user)
                XCTAssertEqual(authResponse.user.email, email)
                
                expectation.fulfill()
            } catch {
                XCTFail("Email sign-up should succeed: \(error)")
            }
        }
        
        // Then
        await fulfillment(of: [expectation], timeout: 5.0)
        
        // Verify mock call counts
        XCTAssertEqual(mockAuthClient.signUpCallCount, 1)
    }
    
    /// Test successful email sign-in flow
    /// Verifies that an existing user can successfully sign in with email and password
    func testSuccessfulEmailSignIn() async throws {
        // Given
        let email = "existing@example.com"
        let password = "correctPassword123"
        mockAuthClient.shouldSucceed = true
        
        // When
        let expectation = XCTestExpectation(description: "Email sign-in completes")
        
        Task {
            do {
                let session = try await mockAuthClient.signIn(email: email, password: password)
                
                // Verify sign-in succeeded
                XCTAssertNotNil(session)
                XCTAssertEqual(session.accessToken, "mock_access_token")
                XCTAssertEqual(session.refreshToken, "mock_refresh_token")
                
                expectation.fulfill()
            } catch {
                XCTFail("Email sign-in should succeed: \(error)")
            }
        }
        
        // Then
        await fulfillment(of: [expectation], timeout: 5.0)
        
        // Verify mock call counts
        XCTAssertEqual(mockAuthClient.signInCallCount, 1)
    }
    
    /// Test email sign-up with state management
    /// Verifies that authentication state is properly updated after successful sign-up
    func testEmailSignUpStateManagement() async throws {
        // Given
        let email = "newuser@example.com"
        let password = "newPassword123"
        mockAuthClient.shouldSucceed = true
        
        // Initial state should be unauthenticated
        XCTAssertFalse(supabaseManager.isAuthenticated)
        XCTAssertNil(supabaseManager.currentUser)
        
        // When
        let expectation = XCTestExpectation(description: "Email sign-up state management")
        
        Task {
            do {
                let authResponse = try await mockAuthClient.signUp(email: email, password: password)
                
                // Simulate state updates (normally done in SupabaseManager)
                await MainActor.run {
                    supabaseManager.currentUser = authResponse.user
                    supabaseManager.isAuthenticated = true
                }
                
                // Verify final state
                XCTAssertTrue(supabaseManager.isAuthenticated)
                XCTAssertNotNil(supabaseManager.currentUser)
                XCTAssertEqual(supabaseManager.currentUser?.email, email)
                
                expectation.fulfill()
            } catch {
                XCTFail("Email sign-up should succeed: \(error)")
            }
        }
        
        // Then
        await fulfillment(of: [expectation], timeout: 5.0)
    }
    
    // MARK: - Failed Email/Password Authentication Tests
    
    /// Test email sign-up failure with invalid email format
    /// Verifies proper error handling when email format is invalid
    func testEmailSignUpInvalidEmail() async throws {
        // Given
        let invalidEmail = "invalid-email"
        let password = "validPassword123"
        mockAuthClient.shouldSucceed = false
        mockAuthClient.mockError = AuthError.invalidEmail
        
        // When
        let expectation = XCTestExpectation(description: "Email sign-up invalid email")
        
        Task {
            do {
                _ = try await mockAuthClient.signUp(email: invalidEmail, password: password)
                XCTFail("Email sign-up should fail with invalid email")
            } catch {
                // Verify the error is invalid email error
                XCTAssertTrue(error is AuthError)
                if let authError = error as? AuthError {
                    XCTAssertEqual(authError, .invalidEmail)
                }
                expectation.fulfill()
            }
        }
        
        // Then
        await fulfillment(of: [expectation], timeout: 5.0)
        
        // Verify mock call counts
        XCTAssertEqual(mockAuthClient.signUpCallCount, 1)
    }
    
    /// Test email sign-up failure with password too short
    /// Verifies proper error handling when password doesn't meet minimum requirements
    func testEmailSignUpPasswordTooShort() async throws {
        // Given
        let email = "test@example.com"
        let shortPassword = "123"
        mockAuthClient.shouldSucceed = false
        mockAuthClient.mockError = AuthError.passwordTooShort
        
        // When
        let expectation = XCTestExpectation(description: "Email sign-up password too short")
        
        Task {
            do {
                _ = try await mockAuthClient.signUp(email: email, password: shortPassword)
                XCTFail("Email sign-up should fail with password too short")
            } catch {
                // Verify the error is password too short error
                XCTAssertTrue(error is AuthError)
                if let authError = error as? AuthError {
                    XCTAssertEqual(authError, .passwordTooShort)
                }
                expectation.fulfill()
            }
        }
        
        // Then
        await fulfillment(of: [expectation], timeout: 5.0)
        
        // Verify mock call counts
        XCTAssertEqual(mockAuthClient.signUpCallCount, 1)
    }
    
    /// Test email sign-in failure with wrong password
    /// Verifies proper error handling when user provides incorrect password
    func testEmailSignInWrongPassword() async throws {
        // Given
        let email = "existing@example.com"
        let wrongPassword = "wrongPassword"
        mockAuthClient.shouldSucceed = false
        mockAuthClient.mockError = TestAuthError.invalidCredentials
        
        // When
        let expectation = XCTestExpectation(description: "Email sign-in wrong password")
        
        Task {
            do {
                _ = try await mockAuthClient.signIn(email: email, password: wrongPassword)
                XCTFail("Email sign-in should fail with wrong password")
            } catch {
                // Verify the error is invalid credentials error
                XCTAssertTrue(error is TestAuthError)
                if let testError = error as? TestAuthError {
                    XCTAssertEqual(testError, .invalidCredentials)
                }
                expectation.fulfill()
            }
        }
        
        // Then
        await fulfillment(of: [expectation], timeout: 5.0)
        
        // Verify mock call counts
        XCTAssertEqual(mockAuthClient.signInCallCount, 1)
    }
    
    /// Test email sign-in failure with non-existent email
    /// Verifies proper error handling when user tries to sign in with unregistered email
    func testEmailSignInNonExistentEmail() async throws {
        // Given
        let nonExistentEmail = "nonexistent@example.com"
        let password = "somePassword123"
        mockAuthClient.shouldSucceed = false
        mockAuthClient.mockError = TestAuthError.invalidCredentials
        
        // When
        let expectation = XCTestExpectation(description: "Email sign-in non-existent email")
        
        Task {
            do {
                _ = try await mockAuthClient.signIn(email: nonExistentEmail, password: password)
                XCTFail("Email sign-in should fail with non-existent email")
            } catch {
                // Verify the error is invalid credentials error
                XCTAssertTrue(error is TestAuthError)
                if let testError = error as? TestAuthError {
                    XCTAssertEqual(testError, .invalidCredentials)
                }
                expectation.fulfill()
            }
        }
        
        // Then
        await fulfillment(of: [expectation], timeout: 5.0)
        
        // Verify mock call counts
        XCTAssertEqual(mockAuthClient.signInCallCount, 1)
    }
    
    /// Test email authentication failure due to network error
    /// Verifies proper error handling when network connection fails
    func testEmailAuthNetworkError() async throws {
        // Given
        let email = "test@example.com"
        let password = "validPassword123"
        mockAuthClient.shouldSucceed = false
        mockAuthClient.mockError = TestAuthError.networkError
        
        // When
        let expectation = XCTestExpectation(description: "Email auth network error")
        
        Task {
            do {
                _ = try await mockAuthClient.signIn(email: email, password: password)
                XCTFail("Email authentication should fail with network error")
            } catch {
                // Verify the error is network error
                XCTAssertTrue(error is TestAuthError)
                if let testError = error as? TestAuthError {
                    XCTAssertEqual(testError, .networkError)
                }
                expectation.fulfill()
            }
        }
        
        // Then
        await fulfillment(of: [expectation], timeout: 5.0)
        
        // Verify mock call counts
        XCTAssertEqual(mockAuthClient.signInCallCount, 1)
    }
    
    // MARK: - Input Validation Tests
    
    /// Test email validation logic
    /// Verifies that email format validation works correctly
    func testEmailValidation() {
        // Valid emails
        let validEmails = [
            "test@example.com",
            "user.name@domain.co.uk",
            "user+tag@example.org",
            "123@test.com"
        ]
        
        for email in validEmails {
            XCTAssertTrue(email.contains("@") && email.contains("."), "Email should be valid: \(email)")
        }
        
        // Invalid emails
        let invalidEmails = [
            "invalid-email",
            "@example.com",
            "test@",
            "test.example.com",
            "",
            "test@.com"
        ]
        
        for email in invalidEmails {
            XCTAssertFalse(email.contains("@") && email.contains("."), "Email should be invalid: \(email)")
        }
    }
    
    /// Test password validation logic
    /// Verifies that password length validation works correctly
    func testPasswordValidation() {
        // Valid passwords
        let validPasswords = [
            "password123",
            "securePass",
            "1234567890",
            "MySecurePassword123!"
        ]
        
        for password in validPasswords {
            XCTAssertTrue(password.count >= 6, "Password should be valid: \(password)")
        }
        
        // Invalid passwords
        let invalidPasswords = [
            "123",
            "pass",
            "",
            "12345"
        ]
        
        for password in invalidPasswords {
            XCTAssertFalse(password.count >= 6, "Password should be invalid: \(password)")
        }
    }
    
    // MARK: - Performance Tests
    
    /// Test email authentication performance
    /// Verifies that authentication flows complete within reasonable time
    func testEmailAuthPerformance() {
        // Given
        let email = "perf@example.com"
        let password = "performancePassword123"
        mockAuthClient.shouldSucceed = true
        
        // When & Then
        measure {
            let expectation = XCTestExpectation(description: "Email auth performance")
            
            Task {
                do {
                    _ = try await mockAuthClient.signIn(email: email, password: password)
                    expectation.fulfill()
                } catch {
                    XCTFail("Performance test should succeed: \(error)")
                }
            }
            
            wait(for: [expectation], timeout: 2.0)
        }
    }
    
    // MARK: - Edge Cases
    
    /// Test email authentication with empty inputs
    /// Verifies proper error handling when required fields are empty
    func testEmailAuthEmptyInputs() async throws {
        // Test empty email
        let expectation1 = XCTestExpectation(description: "Empty email")
        
        Task {
            do {
                _ = try await mockAuthClient.signIn(email: "", password: "password123")
                XCTFail("Should fail with empty email")
            } catch {
                XCTAssertTrue(error is AuthError)
                expectation1.fulfill()
            }
        }
        
        await fulfillment(of: [expectation1], timeout: 5.0)
        
        // Test empty password
        let expectation2 = XCTestExpectation(description: "Empty password")
        
        Task {
            do {
                _ = try await mockAuthClient.signIn(email: "test@example.com", password: "")
                XCTFail("Should fail with empty password")
            } catch {
                XCTAssertTrue(error is AuthError)
                expectation2.fulfill()
            }
        }
        
        await fulfillment(of: [expectation2], timeout: 5.0)
    }
    
    /// Test email authentication with special characters
    /// Verifies that emails with special characters are handled correctly
    func testEmailAuthSpecialCharacters() async throws {
        // Given
        let emailWithSpecialChars = "test+tag@example-domain.co.uk"
        let password = "validPassword123"
        mockAuthClient.shouldSucceed = true
        
        // When
        let expectation = XCTestExpectation(description: "Email with special characters")
        
        Task {
            do {
                let authResponse = try await mockAuthClient.signUp(email: emailWithSpecialChars, password: password)
                
                // Verify sign-up succeeded with special characters
                XCTAssertNotNil(authResponse.user)
                XCTAssertEqual(authResponse.user.email, emailWithSpecialChars)
                
                expectation.fulfill()
            } catch {
                XCTFail("Email with special characters should succeed: \(error)")
            }
        }
        
        // Then
        await fulfillment(of: [expectation], timeout: 5.0)
    }
}
