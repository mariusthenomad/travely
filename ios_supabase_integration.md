# iOS Supabase Integration Guide

## Overview
This guide explains how to integrate Supabase authentication with automatic profile creation in your iOS app.

## Backend Setup (Already Done)
The `supabase_setup.sql` file contains all the necessary SQL code to:
- Create a `profiles` table
- Set up Row Level Security (RLS)
- Create a trigger that automatically creates a profile row when a user signs up
- Set up proper permissions and indexes

## iOS Implementation

### 1. Update Supabase Client Configuration

First, update your `SupabaseAuthManager` in `ContentView.swift`:

```swift
import Supabase

class SupabaseAuthManager: ObservableObject {
    private let supabase: SupabaseClient
    
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isSignedUp = false
    @Published var currentUser: User?
    @Published var userProfile: Profile?
    
    init() {
        // Replace with your actual Supabase project URL and anon key
        supabase = SupabaseClient(
            supabaseURL: URL(string: "https://your-project.supabase.co")!,
            supabaseKey: "your-anon-key"
        )
    }
    
    // MARK: - Sign Up with Email/Password
    @MainActor
    func signUp(email: String, password: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let response = try await supabase.auth.signUp(
                email: email,
                password: password
            )
            
            if let user = response.user {
                currentUser = user
                isSignedUp = true
                
                // Wait a moment for the trigger to create the profile
                try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
                
                // Verify profile was created
                await verifyProfileCreated(userId: user.id)
            }
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    // MARK: - Verify Profile Creation
    @MainActor
    private func verifyProfileCreated(userId: UUID) async {
        do {
            let profile: Profile = try await supabase.database
                .from("profiles")
                .select()
                .eq("id", value: userId)
                .single()
                .execute()
                .value
            
            userProfile = profile
            print("✅ Profile verified for user: \(profile.email)")
        } catch {
            print("❌ Failed to verify profile: \(error)")
            errorMessage = "Profile verification failed"
        }
    }
    
    // MARK: - Get User Profile
    @MainActor
    func fetchUserProfile() async {
        guard let userId = currentUser?.id else { return }
        
        do {
            let profile: Profile = try await supabase.database
                .from("profiles")
                .select()
                .eq("id", value: userId)
                .single()
                .execute()
                .value
            
            userProfile = profile
        } catch {
            print("❌ Failed to fetch profile: \(error)")
            errorMessage = "Failed to fetch profile"
        }
    }
    
    // MARK: - Update Profile
    @MainActor
    func updateProfile(_ profile: Profile) async {
        guard let userId = currentUser?.id else { return }
        
        do {
            let updatedProfile: Profile = try await supabase.database
                .from("profiles")
                .update(profile)
                .eq("id", value: userId)
                .select()
                .single()
                .execute()
                .value
            
            userProfile = updatedProfile
        } catch {
            print("❌ Failed to update profile: \(error)")
            errorMessage = "Failed to update profile"
        }
    }
    
    // MARK: - Sign Out
    @MainActor
    func signOut() async {
        do {
            try await supabase.auth.signOut()
            currentUser = nil
            userProfile = nil
            isSignedUp = false
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
```

### 2. Update Profile Model

Add this to your `ContentView.swift`:

```swift
// MARK: - Profile Model
struct Profile: Codable, Identifiable {
    let id: UUID
    let email: String
    let createdAt: Date
    let updatedAt: Date
    let firstName: String?
    let lastName: String?
    let avatarUrl: String?
    let bio: String?
    let phone: String?
    let dateOfBirth: Date?
    let country: String?
    let timezone: String
    let preferences: [String: AnyCodable]?
    let isActive: Bool
    let lastLogin: Date?
    
    enum CodingKeys: String, CodingKey {
        case id
        case email
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case firstName = "first_name"
        case lastName = "last_name"
        case avatarUrl = "avatar_url"
        case bio
        case phone
        case dateOfBirth = "date_of_birth"
        case country
        case timezone
        case preferences
        case isActive = "is_active"
        case lastLogin = "last_login"
    }
}

// Helper for JSON encoding/decoding
struct AnyCodable: Codable {
    let value: Any
    
    init(_ value: Any) {
        self.value = value
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let string = try? container.decode(String.self) {
            value = string
        } else if let int = try? container.decode(Int.self) {
            value = int
        } else if let double = try? container.decode(Double.self) {
            value = double
        } else if let bool = try? container.decode(Bool.self) {
            value = bool
        } else if let array = try? container.decode([AnyCodable].self) {
            value = array.map { $0.value }
        } else if let dict = try? container.decode([String: AnyCodable].self) {
            value = dict.mapValues { $0.value }
        } else {
            throw DecodingError.typeMismatch(AnyCodable.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Unsupported type"))
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        if let string = value as? String {
            try container.encode(string)
        } else if let int = value as? Int {
            try container.encode(int)
        } else if let double = value as? Double {
            try container.encode(double)
        } else if let bool = value as? Bool {
            try container.encode(bool)
        } else if let array = value as? [Any] {
            try container.encode(array.map { AnyCodable($0) })
        } else if let dict = value as? [String: Any] {
            try container.encode(dict.mapValues { AnyCodable($0) })
        } else {
            throw EncodingError.invalidValue(value, EncodingError.Context(codingPath: encoder.codingPath, debugDescription: "Unsupported type"))
        }
    }
}
```

### 3. Update Sign Up View

Update your `UltraLightSignUpView` to use the new auth manager:

```swift
struct UltraLightSignUpView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var authManager = SupabaseAuthManager()
    
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var firstName = ""
    @State private var lastName = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                UltraLightDesignSystem.background
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: UltraLightDesignSystem.spaceL) {
                        // Header
                        UltraLightWindow(
                            title: "Create Account",
                            subtitle: "Join PathFinder today",
                            style: .premium
                        ) {
                            EmptyView()
                        }
                        
                        // Form
                        UltraLightWindow(
                            title: "Account Details",
                            style: .standard
                        ) {
                            VStack(spacing: UltraLightDesignSystem.spaceL) {
                                // Email
                                VStack(alignment: .leading, spacing: UltraLightDesignSystem.spaceS) {
                                    Text("Email")
                                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                                        .foregroundColor(UltraLightDesignSystem.textSecondary)
                                    
                                    TextField("Enter your email", text: $email)
                                        .textFieldStyle(UltraLightTextFieldStyle())
                                        .keyboardType(.emailAddress)
                                        .autocapitalization(.none)
                                }
                                
                                // Password
                                VStack(alignment: .leading, spacing: UltraLightDesignSystem.spaceS) {
                                    Text("Password")
                                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                                        .foregroundColor(UltraLightDesignSystem.textSecondary)
                                    
                                    SecureField("Enter your password", text: $password)
                                        .textFieldStyle(UltraLightTextFieldStyle())
                                }
                                
                                // Confirm Password
                                VStack(alignment: .leading, spacing: UltraLightDesignSystem.spaceS) {
                                    Text("Confirm Password")
                                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                                        .foregroundColor(UltraLightDesignSystem.textSecondary)
                                    
                                    SecureField("Confirm your password", text: $confirmPassword)
                                        .textFieldStyle(UltraLightTextFieldStyle())
                                }
                                
                                // First Name
                                VStack(alignment: .leading, spacing: UltraLightDesignSystem.spaceS) {
                                    Text("First Name")
                                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                                        .foregroundColor(UltraLightDesignSystem.textSecondary)
                                    
                                    TextField("Enter your first name", text: $firstName)
                                        .textFieldStyle(UltraLightTextFieldStyle())
                                }
                                
                                // Last Name
                                VStack(alignment: .leading, spacing: UltraLightDesignSystem.spaceS) {
                                    Text("Last Name")
                                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                                        .foregroundColor(UltraLightDesignSystem.textSecondary)
                                    
                                    TextField("Enter your last name", text: $lastName)
                                        .textFieldStyle(UltraLightTextFieldStyle())
                                }
                            }
                        }
                        
                        // Error Message
                        if let errorMessage = authManager.errorMessage {
                            Text(errorMessage)
                                .font(.system(size: 14, weight: .medium, design: .rounded))
                                .foregroundColor(.red)
                                .padding()
                                .background(Color.red.opacity(0.1))
                                .cornerRadius(UltraLightDesignSystem.radiusM)
                        }
                        
                        // Success Message
                        if authManager.isSignedUp {
                            VStack(spacing: UltraLightDesignSystem.spaceS) {
                                Text("✅ Account Created Successfully!")
                                    .font(.system(size: 16, weight: .bold, design: .rounded))
                                    .foregroundColor(.green)
                                
                                if let profile = authManager.userProfile {
                                    Text("Profile verified for: \(profile.email)")
                                        .font(.system(size: 14, weight: .medium, design: .rounded))
                                        .foregroundColor(UltraLightDesignSystem.textSecondary)
                                }
                            }
                            .padding()
                            .background(Color.green.opacity(0.1))
                            .cornerRadius(UltraLightDesignSystem.radiusM)
                        }
                        
                        // Sign Up Button
                        Button(action: {
                            Task {
                                await authManager.signUp(email: email, password: password)
                            }
                        }) {
                            HStack {
                                if authManager.isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        .scaleEffect(0.8)
                                } else {
                                    Image(systemName: "person.badge.plus")
                                        .font(.system(size: 16, weight: .semibold))
                                }
                                
                                Text(authManager.isLoading ? "Creating Account..." : "Create Account")
                                    .font(.system(size: 16, weight: .bold, design: .rounded))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(UltraLightDesignSystem.spaceL)
                            .background(
                                LinearGradient(
                                    colors: [UltraLightDesignSystem.primaryOrange, UltraLightDesignSystem.primaryOrange.opacity(0.8)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(UltraLightDesignSystem.radiusL)
                            .shadow(color: UltraLightDesignSystem.primaryOrange.opacity(0.3), radius: 8, x: 0, y: 4)
                        }
                        .disabled(authManager.isLoading || email.isEmpty || password.isEmpty || password != confirmPassword)
                    }
                    .padding(UltraLightDesignSystem.spaceL)
                }
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
        }
    }
}

// Custom TextField Style
struct UltraLightTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(UltraLightDesignSystem.spaceM)
            .background(UltraLightDesignSystem.surface)
            .cornerRadius(UltraLightDesignSystem.radiusM)
            .foregroundColor(UltraLightDesignSystem.text)
    }
}
```

## How It Works

### 1. **Automatic Profile Creation**
When a user signs up via `supabase.auth.signUp()`:
1. Supabase creates a new row in `auth.users`
2. The PostgreSQL trigger `on_auth_user_created` fires automatically
3. The trigger function `handle_new_user()` inserts a corresponding row in `profiles`
4. The iOS app can immediately query the `profiles` table to verify the account exists

### 2. **Verification Process**
The iOS app verifies account creation by:
1. Calling `signUp()` which returns a `User` object
2. Waiting 1 second for the trigger to complete
3. Querying the `profiles` table with the user's ID
4. If successful, the profile is loaded and displayed

### 3. **Row Level Security**
- Users can only access their own profile data
- All database operations are secure and user-scoped
- No manual profile creation needed - it's automatic

## Testing the Integration

1. **Run the SQL setup** in your Supabase SQL editor
2. **Update your Supabase credentials** in the iOS app
3. **Test the signup flow** - you should see:
   - Account creation success message
   - Profile verification message
   - Automatic profile row creation in Supabase dashboard

## Benefits

✅ **Automatic**: No manual profile creation needed  
✅ **Secure**: RLS ensures users only access their own data  
✅ **Reliable**: Trigger ensures every user has a profile  
✅ **Scalable**: Works with any number of users  
✅ **Maintainable**: Clean separation between auth and profile data  

This setup ensures that every user who signs up will automatically have a corresponding profile row, making your app's user management robust and reliable.

