import SwiftUI
import Supabase

struct AuthenticationView: View {
    @EnvironmentObject var supabaseManager: SupabaseManager
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var isSignUp = false
    @State private var errorMessage = ""
    @State private var showError = false
    
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                themeManager.oledBackgroundColor
                    .ignoresSafeArea()
                
                VStack(spacing: 32) {
                    // Logo/Title
                    VStack(spacing: 16) {
                        Image(systemName: "airplane.circle.fill")
                            .font(.system(size: 80))
                            .foregroundColor(themeManager.primaryColor)
                        
                        Text("Travely")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(themeManager.textColor)
                        
                        Text("Plan your perfect trip")
                            .font(.subheadline)
                            .foregroundColor(themeManager.secondaryTextColor)
                    }
                    
                    // Form
                    VStack(spacing: 20) {
                        // Email Field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Email")
                                .font(.headline)
                                .foregroundColor(themeManager.textColor)
                            
                            TextField("Enter your email", text: $email)
                                .textFieldStyle(CustomTextFieldStyle(themeManager: themeManager))
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                        }
                        
                        // Password Field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Password")
                                .font(.headline)
                                .foregroundColor(themeManager.textColor)
                            
                            SecureField("Enter your password", text: $password)
                                .textFieldStyle(CustomTextFieldStyle(themeManager: themeManager))
                        }
                        
                        // Confirm Password (only for sign up)
                        if isSignUp {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Confirm Password")
                                    .font(.headline)
                                    .foregroundColor(themeManager.textColor)
                                
                                SecureField("Confirm your password", text: $confirmPassword)
                                    .textFieldStyle(CustomTextFieldStyle(themeManager: themeManager))
                            }
                        }
                        
                        // Error Message
                        if showError {
                            Text(errorMessage)
                                .font(.caption)
                                .foregroundColor(.red)
                                .padding(.horizontal)
                        }
                        
                        // Google Sign In Button
                        Button(action: handleGoogleSignIn) {
                            HStack {
                                Image(systemName: "globe")
                                    .font(.title2)
                                
                                Text("Continue with Google")
                                    .font(.headline)
                                    .foregroundColor(.white)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.red)
                            .cornerRadius(12)
                        }
                        .disabled(supabaseManager.isLoading)
                        
                        // Divider
                        HStack {
                            Rectangle()
                                .frame(height: 1)
                                .foregroundColor(themeManager.secondaryTextColor.opacity(0.3))
                            
                            Text("or")
                                .font(.caption)
                                .foregroundColor(themeManager.secondaryTextColor)
                                .padding(.horizontal, 16)
                            
                            Rectangle()
                                .frame(height: 1)
                                .foregroundColor(themeManager.secondaryTextColor.opacity(0.3))
                        }
                        .padding(.vertical, 8)
                        
                        // Email/Password Action Button
                        Button(action: handleEmailAuthentication) {
                            HStack {
                                if supabaseManager.isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        .scaleEffect(0.8)
                                }
                                
                                Text(isSignUp ? "Sign Up with Email" : "Sign In with Email")
                                    .font(.headline)
                                    .foregroundColor(.white)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(themeManager.primaryColor)
                            .cornerRadius(12)
                        }
                        .disabled(supabaseManager.isLoading || !isFormValid)
                        
                        // Toggle Sign Up/Sign In
                        Button(action: { 
                            isSignUp.toggle()
                            errorMessage = ""
                            showError = false
                        }) {
                            Text(isSignUp ? "Already have an account? Sign In" : "Don't have an account? Sign Up")
                                .font(.subheadline)
                                .foregroundColor(themeManager.primaryColor)
                        }
                    }
                    .padding(.horizontal, 32)
                    
                    Spacer()
                }
                .padding(.top, 60)
            }
            .navigationBarHidden(true)
        }
    }
    
    private var isFormValid: Bool {
        if isSignUp {
            return !email.isEmpty && 
                   !password.isEmpty && 
                   !confirmPassword.isEmpty && 
                   password == confirmPassword &&
                   password.count >= 6
        } else {
            return !email.isEmpty && !password.isEmpty
        }
    }
    
    private func handleGoogleSignIn() {
        errorMessage = ""
        showError = false
        
        Task {
            do {
                try await supabaseManager.signInWithGoogle()
            } catch {
                await MainActor.run {
                    errorMessage = error.localizedDescription
                    showError = true
                }
            }
        }
    }
    
    private func handleEmailAuthentication() {
        guard isFormValid else { return }
        
        errorMessage = ""
        showError = false
        
        Task {
            do {
                if isSignUp {
                    try await supabaseManager.signUp(email: email, password: password)
                } else {
                    try await supabaseManager.signIn(email: email, password: password)
                }
            } catch {
                await MainActor.run {
                    errorMessage = error.localizedDescription
                    showError = true
                }
            }
        }
    }
}

struct CustomTextFieldStyle: TextFieldStyle {
    let themeManager: ThemeManager
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(themeManager.cardBackgroundColor)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(themeManager.primaryColor.opacity(0.3), lineWidth: 1)
            )
    }
}

#Preview {
    AuthenticationView()
        .environmentObject(ThemeManager())
}
