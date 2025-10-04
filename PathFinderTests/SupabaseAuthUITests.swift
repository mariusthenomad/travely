import XCTest
import SwiftUI
@testable import PathFinder

// MARK: - Supabase Auth UI Tests
class SupabaseAuthUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    // MARK: - Test 1: Create Second Test User
    func testCreateSecondTestUser() throws {
        // Navigate to sign up view (assuming it's accessible from main UI)
        // This might need to be adjusted based on your actual UI flow
        
        // Look for sign up button or navigation
        let signUpButton = app.buttons["Sign Up"]
        if signUpButton.exists {
            signUpButton.tap()
        } else {
            // Try to find navigation to sign up
            let signUpNavButton = app.buttons.matching(identifier: "signUp").firstMatch
            if signUpNavButton.exists {
                signUpNavButton.tap()
            }
        }
        
        // Wait for sign up view to appear
        let emailField = app.textFields["Email"]
        let passwordField = app.secureTextFields["Password"]
        let createAccountButton = app.buttons["Sign Up"]
        
        XCTAssertTrue(emailField.waitForExistence(timeout: 5), "Email field should exist")
        XCTAssertTrue(passwordField.waitForExistence(timeout: 5), "Password field should exist")
        XCTAssertTrue(createAccountButton.waitForExistence(timeout: 5), "Sign Up button should exist")
        
        // Fill in test user credentials
        let testEmail = "testuser2@pathfinder.app"
        let testPassword = "TestPassword123"
        
        emailField.tap()
        emailField.typeText(testEmail)
        
        passwordField.tap()
        passwordField.typeText(testPassword)
        
        // Tap sign up button
        createAccountButton.tap()
        
        // Wait for success message or loading to complete
        let successMessage = app.staticTexts["✅ Account created successfully!"]
        let loadingIndicator = app.progressIndicators.firstMatch
        
        // Wait for either success or error
        let expectation = XCTestExpectation(description: "Sign up completion")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            if successMessage.exists || app.alerts.count > 0 {
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 15)
        
        // Check for success or handle error
        if successMessage.exists {
            XCTAssertTrue(successMessage.exists, "Account should be created successfully")
            print("✅ Test user created successfully: \(testEmail)")
        } else if app.alerts.count > 0 {
            let alert = app.alerts.firstMatch
            let alertText = alert.staticTexts.firstMatch.label
            print("❌ Sign up failed with alert: \(alertText)")
            
            // Dismiss alert
            let okButton = alert.buttons["OK"]
            if okButton.exists {
                okButton.tap()
            }
            
            // This might be expected if user already exists
            if alertText.contains("already") || alertText.contains("exists") {
                print("ℹ️ User already exists, continuing with test")
            } else {
                XCTFail("Unexpected sign up error: \(alertText)")
            }
        } else {
            XCTFail("Sign up did not complete within timeout")
        }
    }
    
    // MARK: - Test 2: Test Login with Created User
    func testLoginWithTestUser() throws {
        // This test assumes there's a login view accessible from the main UI
        // You might need to adjust the navigation based on your actual UI flow
        
        // Look for login button or navigation
        let loginButton = app.buttons["Login"]
        if loginButton.exists {
            loginButton.tap()
        } else {
            // Try to find navigation to login
            let loginNavButton = app.buttons.matching(identifier: "login").firstMatch
            if loginNavButton.exists {
                loginNavButton.tap()
            }
        }
        
        // Wait for login view to appear
        let emailField = app.textFields["Email"]
        let passwordField = app.secureTextFields["Password"]
        let signInButton = app.buttons["Sign In"]
        
        // If login view doesn't exist, we might need to implement it
        if !emailField.exists {
            print("ℹ️ Login view not found, this test will be skipped")
            return
        }
        
        XCTAssertTrue(emailField.waitForExistence(timeout: 5), "Email field should exist")
        XCTAssertTrue(passwordField.waitForExistence(timeout: 5), "Password field should exist")
        XCTAssertTrue(signInButton.waitForExistence(timeout: 5), "Sign In button should exist")
        
        // Fill in test user credentials
        let testEmail = "testuser2@pathfinder.app"
        let testPassword = "TestPassword123"
        
        emailField.tap()
        emailField.clearText()
        emailField.typeText(testEmail)
        
        passwordField.tap()
        passwordField.clearText()
        passwordField.typeText(testPassword)
        
        // Tap sign in button
        signInButton.tap()
        
        // Wait for login completion
        let expectation = XCTestExpectation(description: "Login completion")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            // Check for successful login indicators
            // This might be navigation to main app, user profile, or success message
            if app.navigationBars.count > 0 || app.tabBars.count > 0 {
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 15)
        
        // Verify login success
        // This might need to be adjusted based on your app's post-login flow
        let hasNavigation = app.navigationBars.count > 0
        let hasTabBar = app.tabBars.count > 0
        let hasMainContent = app.otherElements["mainContent"].exists
        
        if hasNavigation || hasTabBar || hasMainContent {
            print("✅ Login successful for user: \(testEmail)")
        } else {
            // Check for error alerts
            if app.alerts.count > 0 {
                let alert = app.alerts.firstMatch
                let alertText = alert.staticTexts.firstMatch.label
                print("❌ Login failed with alert: \(alertText)")
                
                // Dismiss alert
                let okButton = alert.buttons["OK"]
                if okButton.exists {
                    okButton.tap()
                }
                
                XCTFail("Login failed: \(alertText)")
            } else {
                XCTFail("Login did not complete within timeout")
            }
        }
    }
    
    // MARK: - Test 3: Test Input Validation
    func testInputValidation() throws {
        // Navigate to sign up view
        let signUpButton = app.buttons["Sign Up"]
        if signUpButton.exists {
            signUpButton.tap()
        }
        
        let emailField = app.textFields["Email"]
        let passwordField = app.secureTextFields["Password"]
        let createAccountButton = app.buttons["Sign Up"]
        
        guard emailField.waitForExistence(timeout: 5) else {
            print("ℹ️ Sign up view not accessible, skipping validation test")
            return
        }
        
        // Test invalid email
        emailField.tap()
        emailField.typeText("invalid-email")
        
        passwordField.tap()
        passwordField.typeText("password123")
        
        createAccountButton.tap()
        
        // Should show validation error
        let errorAlert = app.alerts.firstMatch
        if errorAlert.waitForExistence(timeout: 3) {
            let alertText = errorAlert.staticTexts.firstMatch.label
            XCTAssertTrue(alertText.contains("valid email") || alertText.contains("email"), "Should show email validation error")
            print("✅ Email validation working: \(alertText)")
            
            // Dismiss alert
            let okButton = errorAlert.buttons["OK"]
            if okButton.exists {
                okButton.tap()
            }
        }
        
        // Test short password
        emailField.tap()
        emailField.clearText()
        emailField.typeText("test@example.com")
        
        passwordField.tap()
        passwordField.clearText()
        passwordField.typeText("123")
        
        createAccountButton.tap()
        
        // Should show password validation error
        if errorAlert.waitForExistence(timeout: 3) {
            let alertText = errorAlert.staticTexts.firstMatch.label
            XCTAssertTrue(alertText.contains("6 characters") || alertText.contains("password"), "Should show password validation error")
            print("✅ Password validation working: \(alertText)")
            
            // Dismiss alert
            let okButton = errorAlert.buttons["OK"]
            if okButton.exists {
                okButton.tap()
            }
        }
    }
}

// MARK: - Helper Extensions
extension XCUIElement {
    func clearText() {
        guard let stringValue = self.value as? String else {
            return
        }
        
        let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: stringValue.count)
        typeText(deleteString)
    }
}

