import Foundation
import Supabase
import SwiftUI

// MARK: - Supabase Auth Manager
class SupabaseAuthManager: ObservableObject {
    private let supabase: SupabaseClient
    
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isSignedUp = false
    
    init() {
        // Initialize Supabase client with your project URL and anon key
        supabase = SupabaseClient(
            supabaseURL: URL(string: "YOUR_SUPABASE_URL")!,
            supabaseKey: "YOUR_SUPABASE_ANON_KEY"
        )
    }
    
    // MARK: - Sign Up Function
    @MainActor
    func signUpUser(email: String, password: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            // 1. Create user account with Supabase Auth
            let authResponse = try await supabase.auth.signUp(
                email: email,
                password: password
            )
            
            guard let user = authResponse.user else {
                throw AuthError.userCreationFailed
            }
            
            print("✅ User created successfully with ID: \(user.id)")
            
            // 2. Insert user into profiles table
            let profile = Profile(
                id: user.id,
                email: email,
                createdAt: Date()
            )
            
            try await supabase.database
                .from("profiles")
                .insert(profile)
                .execute()
            
            print("✅ Profile created successfully")
            
            // 3. Success - update UI state
            isSignedUp = true
            isLoading = false
            
        } catch {
            // 4. Handle errors
            await handleError(error)
        }
    }
    
    // MARK: - Error Handling
    @MainActor
    private func handleError(_ error: Error) {
        isLoading = false
        
        if let authError = error as? AuthError {
            errorMessage = authError.localizedDescription
        } else if let postgrestError = error as? PostgrestError {
            errorMessage = "Database error: \(postgrestError.message)"
        } else {
            errorMessage = "An unexpected error occurred: \(error.localizedDescription)"
        }
        
        print("❌ Sign up error: \(errorMessage ?? "Unknown error")")
    }
    
    // MARK: - Clear Error
    func clearError() {
        errorMessage = nil
    }
}

// MARK: - Profile Model
struct Profile: Codable {
    let id: UUID
    let email: String
    let createdAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case email
        case createdAt = "created_at"
    }
}

// MARK: - Custom Auth Errors
enum AuthError: LocalizedError {
    case userCreationFailed
    case profileCreationFailed
    case invalidCredentials
    
    var errorDescription: String? {
        switch self {
        case .userCreationFailed:
            return "Failed to create user account. Please try again."
        case .profileCreationFailed:
            return "Failed to create user profile. Please try again."
        case .invalidCredentials:
            return "Invalid email or password format."
        }
    }
}

// MARK: - Sign Up View Example
struct SignUpView: View {
    @StateObject private var authManager = SupabaseAuthManager()
    @State private var email = ""
    @State private var password = ""
    @State private var showingAlert = false
    
    var body: some View {
        VStack(spacing: 20) {
            // Email Text Field
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .disableAutocorrection(true)
            
            // Password Text Field
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            // Sign Up Button
            Button(action: {
                Task {
                    await signUpButtonTapped()
                }
            }) {
                HStack {
                    if authManager.isLoading {
                        ProgressView()
                            .scaleEffect(0.8)
                    }
                    Text(authManager.isLoading ? "Creating Account..." : "Sign Up")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(UltraLightDesignSystem.primaryOrange)
                .foregroundColor(.white)
                .cornerRadius(UltraLightDesignSystem.radiusM)
            }
            .disabled(authManager.isLoading || email.isEmpty || password.isEmpty)
            
            // Success Message
            if authManager.isSignedUp {
                Text("✅ Account created successfully!")
                    .foregroundColor(.green)
                    .font(.headline)
            }
            
            Spacer()
        }
        .padding()
        .alert("Sign Up Error", isPresented: $showingAlert) {
            Button("OK") {
                authManager.clearError()
            }
        } message: {
            Text(authManager.errorMessage ?? "Unknown error occurred")
        }
        .onChange(of: authManager.errorMessage) { errorMessage in
            showingAlert = errorMessage != nil
        }
    }
    
    // MARK: - Button Action Handler
    private func signUpButtonTapped() async {
        // Validate input
        guard !email.isEmpty, !password.isEmpty else {
            authManager.errorMessage = "Please fill in all fields"
            return
        }
        
        guard isValidEmail(email) else {
            authManager.errorMessage = "Please enter a valid email address"
            return
        }
        
        guard password.count >= 6 else {
            authManager.errorMessage = "Password must be at least 6 characters long"
            return
        }
        
        // Call the sign up function
        await authManager.signUpUser(email: email, password: password)
    }
    
    // MARK: - Email Validation
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}

// MARK: - Usage Example in ContentView
extension ContentView {
    // Example of how to integrate the sign up functionality
    private func showSignUpView() {
        // You can present this view as a sheet or navigate to it
        // For example:
        // .sheet(isPresented: $showingSignUp) {
        //     SignUpView()
        // }
    }
}

// MARK: - Preview
struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}

