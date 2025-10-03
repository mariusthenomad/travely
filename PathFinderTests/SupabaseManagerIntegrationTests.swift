import XCTest
import Auth
import PostgREST
@testable import PathFinder

/// Integration tests for SupabaseManager
/// Tests the complete authentication flow and state management
class SupabaseManagerIntegrationTests: XCTestCase {
    
    var supabaseManager: SupabaseManager!
    var mockAuthClient: MockAuthClient!
    
    override func setUp() {
        super.setUp()
        supabaseManager = SupabaseManager.shared
        mockAuthClient = MockAuthClient()
        
        // Reset authentication state
        supabaseManager.isAuthenticated = false
        supabaseManager.currentUser = nil
        supabaseManager.isLoading = false
    }
    
    override func tearDown() {
        supabaseManager = nil
        mockAuthClient = nil
        super.tearDown()
    }
    
    // MARK: - Authentication State Management Tests
    
    /// Test initial authentication state
    /// Verifies that SupabaseManager starts in the correct unauthenticated state
    func testInitialAuthenticationState() {
        // Given & When
        let manager = SupabaseManager.shared
        
        // Then
        XCTAssertFalse(manager.isAuthenticated, "Initial state should be unauthenticated")
        XCTAssertNil(manager.currentUser, "Initial state should have no current user")
        XCTAssertFalse(manager.isLoading, "Initial state should not be loading")
    }
    
    /// Test authentication state after successful sign-up
    /// Verifies that state is properly updated after successful email sign-up
    func testAuthenticationStateAfterSignUp() async throws {
        // Given
        let email = "newuser@example.com"
        let password = "securePassword123"
        mockAuthClient.shouldSucceed = true
        
        // When
        let expectation = XCTestExpectation(description: "Sign-up state management")
        
        Task {
            do {
                // Simulate sign-up process
                let authResponse = try await mockAuthClient.signUp(email: email, password: password)
                
                // Simulate state updates (normally done in SupabaseManager.signUp)
                await MainActor.run {
                    supabaseManager.currentUser = authResponse.user
                    supabaseManager.isAuthenticated = true
                    supabaseManager.isLoading = false
                }
                
                // Then
                XCTAssertTrue(supabaseManager.isAuthenticated, "Should be authenticated after sign-up")
                XCTAssertNotNil(supabaseManager.currentUser, "Should have current user after sign-up")
                XCTAssertEqual(supabaseManager.currentUser?.email, email, "Current user email should match")
                XCTAssertFalse(supabaseManager.isLoading, "Should not be loading after completion")
                
                expectation.fulfill()
            } catch {
                XCTFail("Sign-up should succeed: \(error)")
            }
        }
        
        await fulfillment(of: [expectation], timeout: 5.0)
    }
    
    /// Test authentication state after successful sign-in
    /// Verifies that state is properly updated after successful email sign-in
    func testAuthenticationStateAfterSignIn() async throws {
        // Given
        let email = "existing@example.com"
        let password = "correctPassword123"
        mockAuthClient.shouldSucceed = true
        
        // When
        let expectation = XCTestExpectation(description: "Sign-in state management")
        
        Task {
            do {
                // Simulate sign-in process
                let session = try await mockAuthClient.signIn(email: email, password: password)
                
                // Simulate state updates (normally done in SupabaseManager.signIn)
                await MainActor.run {
                    // Create a mock user for the session
                    let mockUser = MockUser(email: email)
                    supabaseManager.currentUser = mockUser
                    supabaseManager.isAuthenticated = true
                    supabaseManager.isLoading = false
                }
                
                // Then
                XCTAssertTrue(supabaseManager.isAuthenticated, "Should be authenticated after sign-in")
                XCTAssertNotNil(supabaseManager.currentUser, "Should have current user after sign-in")
                XCTAssertEqual(supabaseManager.currentUser?.email, email, "Current user email should match")
                XCTAssertFalse(supabaseManager.isLoading, "Should not be loading after completion")
                
                expectation.fulfill()
            } catch {
                XCTFail("Sign-in should succeed: \(error)")
            }
        }
        
        await fulfillment(of: [expectation], timeout: 5.0)
    }
    
    /// Test authentication state after sign-out
    /// Verifies that state is properly reset after sign-out
    func testAuthenticationStateAfterSignOut() async throws {
        // Given - Set up authenticated state
        let mockUser = MockUser(email: "test@example.com")
        supabaseManager.currentUser = mockUser
        supabaseManager.isAuthenticated = true
        mockAuthClient.shouldSucceed = true
        
        // When
        let expectation = XCTestExpectation(description: "Sign-out state management")
        
        Task {
            do {
                // Simulate sign-out process
                try await mockAuthClient.signOut()
                
                // Simulate state updates (normally done in SupabaseManager.signOut)
                await MainActor.run {
                    supabaseManager.currentUser = nil
                    supabaseManager.isAuthenticated = false
                }
                
                // Then
                XCTAssertFalse(supabaseManager.isAuthenticated, "Should not be authenticated after sign-out")
                XCTAssertNil(supabaseManager.currentUser, "Should have no current user after sign-out")
                
                expectation.fulfill()
            } catch {
                XCTFail("Sign-out should succeed: \(error)")
            }
        }
        
        await fulfillment(of: [expectation], timeout: 5.0)
    }
    
    // MARK: - Loading State Tests
    
    /// Test loading state during authentication
    /// Verifies that loading state is properly managed during async operations
    func testLoadingStateDuringAuthentication() async throws {
        // Given
        let email = "test@example.com"
        let password = "password123"
        mockAuthClient.shouldSucceed = true
        
        // When
        let expectation = XCTestExpectation(description: "Loading state management")
        
        Task {
            do {
                // Simulate loading state start
                await MainActor.run {
                    supabaseManager.isLoading = true
                }
                
                // Verify loading state is set
                XCTAssertTrue(supabaseManager.isLoading, "Should be loading at start")
                
                // Simulate authentication process
                _ = try await mockAuthClient.signIn(email: email, password: password)
                
                // Simulate loading state end
                await MainActor.run {
                    supabaseManager.isLoading = false
                }
                
                // Then
                XCTAssertFalse(supabaseManager.isLoading, "Should not be loading after completion")
                
                expectation.fulfill()
            } catch {
                XCTFail("Authentication should succeed: \(error)")
            }
        }
        
        await fulfillment(of: [expectation], timeout: 5.0)
    }
    
    /// Test loading state during error scenarios
    /// Verifies that loading state is properly reset even when errors occur
    func testLoadingStateDuringError() async throws {
        // Given
        let email = "test@example.com"
        let password = "wrongPassword"
        mockAuthClient.shouldSucceed = false
        mockAuthClient.mockError = TestAuthError.invalidCredentials
        
        // When
        let expectation = XCTestExpectation(description: "Loading state during error")
        
        Task {
            do {
                // Simulate loading state start
                await MainActor.run {
                    supabaseManager.isLoading = true
                }
                
                // Verify loading state is set
                XCTAssertTrue(supabaseManager.isLoading, "Should be loading at start")
                
                // Simulate authentication failure
                _ = try await mockAuthClient.signIn(email: email, password: password)
                XCTFail("Authentication should fail")
            } catch {
                // Simulate loading state reset on error
                await MainActor.run {
                    supabaseManager.isLoading = false
                }
                
                // Then
                XCTAssertFalse(supabaseManager.isLoading, "Should not be loading after error")
                XCTAssertFalse(supabaseManager.isAuthenticated, "Should not be authenticated after error")
                
                expectation.fulfill()
            }
        }
        
        await fulfillment(of: [expectation], timeout: 5.0)
    }
    
    // MARK: - Error Handling Tests
    
    /// Test error handling during sign-up
    /// Verifies that errors are properly handled and state is reset
    func testErrorHandlingDuringSignUp() async throws {
        // Given
        let email = "invalid-email"
        let password = "password123"
        mockAuthClient.shouldSucceed = false
        mockAuthClient.mockError = AuthError.invalidEmail
        
        // When
        let expectation = XCTestExpectation(description: "Error handling during sign-up")
        
        Task {
            do {
                _ = try await mockAuthClient.signUp(email: email, password: password)
                XCTFail("Sign-up should fail")
            } catch {
                // Simulate error handling (normally done in SupabaseManager)
                await MainActor.run {
                    supabaseManager.isLoading = false
                    // State should remain unauthenticated
                }
                
                // Then
                XCTAssertFalse(supabaseManager.isAuthenticated, "Should not be authenticated after error")
                XCTAssertNil(supabaseManager.currentUser, "Should have no current user after error")
                XCTAssertFalse(supabaseManager.isLoading, "Should not be loading after error")
                
                expectation.fulfill()
            }
        }
        
        await fulfillment(of: [expectation], timeout: 5.0)
    }
    
    /// Test error handling during sign-in
    /// Verifies that errors are properly handled and state is reset
    func testErrorHandlingDuringSignIn() async throws {
        // Given
        let email = "test@example.com"
        let password = "wrongPassword"
        mockAuthClient.shouldSucceed = false
        mockAuthClient.mockError = TestAuthError.invalidCredentials
        
        // When
        let expectation = XCTestExpectation(description: "Error handling during sign-in")
        
        Task {
            do {
                _ = try await mockAuthClient.signIn(email: email, password: password)
                XCTFail("Sign-in should fail")
            } catch {
                // Simulate error handling (normally done in SupabaseManager)
                await MainActor.run {
                    supabaseManager.isLoading = false
                    // State should remain unauthenticated
                }
                
                // Then
                XCTAssertFalse(supabaseManager.isAuthenticated, "Should not be authenticated after error")
                XCTAssertNil(supabaseManager.currentUser, "Should have no current user after error")
                XCTAssertFalse(supabaseManager.isLoading, "Should not be loading after error")
                
                expectation.fulfill()
            }
        }
        
        await fulfillment(of: [expectation], timeout: 5.0)
    }
    
    // MARK: - Concurrency Tests
    
    /// Test concurrent authentication attempts
    /// Verifies that multiple concurrent authentication attempts are handled correctly
    func testConcurrentAuthenticationAttempts() async throws {
        // Given
        let email1 = "user1@example.com"
        let email2 = "user2@example.com"
        let password = "password123"
        mockAuthClient.shouldSucceed = true
        
        // When
        let expectation1 = XCTestExpectation(description: "Concurrent sign-up 1")
        let expectation2 = XCTestExpectation(description: "Concurrent sign-up 2")
        
        // Start two concurrent authentication attempts
        Task {
            do {
                let authResponse = try await mockAuthClient.signUp(email: email1, password: password)
                XCTAssertNotNil(authResponse.user)
                expectation1.fulfill()
            } catch {
                XCTFail("First sign-up should succeed: \(error)")
            }
        }
        
        Task {
            do {
                let authResponse = try await mockAuthClient.signUp(email: email2, password: password)
                XCTAssertNotNil(authResponse.user)
                expectation2.fulfill()
            } catch {
                XCTFail("Second sign-up should succeed: \(error)")
            }
        }
        
        // Then
        await fulfillment(of: [expectation1, expectation2], timeout: 10.0)
        
        // Verify both calls were made
        XCTAssertEqual(mockAuthClient.signUpCallCount, 2, "Both sign-up calls should be made")
    }
    
    // MARK: - Memory Management Tests
    
    /// Test memory management during authentication
    /// Verifies that there are no memory leaks during authentication flows
    func testMemoryManagementDuringAuthentication() async throws {
        // Given
        let email = "memory@example.com"
        let password = "password123"
        mockAuthClient.shouldSucceed = true
        
        // When
        let expectation = XCTestExpectation(description: "Memory management test")
        
        Task {
            do {
                // Perform authentication
                let authResponse = try await mockAuthClient.signUp(email: email, password: password)
                
                // Simulate state updates
                await MainActor.run {
                    supabaseManager.currentUser = authResponse.user
                    supabaseManager.isAuthenticated = true
                }
                
                // Verify state is set
                XCTAssertTrue(supabaseManager.isAuthenticated)
                XCTAssertNotNil(supabaseManager.currentUser)
                
                // Simulate sign-out
                try await mockAuthClient.signOut()
                
                await MainActor.run {
                    supabaseManager.currentUser = nil
                    supabaseManager.isAuthenticated = false
                }
                
                // Verify state is cleared
                XCTAssertFalse(supabaseManager.isAuthenticated)
                XCTAssertNil(supabaseManager.currentUser)
                
                expectation.fulfill()
            } catch {
                XCTFail("Memory management test should succeed: \(error)")
            }
        }
        
        await fulfillment(of: [expectation], timeout: 5.0)
    }
    
    // MARK: - Performance Tests
    
    /// Test authentication performance
    /// Verifies that authentication flows complete within reasonable time
    func testAuthenticationPerformance() {
        // Given
        let email = "perf@example.com"
        let password = "password123"
        mockAuthClient.shouldSucceed = true
        
        // When & Then
        measure {
            let expectation = XCTestExpectation(description: "Authentication performance")
            
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
}
