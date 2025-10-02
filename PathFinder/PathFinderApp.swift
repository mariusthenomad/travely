import SwiftUI
import GoogleSignIn
import Auth
import PostgREST
import Realtime
import Storage
import Functions

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

// MARK: - AuthenticationView
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
            VStack(spacing: 20) {
                Text("Welcome to PathFinder")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text("Sign in to start your journey")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                VStack(spacing: 15) {
                    // Email Field
                    TextField("Email", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    
                    // Password Field
                    SecureField("Password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .textContentType(.none)
                        .autocorrectionDisabled()
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                    
                    // Confirm Password Field (only for sign up)
                    if isSignUp {
                        SecureField("Confirm Password", text: $confirmPassword)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .textContentType(.none)
                            .autocorrectionDisabled()
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                    }
                }
                .padding(.horizontal)
                
                // Google Sign In Button
                Button(action: handleGoogleSignIn) {
                    HStack {
                        if supabaseManager.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .scaleEffect(0.8)
                        } else {
                            Image(systemName: "globe")
                                .font(.title2)
                        }
                        
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
                .padding(.horizontal)
                
                // Divider
                HStack {
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.gray.opacity(0.3))
                    
                    Text("or")
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 10)
                    
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.gray.opacity(0.3))
                }
                .padding(.horizontal)
                
                // Email/Password Action Button
                Button(action: handleEmailAuthentication) {
                    HStack {
                        if supabaseManager.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .scaleEffect(0.8)
                        }
                        
                        Text(isSignUp ? "Sign Up" : "Sign In")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(isFormValid ? Color.blue : Color.gray)
                    .cornerRadius(12)
                }
                .disabled(!isFormValid || supabaseManager.isLoading)
                .padding(.horizontal)
                
                // Toggle Sign Up/Sign In
                Button(action: { 
                    isSignUp.toggle()
                    errorMessage = ""
                    showError = false
                }) {
                    Text(isSignUp ? "Already have an account? Sign In" : "Don't have an account? Sign Up")
                        .foregroundColor(.blue)
                }
                .padding(.top, 10)
                
                // Skip Button for testing
                Button(action: handleSkipLogin) {
                    Text("Skip Login (Test Mode)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.top, 20)
                
                // Test Supabase Connection Button
                Button(action: {
                    Task {
                        do {
                            try await supabaseManager.testSupabaseConnection()
                            try await supabaseManager.testSupabaseStorage()
                        } catch {
                            print("Test failed: \(error)")
                        }
                    }
                }) {
                    Text("Test Supabase Connection")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }
                .padding(.top, 10)
                
                // Test Countries Database Button
                Button(action: {
                    Task {
                        do {
                            try await supabaseManager.testCountriesDatabase()
                        } catch {
                            print("Countries test failed: \(error)")
                        }
                    }
                }) {
                    HStack {
                        if supabaseManager.isLoadingCountries {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                                .scaleEffect(0.7)
                        }
                        Text("Test Countries Database")
                            .font(.subheadline)
                            .foregroundColor(.blue)
                    }
                }
                .padding(.top, 5)
                
                Spacer()
            }
            .padding()
            .navigationBarHidden(true)
        }
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