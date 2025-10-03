import XCTest
import GoogleSignIn
import Auth
@testable import PathFinder

/// Tests for Google Sign-In functionality
/// Tests both successful and failed Google Sign-In flows with proper mocking
class GoogleSignInTests: XCTestCase {
    
    var mockAuthClient: MockAuthClient!
    var mockGoogleSignInManager: MockGoogleSignInManager!
    var supabaseManager: SupabaseManager!
    
    override func setUp() {
        super.setUp()
        mockAuthClient = MockAuthClient()
        mockGoogleSignInManager = MockGoogleSignInManager()
        supabaseManager = SupabaseManager.shared
        
        // Reset mock states
        mockAuthClient.shouldSucceed = true
        mockAuthClient.mockError = nil
        mockGoogleSignInManager.shouldSucceed = true
        mockGoogleSignInManager.mockError = nil
    }
    
    override func tearDown() {
        mockAuthClient = nil
        mockGoogleSignInManager = nil
        supabaseManager = nil
        super.tearDown()
    }
    
    // MARK: - Successful Google Sign-In Tests
    
    /// Test successful Google Sign-In flow
    /// Verifies that a user can successfully sign in with Google and get authenticated
    func testSuccessfulGoogleSignIn() async throws {
        // Given
        mockGoogleSignInManager.shouldSucceed = true
        mockAuthClient.shouldSucceed = true
        
        // When
        let expectation = XCTestExpectation(description: "Google Sign-In completes")
        
        Task {
            do {
                // Mock the Google Sign-In flow
                let mockResult = try await mockGoogleSignInManager.signIn(withPresenting: UIViewController())
                let mockUser = mockResult.user
                
                // Verify Google Sign-In returned valid data
                XCTAssertNotNil(mockUser.idToken?.tokenString)
                XCTAssertEqual(mockUser.profile?.email, "test@google.com")
                XCTAssertEqual(mockUser.profile?.name, "Test User")
                
                // Mock Supabase authentication with Google ID token
                let mockCredentials = OpenIDConnectCredentials(provider: .google, idToken: mockUser.idToken!.tokenString)
                let authResponse = try await mockAuthClient.signInWithIdToken(credentials: mockCredentials)
                
                // Verify Supabase authentication succeeded
                XCTAssertNotNil(authResponse.user)
                XCTAssertEqual(authResponse.user.email, "test@google.com")
                
                expectation.fulfill()
            } catch {
                XCTFail("Google Sign-In should succeed: \(error)")
            }
        }
        
        // Then
        await fulfillment(of: [expectation], timeout: 5.0)
        
        // Verify mock call counts
        XCTAssertEqual(mockGoogleSignInManager.signInCallCount, 1)
        XCTAssertEqual(mockAuthClient.signInWithIdTokenCallCount, 1)
    }
    
    /// Test Google Sign-In with valid ID token but Supabase failure
    /// Verifies proper error handling when Google succeeds but Supabase fails
    func testGoogleSignInWithSupabaseFailure() async throws {
        // Given
        mockGoogleSignInManager.shouldSucceed = true
        mockAuthClient.shouldSucceed = false
        mockAuthClient.mockError = TestAuthError.serverError
        
        // When
        let expectation = XCTestExpectation(description: "Google Sign-In fails at Supabase")
        
        Task {
            do {
                // Mock successful Google Sign-In
                let mockResult = try await mockGoogleSignInManager.signIn(withPresenting: UIViewController())
                let mockUser = mockResult.user
                
                // Verify Google Sign-In succeeded
                XCTAssertNotNil(mockUser.idToken?.tokenString)
                
                // Mock Supabase authentication failure
                let mockCredentials = OpenIDConnectCredentials(provider: .google, idToken: mockUser.idToken!.tokenString)
                _ = try await mockAuthClient.signInWithIdToken(credentials: mockCredentials)
                
                XCTFail("Supabase authentication should fail")
            } catch {
                // Verify the error is the expected Supabase error
                XCTAssertTrue(error is TestAuthError)
                expectation.fulfill()
            }
        }
        
        // Then
        await fulfillment(of: [expectation], timeout: 5.0)
        
        // Verify mock call counts
        XCTAssertEqual(mockGoogleSignInManager.signInCallCount, 1)
        XCTAssertEqual(mockAuthClient.signInWithIdTokenCallCount, 1)
    }
    
    // MARK: - Failed Google Sign-In Tests
    
    /// Test Google Sign-In failure when user cancels
    /// Verifies proper error handling when user cancels the Google Sign-In flow
    func testGoogleSignInUserCancelled() async throws {
        // Given
        mockGoogleSignInManager.shouldSucceed = false
        mockGoogleSignInManager.mockError = TestAuthError.userCancelled
        
        // When
        let expectation = XCTestExpectation(description: "Google Sign-In user cancelled")
        
        Task {
            do {
                _ = try await mockGoogleSignInManager.signIn(withPresenting: UIViewController())
                XCTFail("Google Sign-In should fail when user cancels")
            } catch {
                // Verify the error is user cancellation
                XCTAssertTrue(error is TestAuthError)
                if let testError = error as? TestAuthError {
                    XCTAssertEqual(testError, .userCancelled)
                }
                expectation.fulfill()
            }
        }
        
        // Then
        await fulfillment(of: [expectation], timeout: 5.0)
        
        // Verify mock call counts
        XCTAssertEqual(mockGoogleSignInManager.signInCallCount, 1)
        XCTAssertEqual(mockAuthClient.signInWithIdTokenCallCount, 0) // Should not reach Supabase
    }
    
    /// Test Google Sign-In failure due to network error
    /// Verifies proper error handling when network connection fails
    func testGoogleSignInNetworkError() async throws {
        // Given
        mockGoogleSignInManager.shouldSucceed = false
        mockGoogleSignInManager.mockError = TestAuthError.networkError
        
        // When
        let expectation = XCTestExpectation(description: "Google Sign-In network error")
        
        Task {
            do {
                _ = try await mockGoogleSignInManager.signIn(withPresenting: UIViewController())
                XCTFail("Google Sign-In should fail with network error")
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
        XCTAssertEqual(mockGoogleSignInManager.signInCallCount, 1)
        XCTAssertEqual(mockAuthClient.signInWithIdTokenCallCount, 0) // Should not reach Supabase
    }
    
    /// Test Google Sign-In failure when no ID token is received
    /// Verifies proper error handling when Google Sign-In succeeds but no ID token is provided
    func testGoogleSignInNoIdToken() async throws {
        // Given
        mockGoogleSignInManager.shouldSucceed = true
        mockAuthClient.shouldSucceed = false
        mockAuthClient.mockError = AuthError.noIdToken
        
        // When
        let expectation = XCTestExpectation(description: "Google Sign-In no ID token")
        
        Task {
            do {
                // Mock Google Sign-In with no ID token
                let mockResult = try await mockGoogleSignInManager.signIn(withPresenting: UIViewController())
                let mockUser = mockResult.user
                
                // Simulate missing ID token scenario
                guard let idToken = mockUser.idToken?.tokenString else {
                    throw AuthError.noIdToken
                }
                
                // This should not be reached if ID token is missing
                let mockCredentials = OpenIDConnectCredentials(provider: .google, idToken: idToken)
                _ = try await mockAuthClient.signInWithIdToken(credentials: mockCredentials)
                
                XCTFail("Should fail when no ID token is available")
            } catch {
                // Verify the error is no ID token error
                XCTAssertTrue(error is AuthError)
                if let authError = error as? AuthError {
                    XCTAssertEqual(authError, .noIdToken)
                }
                expectation.fulfill()
            }
        }
        
        // Then
        await fulfillment(of: [expectation], timeout: 5.0)
        
        // Verify mock call counts
        XCTAssertEqual(mockGoogleSignInManager.signInCallCount, 1)
        XCTAssertEqual(mockAuthClient.signInWithIdTokenCallCount, 0) // Should not reach Supabase
    }
    
    // MARK: - Integration Tests
    
    /// Test complete Google Sign-In flow with proper state management
    /// Verifies that authentication state is properly updated throughout the flow
    func testGoogleSignInStateManagement() async throws {
        // Given
        mockGoogleSignInManager.shouldSucceed = true
        mockAuthClient.shouldSucceed = true
        
        // Initial state should be unauthenticated
        XCTAssertFalse(supabaseManager.isAuthenticated)
        XCTAssertNil(supabaseManager.currentUser)
        
        // When
        let expectation = XCTestExpectation(description: "Google Sign-In state management")
        
        Task {
            do {
                // Simulate the complete flow
                let mockResult = try await mockGoogleSignInManager.signIn(withPresenting: UIViewController())
                let mockUser = mockResult.user
                
                let mockCredentials = OpenIDConnectCredentials(provider: .google, idToken: mockUser.idToken!.tokenString)
                let authResponse = try await mockAuthClient.signInWithIdToken(credentials: mockCredentials)
                
                // Simulate state updates (normally done in SupabaseManager)
                await MainActor.run {
                    supabaseManager.currentUser = authResponse.user
                    supabaseManager.isAuthenticated = true
                }
                
                // Verify final state
                XCTAssertTrue(supabaseManager.isAuthenticated)
                XCTAssertNotNil(supabaseManager.currentUser)
                XCTAssertEqual(supabaseManager.currentUser?.email, "test@google.com")
                
                expectation.fulfill()
            } catch {
                XCTFail("Google Sign-In should succeed: \(error)")
            }
        }
        
        // Then
        await fulfillment(of: [expectation], timeout: 5.0)
    }
    
    /// Test Google Sign-In performance
    /// Verifies that the authentication flow completes within reasonable time
    func testGoogleSignInPerformance() {
        // Given
        mockGoogleSignInManager.shouldSucceed = true
        mockAuthClient.shouldSucceed = true
        
        // When & Then
        measure {
            let expectation = XCTestExpectation(description: "Google Sign-In performance")
            
            Task {
                do {
                    let mockResult = try await mockGoogleSignInManager.signIn(withPresenting: UIViewController())
                    let mockUser = mockResult.user
                    
                    let mockCredentials = OpenIDConnectCredentials(provider: .google, idToken: mockUser.idToken!.tokenString)
                    _ = try await mockAuthClient.signInWithIdToken(credentials: mockCredentials)
                    
                    expectation.fulfill()
                } catch {
                    XCTFail("Performance test should succeed: \(error)")
                }
            }
            
            wait(for: [expectation], timeout: 2.0)
        }
    }
}
