import SwiftUI
import Supabase

// MARK: - Login View
struct LoginView: View {
    @StateObject private var authManager = SupabaseAuthManager()
    @State private var email = ""
    @State private var password = ""
    @State private var showingAlert = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                UltraLightDesignSystem.background
                    .ignoresSafeArea()
                
                VStack {
                    // Header
                    UltraLightWindow(
                        title: "Welcome Back",
                        subtitle: "Sign in to your account",
                        style: .premium
                    ) {
                        EmptyView()
                    }
                    
                    Spacer()
                    
                    // Login Form
                    UltraLightWindow(
                        title: "Sign In",
                        style: .standard
                    ) {
                        VStack(spacing: UltraLightDesignSystem.spaceM) {
                            // Email Field
                            VStack(alignment: .leading, spacing: UltraLightDesignSystem.spaceXS) {
                                Text("Email")
                                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                                    .foregroundColor(UltraLightDesignSystem.textSecondary)
                                
                                TextField("Enter your email", text: $email)
                                    .textFieldStyle(PlainTextFieldStyle())
                                    .padding(UltraLightDesignSystem.spaceS)
                                    .background(UltraLightDesignSystem.surface)
                                    .cornerRadius(UltraLightDesignSystem.radiusM)
                                    .foregroundColor(UltraLightDesignSystem.text)
                                    .keyboardType(.emailAddress)
                                    .autocapitalization(.none)
                                    .disableAutocorrection(true)
                            }
                            
                            // Password Field
                            VStack(alignment: .leading, spacing: UltraLightDesignSystem.spaceXS) {
                                Text("Password")
                                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                                    .foregroundColor(UltraLightDesignSystem.textSecondary)
                                
                                SecureField("Enter your password", text: $password)
                                    .textFieldStyle(PlainTextFieldStyle())
                                    .padding(UltraLightDesignSystem.spaceS)
                                    .background(UltraLightDesignSystem.surface)
                                    .cornerRadius(UltraLightDesignSystem.radiusM)
                                    .foregroundColor(UltraLightDesignSystem.text)
                            }
                            
                            // Sign In Button
                            Button(action: {
                                Task {
                                    await signInButtonTapped()
                                }
                            }) {
                                HStack {
                                    if authManager.isLoading {
                                        ProgressView()
                                            .scaleEffect(0.8)
                                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    }
                                    Text(authManager.isLoading ? "Signing In..." : "Sign In")
                                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                                }
                                .frame(maxWidth: .infinity)
                                .padding(UltraLightDesignSystem.spaceS)
                                .background(
                                    LinearGradient(
                                        colors: [UltraLightDesignSystem.primaryOrange, UltraLightDesignSystem.primaryOrange.opacity(0.8)],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .foregroundColor(.white)
                                .cornerRadius(UltraLightDesignSystem.radiusM)
                                .shadow(color: UltraLightDesignSystem.primaryOrange.opacity(0.3), radius: 8, x: 0, y: 4)
                            }
                            .disabled(authManager.isLoading || email.isEmpty || password.isEmpty)
                            
                            // Sign Up Link
                            HStack {
                                Text("Don't have an account?")
                                    .font(.system(size: 14, weight: .medium, design: .rounded))
                                    .foregroundColor(UltraLightDesignSystem.textSecondary)
                                
                                Button("Sign Up") {
                                    // Navigate to sign up view
                                    // This would typically be handled by a parent view or navigation
                                }
                                .font(.system(size: 14, weight: .semibold, design: .rounded))
                                .foregroundColor(UltraLightDesignSystem.primaryOrange)
                            }
                        }
                    }
                    
                    Spacer()
                    
                    // Google Sign In Button
                    VStack(spacing: UltraLightDesignSystem.spaceM) {
                        // Divider
                        HStack {
                            Rectangle()
                                .fill(UltraLightDesignSystem.textTertiary)
                                .frame(height: 1)
                            
                            Text("or")
                                .font(.system(size: 14, weight: .medium, design: .rounded))
                                .foregroundColor(UltraLightDesignSystem.textSecondary)
                                .padding(.horizontal, UltraLightDesignSystem.spaceM)
                            
                            Rectangle()
                                .fill(UltraLightDesignSystem.textTertiary)
                                .frame(height: 1)
                        }
                        .padding(.horizontal, UltraLightDesignSystem.spaceL)
                        
                        // Google Sign In Button
                        Button(action: {
                            Task {
                                await handleGoogleSignIn()
                            }
                        }) {
                            HStack {
                                Image(systemName: "globe")
                                    .font(.system(size: 16, weight: .semibold))
                                
                                Text("Continue with Google")
                                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                            }
                            .frame(maxWidth: .infinity)
                            .padding(UltraLightDesignSystem.spaceM)
                            .background(UltraLightDesignSystem.ultraLightSurface)
                            .foregroundColor(UltraLightDesignSystem.text)
                            .cornerRadius(UltraLightDesignSystem.radiusM)
                            .overlay(
                                RoundedRectangle(cornerRadius: UltraLightDesignSystem.radiusM)
                                    .stroke(UltraLightDesignSystem.textTertiary, lineWidth: 1)
                            )
                        }
                        .disabled(authManager.isLoading)
                    }
                }
                .offset(y: -100) // Shift entire layout 100px up
                .padding(.horizontal, UltraLightDesignSystem.spaceM)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(UltraLightDesignSystem.primaryOrange)
                }
            }
            .alert("Sign In Error", isPresented: $showingAlert) {
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
    }
    
    // MARK: - Sign In Button Action
    private func signInButtonTapped() async {
        // Validate input
        guard !email.isEmpty, !password.isEmpty else {
            authManager.errorMessage = "Please fill in all fields"
            return
        }
        
        guard isValidEmail(email) else {
            authManager.errorMessage = "Please enter a valid email address"
            return
        }
        
        // Call the sign in function
        await authManager.signInUser(email: email, password: password)
    }
    
    // MARK: - Google Sign In Action
    private func handleGoogleSignIn() async {
        await authManager.handleGoogleSignIn()
    }
    
    // MARK: - Email Validation
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}

// MARK: - Extended SupabaseAuthManager for Login
extension SupabaseAuthManager {
    @MainActor
    func signInUser(email: String, password: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            // Sign in with Supabase Auth
            let authResponse = try await supabase.auth.signIn(
                email: email,
                password: password
            )
            
            guard let user = authResponse.user else {
                throw AuthError.userCreationFailed
            }
            
            print("✅ User signed in successfully with ID: \(user.id)")
            
            // Success - update UI state
            isSignedUp = true // Reuse this flag for signed in state
            isLoading = false
            
        } catch {
            // Handle errors
            await handleError(error)
        }
    }
}

// MARK: - Preview
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

