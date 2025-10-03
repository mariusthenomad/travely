# PathFinder Authentication Tests

This directory contains comprehensive test files for the PathFinder iOS app's authentication system, including Google Sign-In and Email/Password authentication with Supabase.

## 📁 Test File Structure

```
PathFinderTests/
├── README.md                           # This documentation
├── MockServices.swift                  # Mock services and test utilities
├── GoogleSignInTests.swift            # Google Sign-In test cases
├── EmailPasswordAuthTests.swift       # Email/Password authentication tests
└── SupabaseManagerIntegrationTests.swift # Integration tests for SupabaseManager
```

## 🧪 Test Categories

### 1. MockServices.swift
**Purpose:** Provides mock implementations for testing without real API calls

**Key Components:**
- `MockGoogleSignInResult` - Mocks Google Sign-In results
- `MockGoogleUser` - Mocks Google user data
- `MockAuthClient` - Mocks Supabase authentication client
- `MockGoogleSignInManager` - Mocks Google Sign-In manager
- `TestAuthError` - Custom test error types

**What to Mock vs Real API:**
- ✅ **Mock:** Google Sign-In SDK calls, Supabase Auth API calls
- ✅ **Mock:** Network delays, error scenarios
- ❌ **Real:** Basic Swift validation logic, state management

### 2. GoogleSignInTests.swift
**Purpose:** Tests Google Sign-In functionality with various scenarios

**Test Cases:**
- ✅ Successful Google Sign-In flow
- ✅ Google Sign-In with Supabase failure
- ❌ User cancels Google Sign-In
- ❌ Network error during Google Sign-In
- ❌ No ID token received from Google
- 🔄 State management during Google Sign-In
- ⚡ Performance testing

### 3. EmailPasswordAuthTests.swift
**Purpose:** Tests Email/Password authentication with Supabase

**Test Cases:**
- ✅ Successful email sign-up
- ✅ Successful email sign-in
- ✅ State management after authentication
- ❌ Invalid email format
- ❌ Password too short
- ❌ Wrong password
- ❌ Non-existent email
- ❌ Network errors
- ✅ Input validation logic
- ⚡ Performance testing
- 🔍 Edge cases (empty inputs, special characters)

### 4. SupabaseManagerIntegrationTests.swift
**Purpose:** Integration tests for the complete authentication flow

**Test Cases:**
- 🔄 Initial authentication state
- 🔄 State management after sign-up/sign-in/sign-out
- 🔄 Loading state management
- ❌ Error handling and state reset
- 🔄 Concurrent authentication attempts
- 🧠 Memory management
- ⚡ Performance testing

## 🚀 How to Run Tests in Xcode

### Method 1: Run All Tests
1. **Open Xcode** and load your PathFinder project
2. **Select the test target** in the navigator (PathFinderTests)
3. **Press `Cmd + U`** or go to **Product → Test**
4. **Wait for completion** - all tests will run automatically

### Method 2: Run Individual Test Files
1. **Navigate to the test file** you want to run (e.g., `GoogleSignInTests.swift`)
2. **Click the diamond icon** next to the class name or specific test method
3. **Select "Run"** from the dropdown menu

### Method 3: Run Specific Test Methods
1. **Open the test file** containing the test you want to run
2. **Click the diamond icon** next to the specific test method name
3. **Select "Run"** to execute only that test

### Method 4: Using Test Navigator
1. **Open Test Navigator** (`Cmd + 6`)
2. **Expand PathFinderTests** to see all test classes
3. **Click the play button** next to individual tests or test classes

## 📊 Understanding Test Results

### ✅ Success Indicators
- **Green checkmarks** next to test methods
- **"Test Succeeded"** message in the test navigator
- **No red error messages** in the console

### ❌ Failure Indicators
- **Red X marks** next to failed test methods
- **Red error messages** in the test navigator
- **Detailed error information** in the console

### 🔍 Debugging Failed Tests
1. **Click on the failed test** in the test navigator
2. **Check the console output** for detailed error messages
3. **Set breakpoints** in the test code to debug step by step
4. **Use the debugger** to inspect variable values

## 🛠️ Test Configuration

### Prerequisites
- Xcode 15.0 or later
- iOS 17.0+ deployment target
- Swift 5.9 or later

### Dependencies
The tests use the following frameworks:
- `XCTest` - Apple's testing framework
- `GoogleSignIn` - Google Sign-In SDK (mocked)
- `Auth` - Supabase Auth (mocked)
- `PostgREST` - Supabase database client (mocked)

### Test Environment Setup
```swift
override func setUp() {
    super.setUp()
    // Initialize mock services
    mockAuthClient = MockAuthClient()
    mockGoogleSignInManager = MockGoogleSignInManager()
    supabaseManager = SupabaseManager.shared
    
    // Reset states
    mockAuthClient.shouldSucceed = true
    mockAuthClient.mockError = nil
}

override func tearDown() {
    // Clean up resources
    mockAuthClient = nil
    mockGoogleSignInManager = nil
    supabaseManager = nil
    super.tearDown()
}
```

## 🎯 Test Coverage

### Authentication Flows Covered
- [x] Google Sign-In (success/failure scenarios)
- [x] Email/Password Sign-Up (success/failure scenarios)
- [x] Email/Password Sign-In (success/failure scenarios)
- [x] Sign-Out functionality
- [x] State management throughout all flows
- [x] Error handling and recovery
- [x] Input validation
- [x] Performance characteristics

### Edge Cases Covered
- [x] Network connectivity issues
- [x] Invalid input formats
- [x] User cancellation
- [x] Concurrent operations
- [x] Memory management
- [x] Loading state management

## 🔧 Customizing Tests

### Adding New Test Cases
1. **Create a new test method** following the naming convention: `test[Description]()`
2. **Use async/await** for asynchronous operations
3. **Set up expectations** for async operations: `XCTestExpectation`
4. **Use proper assertions** to verify expected behavior
5. **Clean up resources** in tearDown if needed

### Example Test Method Structure
```swift
func testNewAuthenticationScenario() async throws {
    // Given
    let email = "test@example.com"
    let password = "password123"
    mockAuthClient.shouldSucceed = true
    
    // When
    let expectation = XCTestExpectation(description: "Test description")
    
    Task {
        do {
            let result = try await mockAuthClient.signIn(email: email, password: password)
            
            // Then
            XCTAssertNotNil(result)
            expectation.fulfill()
        } catch {
            XCTFail("Test should succeed: \(error)")
        }
    }
    
    await fulfillment(of: [expectation], timeout: 5.0)
}
```

### Modifying Mock Behavior
```swift
// Make mock succeed
mockAuthClient.shouldSucceed = true
mockAuthClient.mockError = nil

// Make mock fail with specific error
mockAuthClient.shouldSucceed = false
mockAuthClient.mockError = TestAuthError.networkError
```

## 📈 Continuous Integration

### Running Tests in CI/CD
```bash
# Run tests from command line
xcodebuild test -scheme PathFinder -destination 'platform=iOS Simulator,name=iPhone 15,OS=latest'

# Run specific test class
xcodebuild test -scheme PathFinder -destination 'platform=iOS Simulator,name=iPhone 15,OS=latest' -only-testing:PathFinderTests/GoogleSignInTests

# Run specific test method
xcodebuild test -scheme PathFinder -destination 'platform=iOS Simulator,name=iPhone 15,OS=latest' -only-testing:PathFinderTests/GoogleSignInTests/testSuccessfulGoogleSignIn
```

## 🐛 Troubleshooting

### Common Issues

**1. Tests not running**
- Check that the test target is properly configured
- Verify that test files are added to the test target
- Ensure all dependencies are properly imported

**2. Mock services not working**
- Verify that mock classes inherit from the correct base classes
- Check that mock methods override the correct parent methods
- Ensure mock state is properly reset in setUp()

**3. Async tests timing out**
- Increase timeout values for slow operations
- Check that expectations are properly fulfilled
- Verify that async operations are properly awaited

**4. State management issues**
- Ensure MainActor.run is used for UI state updates
- Check that state is properly reset between tests
- Verify that published properties are correctly updated

### Getting Help
- Check the Xcode console for detailed error messages
- Use the debugger to step through failing tests
- Review the test output in the test navigator
- Consult Apple's XCTest documentation for advanced testing patterns

## 📚 Additional Resources

- [Apple XCTest Documentation](https://developer.apple.com/documentation/xctest)
- [Swift Testing Best Practices](https://developer.apple.com/documentation/xctest/defining_test_cases_and_test_methods)
- [Async Testing in Swift](https://developer.apple.com/documentation/xctest/asynchronous_tests_and_expectations)
- [Mocking in Swift](https://developer.apple.com/documentation/xctest/mocking_techniques)

---

**Happy Testing! 🧪✨**

Remember: Good tests are your safety net. They catch bugs before they reach users and give you confidence when refactoring code.
