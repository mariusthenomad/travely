import SwiftUI
import GoogleSignIn
import Auth
import PostgREST
import Realtime
import Storage
import Functions
import AuthenticationServices

// MARK: - SupabaseCountry Model
struct SupabaseCountry: Codable, Identifiable {
    let id: UUID
    let name: String
    let code: String
    let emoji: String
    let continent: String?
    let capital: String?
    let population: Int?
    let areaKm2: Int?
    let currency: String?
    let language: String?
    let timezone: String?
    let description: String?
    let imageUrl: String?
    let isPopular: Bool
    let createdAt: String
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, code, emoji, continent, capital, population
        case areaKm2 = "area_km2"
        case currency, language, timezone, description
        case imageUrl = "image_url"
        case isPopular = "is_popular"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - SupabaseManager
class SupabaseManager: ObservableObject {
    static let shared = SupabaseManager()
    
    let supabaseURL: URL
    let supabaseKey: String
    lazy var auth: AuthClient = {
        return AuthClient(url: supabaseURL, headers: ["apikey": supabaseKey], localStorage: UserDefaults.standard as! AuthLocalStorage)
    }()
    lazy var database: PostgrestClient = PostgrestClient(url: supabaseURL, headers: ["apikey": supabaseKey])
    lazy var storage: SupabaseStorageClient = {
        let config = StorageClientConfiguration(url: supabaseURL, headers: ["apikey": supabaseKey])
        return SupabaseStorageClient(configuration: config)
    }()
    lazy var functions: FunctionsClient = FunctionsClient(url: supabaseURL, headers: ["apikey": supabaseKey])
    lazy var realtime: RealtimeClientV2 = {
        let options = RealtimeClientOptions(headers: ["apikey": supabaseKey])
        return RealtimeClientV2(url: supabaseURL, options: options)
    }()
    
    private init() {
        self.supabaseURL = URL(string: "https://mlnrhqbnphspbqcpzwez.supabase.co")!
        self.supabaseKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1sbnJocWJucGhzcGJxY3B6d2V6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTg4MzIxMjcsImV4cCI6MjA3NDQwODEyN30.Kb3wbXqktjfwsAKD1jbUqWM-Jgmtnk_7W14sCwqZqyw"
    }
    
    // MARK: - Authentication
    @Published var isAuthenticated = false
    @Published var currentUser: User?
    @Published var isLoading = false
    
    // MARK: - Countries
    @Published var countries: [SupabaseCountry] = []
    @Published var isLoadingCountries = false
    
    func signUp(email: String, password: String) async throws {
        await MainActor.run {
            self.isLoading = true
        }
        
        do {
            print("🚀 Starting REAL Supabase sign up for: \(email)")
            
            // Validate email format
            guard email.contains("@") && email.contains(".") else {
                throw AuthError.invalidEmail
            }
            
            // Validate password length
            guard password.count >= 6 else {
                throw AuthError.passwordTooShort
            }
            
            let response = try await auth.signUp(
                email: email,
                password: password
            )
            
            await MainActor.run {
                self.currentUser = response.user
                self.isAuthenticated = true
                self.isLoading = false
            }
            
            print("✅ Supabase sign up successful! User: \(response.user.email ?? "No email")")
            
        } catch {
            await MainActor.run {
                self.isLoading = false
            }
            print("❌ Supabase sign up error: \(error)")
            throw error
        }
    }
    
    func signIn(email: String, password: String) async throws {
        await MainActor.run {
            self.isLoading = true
        }
        
        do {
            print("🚀 Starting REAL Supabase sign in for: \(email)")
            
            // Validate email format
            guard email.contains("@") && email.contains(".") else {
                throw AuthError.invalidEmail
            }
            
            // Validate password is not empty
            guard !password.isEmpty else {
                throw AuthError.passwordRequired
            }
            
            let response = try await auth.signIn(
                email: email,
                password: password
            )
            
            await MainActor.run {
                self.currentUser = response.user
                self.isAuthenticated = true
                self.isLoading = false
            }
            
            print("✅ Supabase sign in successful! User: \(response.user.email ?? "No email")")
            
        } catch {
            await MainActor.run {
                self.isLoading = false
            }
            print("❌ Supabase sign in error: \(error)")
            throw error
        }
    }
    
    func signOut() async throws {
        try await auth.signOut()
        GIDSignIn.sharedInstance.signOut()
        await MainActor.run {
            self.currentUser = nil
            self.isAuthenticated = false
        }
    }
    
    // MARK: - Google Sign In (Fixed Implementation)
    func signInWithGoogle() async throws {
        await MainActor.run {
            self.isLoading = true
        }
        
        do {
            print("🚀 Starting REAL Google Sign-In...")
            
            guard let presentingViewController = await getRootViewController() else {
                throw AuthError.noViewController
            }
            
            // Perform Google Sign-In
            let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController)
            let user = result.user
            
            guard let idToken = user.idToken?.tokenString else {
                throw AuthError.noIdToken
            }
            
            print("✅ Google Sign-In successful! User: \(user.profile?.email ?? "No email")")
            
            // Sign in to Supabase with Google ID token
            let response = try await auth.signInWithIdToken(
                credentials: .init(provider: .google, idToken: idToken)
            )
            
            await MainActor.run {
                self.currentUser = response.user
                self.isAuthenticated = true
                self.isLoading = false
            }
            
            print("✅ Supabase Google Sign-In successful! User: \(response.user.email ?? "No email")")
            
        } catch {
            await MainActor.run {
                self.isLoading = false
            }
            print("❌ Google Sign-In error: \(error)")
            throw error
        }
    }
    
    // MARK: - Test Supabase Database
    func testSupabaseConnection() async throws {
        print("🧪 Testing Supabase Database Connection...")
        
        do {
            // Test a simple query to see if we can connect to Supabase
            let response = try await database.from("test_table").select().execute()
            print("✅ Supabase Database Connection successful!")
            print("Response: \(response)")
        } catch {
            print("❌ Supabase Database Connection failed: \(error)")
            // This is expected if the table doesn't exist, but it shows the connection works
        }
    }
    
    // MARK: - Test Supabase Storage
    func testSupabaseStorage() async throws {
        print("🧪 Testing Supabase Storage...")
        
        do {
            // Test storage access
            let buckets = try await storage.listBuckets()
            print("✅ Supabase Storage Connection successful!")
            print("Available buckets: \(buckets)")
        } catch {
            print("❌ Supabase Storage Connection failed: \(error)")
        }
    }
    
    // MARK: - Countries Functions
    func fetchCountries() async throws {
        await MainActor.run {
            self.isLoadingCountries = true
        }
        
        do {
            print("🌍 Fetching countries from Supabase...")
            
            let response: [SupabaseCountry] = try await database
                .from("countries")
                .select()
                .order("name")
                .execute()
                .value
            
            await MainActor.run {
                self.countries = response
                self.isLoadingCountries = false
            }
            
            print("✅ Successfully fetched \(response.count) countries from Supabase!")
            for country in response.prefix(5) {
                print("  - \(country.emoji) \(country.name) (\(country.code))")
            }
            
        } catch {
            await MainActor.run {
                self.isLoadingCountries = false
            }
            print("❌ Failed to fetch countries: \(error)")
            throw error
        }
    }
    
    func fetchPopularCountries() async throws {
        await MainActor.run {
            self.isLoadingCountries = true
        }
        
        do {
            print("⭐ Fetching popular countries from Supabase...")
            
            let response: [SupabaseCountry] = try await database
                .from("countries")
                .select()
                .eq("is_popular", value: true)
                .order("name")
                .execute()
                .value
            
            await MainActor.run {
                self.countries = response
                self.isLoadingCountries = false
            }
            
            print("✅ Successfully fetched \(response.count) popular countries from Supabase!")
            for country in response {
                print("  - \(country.emoji) \(country.name) (\(country.code))")
            }
            
        } catch {
            await MainActor.run {
                self.isLoadingCountries = false
            }
            print("❌ Failed to fetch popular countries: \(error)")
            throw error
        }
    }
    
    func addCountry(_ country: SupabaseCountry) async throws {
        do {
            print("➕ Adding country to Supabase: \(country.name)")
            
            let _ = try await database
                .from("countries")
                .insert(country)
                .execute()
            
            print("✅ Successfully added country: \(country.name)")
            
            // Refresh the countries list
            try await fetchCountries()
            
        } catch {
            print("❌ Failed to add country: \(error)")
            throw error
        }
    }
    
    func testCountriesDatabase() async throws {
        print("🧪 Testing Countries Database...")
        
        do {
            // First, try to fetch countries
            try await fetchCountries()
            
            if countries.isEmpty {
                print("ℹ️ No countries found. This might be expected if the table is empty.")
            } else {
                print("✅ Countries database test successful! Found \(countries.count) countries.")
            }
            
        } catch {
            print("❌ Countries database test failed: \(error)")
            throw error
        }
    }
    
    @MainActor
    private func getRootViewController() -> UIViewController? {
        print("Getting root view controller...")
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            print("No window scene found")
            return nil
        }
        
        guard let window = windowScene.windows.first else {
            print("No window found")
            return nil
        }
        
        let rootVC = window.rootViewController
        print("Root view controller: \(String(describing: rootVC))")
        return rootVC
    }
}

// MARK: - Auth Errors
enum AuthError: LocalizedError {
    case noViewController
    case noIdToken
    case googleSignInDisabled
    case invalidEmail
    case passwordTooShort
    case passwordRequired
    case networkError
    case unknownError
    
    var errorDescription: String? {
        switch self {
        case .noViewController:
            return "Could not find root view controller"
        case .noIdToken:
            return "No ID token received from Google"
        case .googleSignInDisabled:
            return "Google Sign-In is temporarily disabled. Please use Email/Password login instead."
        case .invalidEmail:
            return "Please enter a valid email address"
        case .passwordTooShort:
            return "Password must be at least 6 characters long"
        case .passwordRequired:
            return "Password is required"
        case .networkError:
            return "Network error. Please check your internet connection."
        case .unknownError:
            return "An unknown error occurred. Please try again."
        }
    }
}

// MARK: - Premium AuthenticationView
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
        ZStack {
            // Premium Dark Background
            UltraLightDesignSystem.background
                .ignoresSafeArea()
            
            // Background Gradient Overlay
            LinearGradient(
                colors: [
                    UltraLightDesignSystem.primaryOrange.opacity(0.1),
                    Color.clear,
                    UltraLightDesignSystem.primaryGreen.opacity(0.1)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: UltraLightDesignSystem.spaceXL) {
                    Spacer(minLength: 60)
                    
                    // Premium Logo Section
                    VStack(spacing: UltraLightDesignSystem.spaceL) {
                        // App Icon
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [UltraLightDesignSystem.primaryOrange, UltraLightDesignSystem.primaryGreen],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 100, height: 100)
                                .shadow(
                                    color: UltraLightDesignSystem.glowOrange,
                                    radius: 20,
                                    x: 0,
                                    y: 0
                                )
                            
                            Image(systemName: "airplane")
                                .font(.system(size: 40, weight: .medium))
                                .foregroundColor(.white)
                        }
                        
                        // Welcome Text
                        VStack(spacing: UltraLightDesignSystem.spaceS) {
                            Text("Welcome to")
                                .font(.system(size: 24, weight: .light, design: .rounded))
                                .foregroundColor(UltraLightDesignSystem.textSecondary)
                            
                            Text("PathFinder")
                                .font(.system(size: 36, weight: .bold, design: .rounded))
                                .foregroundColor(UltraLightDesignSystem.text)
                            
                            Text("Your premium travel companion")
                                .font(.system(size: 16, weight: .medium, design: .rounded))
                                .foregroundColor(UltraLightDesignSystem.textTertiary)
                        }
                    }
                    
                    // Premium Login Form
                    UltraLightWindow(
                        title: isSignUp ? "Create Account" : "Sign In",
                        subtitle: isSignUp ? "Join the adventure" : "Welcome back, explorer",
                        style: .premium
                    ) {
                        VStack(spacing: UltraLightDesignSystem.spaceL) {
                            // Premium Email Field
                            VStack(alignment: .leading, spacing: UltraLightDesignSystem.spaceS) {
                                Text("Email")
                                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                                    .foregroundColor(UltraLightDesignSystem.textSecondary)
                                
                                TextField("Enter your email", text: $email)
                                    .font(.system(size: 16, weight: .medium, design: .rounded))
                                    .foregroundColor(UltraLightDesignSystem.text)
                                    .keyboardType(.emailAddress)
                                    .autocapitalization(.none)
                                    .disableAutocorrection(true)
                                    .padding(UltraLightDesignSystem.spaceM)
                                    .background(
                                        RoundedRectangle(cornerRadius: UltraLightDesignSystem.radiusM)
                                            .fill(UltraLightDesignSystem.surface)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: UltraLightDesignSystem.radiusM)
                                                    .stroke(
                                                        email.isEmpty ? UltraLightDesignSystem.textMuted.opacity(0.3) : UltraLightDesignSystem.primaryOrange.opacity(0.5),
                                                        lineWidth: 1
                                                    )
                                            )
                                    )
                            }
                            
                            // Premium Password Field
                            VStack(alignment: .leading, spacing: UltraLightDesignSystem.spaceS) {
                                Text("Password")
                                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                                    .foregroundColor(UltraLightDesignSystem.textSecondary)
                                
                                SecureField("Enter your password", text: $password)
                                    .font(.system(size: 16, weight: .medium, design: .rounded))
                                    .foregroundColor(UltraLightDesignSystem.text)
                                    .padding(UltraLightDesignSystem.spaceM)
                                    .background(
                                        RoundedRectangle(cornerRadius: UltraLightDesignSystem.radiusM)
                                            .fill(UltraLightDesignSystem.surface)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: UltraLightDesignSystem.radiusM)
                                                    .stroke(
                                                        password.isEmpty ? UltraLightDesignSystem.textMuted.opacity(0.3) : UltraLightDesignSystem.primaryGreen.opacity(0.5),
                                                        lineWidth: 1
                                                    )
                                            )
                                    )
                            }
                            
                            // Premium Confirm Password Field (only for sign up)
                            if isSignUp {
                                VStack(alignment: .leading, spacing: UltraLightDesignSystem.spaceS) {
                                    Text("Confirm Password")
                                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                                        .foregroundColor(UltraLightDesignSystem.textSecondary)
                                    
                                    SecureField("Confirm your password", text: $confirmPassword)
                                        .font(.system(size: 16, weight: .medium, design: .rounded))
                                        .foregroundColor(UltraLightDesignSystem.text)
                                        .padding(UltraLightDesignSystem.spaceM)
                                        .background(
                                            RoundedRectangle(cornerRadius: UltraLightDesignSystem.radiusM)
                                                .fill(UltraLightDesignSystem.surface)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: UltraLightDesignSystem.radiusM)
                                                        .stroke(
                                                            confirmPassword.isEmpty ? UltraLightDesignSystem.textMuted.opacity(0.3) : UltraLightDesignSystem.accentGold.opacity(0.5),
                                                            lineWidth: 1
                                                        )
                                                )
                                        )
                                }
                            }
                            
                            // Premium Error Message
                            if showError {
                                HStack {
                                    Image(systemName: "exclamationmark.triangle.fill")
                                        .foregroundColor(UltraLightDesignSystem.primaryOrange)
                                    Text(errorMessage)
                                        .font(.system(size: 14, weight: .medium, design: .rounded))
                                        .foregroundColor(UltraLightDesignSystem.primaryOrange)
                                }
                                .padding(UltraLightDesignSystem.spaceM)
                                .background(
                                    RoundedRectangle(cornerRadius: UltraLightDesignSystem.radiusM)
                                        .fill(UltraLightDesignSystem.primaryOrange.opacity(0.1))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: UltraLightDesignSystem.radiusM)
                                                .stroke(UltraLightDesignSystem.primaryOrange.opacity(0.3), lineWidth: 1)
                                        )
                                )
                            }
                            
                            // Premium Action Button
                            Button(action: handleEmailAuthentication) {
                                HStack {
                                    if supabaseManager.isLoading {
                                        ProgressView()
                                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                            .scaleEffect(0.8)
                                    } else {
                                        Image(systemName: isSignUp ? "person.badge.plus" : "arrow.right")
                                            .font(.system(size: 16, weight: .semibold))
                                    }
                                    
                                    Text(isSignUp ? "Create Account" : "Sign In")
                                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(
                                    RoundedRectangle(cornerRadius: UltraLightDesignSystem.radiusM)
                                        .fill(
                                            isFormValid ? 
                                            LinearGradient(
                                                colors: [UltraLightDesignSystem.primaryOrange, UltraLightDesignSystem.primaryGreen],
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            ) :
                                            LinearGradient(
                                                colors: [UltraLightDesignSystem.textMuted, UltraLightDesignSystem.textMuted],
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            )
                                        )
                                        .shadow(
                                            color: isFormValid ? UltraLightDesignSystem.glowOrange : .clear,
                                            radius: 10,
                                            x: 0,
                                            y: 4
                                        )
                                )
                            }
                            .disabled(!isFormValid || supabaseManager.isLoading)
                            .animation(.easeInOut(duration: 0.2), value: isFormValid)
                        }
                    }
                    
                    // Premium Social Login Section
                    VStack(spacing: UltraLightDesignSystem.spaceL) {
                        // Divider
                        HStack {
                            Rectangle()
                                .fill(UltraLightDesignSystem.textMuted.opacity(0.3))
                                .frame(height: 1)
                            Text("or continue with")
                                .font(.system(size: 14, weight: .medium, design: .rounded))
                                .foregroundColor(UltraLightDesignSystem.textTertiary)
                            Rectangle()
                                .fill(UltraLightDesignSystem.textMuted.opacity(0.3))
                                .frame(height: 1)
                        }
                        
                        // Social Login Buttons
                        VStack(spacing: UltraLightDesignSystem.spaceM) {
                            // Apple Sign In Button
                            SignInWithAppleButton(
                                onRequest: { request in
                                    request.requestedScopes = [.fullName, .email]
                                },
                                onCompletion: { result in
                                    handleAppleSignIn(result: result)
                                }
                            )
                            .signInWithAppleButtonStyle(.white)
                            .frame(height: 56)
                            .cornerRadius(UltraLightDesignSystem.radiusM)
                            
                            // Google Sign In Button
                            Button(action: handleGoogleSignIn) {
                                HStack(spacing: UltraLightDesignSystem.spaceM) {
                                    Image(systemName: "globe")
                                        .font(.system(size: 18, weight: .medium))
                                        .foregroundColor(.white)
                                    Text("Continue with Google")
                                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                                        .foregroundColor(.white)
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(
                                    RoundedRectangle(cornerRadius: UltraLightDesignSystem.radiusM)
                                        .fill(Color.red)
                                        .shadow(
                                            color: Color.red.opacity(0.3),
                                            radius: 8,
                                            x: 0,
                                            y: 4
                                        )
                                )
                            }
                        }
                    }
                    
                    // Premium Toggle and Skip Section
                    VStack(spacing: UltraLightDesignSystem.spaceL) {
                        // Toggle Sign Up/Sign In
                        Button(action: { 
                            isSignUp.toggle()
                            errorMessage = ""
                            showError = false
                        }) {
                            Text(isSignUp ? "Already have an account? Sign In" : "Don't have an account? Sign Up")
                                .font(.system(size: 15, weight: .medium, design: .rounded))
                                .foregroundColor(UltraLightDesignSystem.primaryOrange)
                        }
                        
                        // Premium Skip Button
                        Button(action: handleSkipLogin) {
                            HStack(spacing: UltraLightDesignSystem.spaceS) {
                                Image(systemName: "arrow.right.circle")
                                    .font(.system(size: 16, weight: .medium))
                                Text("Skip Login")
                                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                            }
                            .foregroundColor(UltraLightDesignSystem.textTertiary)
                            .padding(.horizontal, UltraLightDesignSystem.spaceL)
                            .padding(.vertical, UltraLightDesignSystem.spaceM)
                            .background(
                                RoundedRectangle(cornerRadius: UltraLightDesignSystem.radiusL)
                                    .fill(UltraLightDesignSystem.surface)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: UltraLightDesignSystem.radiusL)
                                            .stroke(UltraLightDesignSystem.textMuted.opacity(0.3), lineWidth: 1)
                                    )
                            )
                        }
                    }
                    
                    Spacer(minLength: 40)
                }
                .padding(.horizontal, UltraLightDesignSystem.spaceL)
            }
        }
        .navigationBarHidden(true)
        .alert("Authentication Error", isPresented: $showError) {
            Button("OK") { showError = false }
        } message: {
            Text(errorMessage)
        }
    }
    
    private var isFormValid: Bool {
        if isSignUp {
            return !email.isEmpty && !password.isEmpty && !confirmPassword.isEmpty && password == confirmPassword && email.contains("@")
        } else {
            return !email.isEmpty && !password.isEmpty && email.contains("@")
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
                    // Handle different types of errors
                    if let authError = error as? AuthError {
                        errorMessage = authError.errorDescription ?? "Google Sign-In failed"
                    } else {
                        errorMessage = error.localizedDescription
                    }
                    showError = true
                }
            }
        }
    }
    
    private func handleAppleSignIn(result: Result<ASAuthorization, Error>) {
        errorMessage = ""
        showError = false
        
        switch result {
        case .success(let authorization):
            if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                Task {
                    do {
                        // For now, we'll just set authenticated to true for Apple Sign-In
                        // In a real implementation, you would handle the Apple ID token with Supabase
                        await MainActor.run {
                            supabaseManager.isAuthenticated = true
                            supabaseManager.currentUser = nil // Set to nil for Apple Sign-In
                        }
                    } catch {
                        await MainActor.run {
                            errorMessage = error.localizedDescription
                            showError = true
                        }
                    }
                }
            }
        case .failure(let error):
            errorMessage = error.localizedDescription
            showError = true
        }
    }
    
    private func handleEmailAuthentication() {
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
                    // Handle different types of errors
                    if let authError = error as? AuthError {
                        errorMessage = authError.errorDescription ?? "Authentication failed"
                    } else {
                        errorMessage = error.localizedDescription
                    }
                    showError = true
                }
            }
        }
    }
    
    private func handleSkipLogin() {
        // Skip login for testing - set authenticated to true
        supabaseManager.isAuthenticated = true
        // Create a mock user for testing
        supabaseManager.currentUser = nil // We'll set this to nil for skip mode
    }
}

@main
struct PathFinderApp: App {
    @StateObject private var themeManager = ThemeManager()
    @StateObject private var supabaseManager = SupabaseManager.shared
    
    init() {
        // Configure Google Sign-In
        configureGoogleSignIn()
    }
    
    var body: some Scene {
        WindowGroup {
            Group {
                if supabaseManager.isAuthenticated {
                    ContentView()
                } else {
                    AuthenticationView()
                }
            }
            .environmentObject(themeManager)
            .environmentObject(supabaseManager)
            .preferredColorScheme(themeManager.isDarkMode ? .dark : .light)
            .onOpenURL { url in
                GIDSignIn.sharedInstance.handle(url)
            }
        }
    }
    
    private func configureGoogleSignIn() {
        // Set CLIENT_ID directly (hardcoded for now to fix the issue)
        let clientId = "1033990407187-mffia1va0it83u51clbvmi40ol0adi3l.apps.googleusercontent.com"
        print("Setting CLIENT_ID directly: \(clientId)")
        
        // Configure Google Sign-In with proper settings
        GIDSignIn.sharedInstance.configuration = GIDConfiguration(clientID: clientId)
        
        // Enable automatic sign-in restoration (this is important for Safari flow)
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if let error = error {
                // Code -4 is normal - means no previous sign-in to restore
                if (error as NSError).code == -4 {
                    print("ℹ️ No previous sign-in to restore (normal)")
                } else {
                    print("⚠️ Error restoring previous sign-in: \(error)")
                }
            } else if let user = user {
                print("✅ Previous sign-in restored: \(user.profile?.email ?? "No email")")
            } else {
                print("ℹ️ No previous sign-in to restore")
            }
        }
        
        print("✅ Google Sign-In configuration completed")
    }
}
