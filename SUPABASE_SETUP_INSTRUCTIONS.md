# 🚀 Supabase Integration Setup Instructions

## 📋 Overview
This guide will help you set up Supabase authentication in your PathFinder iOS app.

## 🔧 Prerequisites
- Supabase account and project
- iOS project with Supabase Swift SDK installed

## 📦 Installation

### 1. Add Supabase Swift SDK
Add this to your `Package.swift` or Xcode Package Manager:

```swift
dependencies: [
    .package(url: "https://github.com/supabase/supabase-swift", from: "2.0.0")
]
```

### 2. Configure Supabase Client
Update the `SupabaseAuthManager.swift` file with your project credentials:

```swift
init() {
    supabase = SupabaseClient(
        supabaseURL: URL(string: "YOUR_SUPABASE_URL")!,
        supabaseKey: "YOUR_SUPABASE_ANON_KEY"
    )
}
```

**Find your credentials:**
1. Go to your Supabase project dashboard
2. Navigate to Settings → API
3. Copy the Project URL and anon/public key

## 🗄️ Database Setup

### 1. Create Profiles Table
Run the SQL from `supabase_profiles_table.sql` in your Supabase SQL Editor:

```sql
-- Create profiles table
CREATE TABLE IF NOT EXISTS profiles (
    id UUID REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,
    email TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable Row Level Security
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

-- Create policies
CREATE POLICY "Users can view own profile" ON profiles
    FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can insert own profile" ON profiles
    FOR INSERT WITH CHECK (auth.uid() = id);

CREATE POLICY "Users can update own profile" ON profiles
    FOR UPDATE USING (auth.uid() = id);
```

### 2. Auto-Create Profile Trigger
Set up automatic profile creation when users sign up:

```sql
-- Function to create profile
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO public.profiles (id, email)
    VALUES (NEW.id, NEW.email);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger for new user creation
CREATE OR REPLACE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();
```

## 🎯 Usage

### 1. Basic Sign Up
```swift
@StateObject private var authManager = SupabaseAuthManager()

// In your button action:
Button("Sign Up") {
    Task {
        await authManager.signUpUser(
            email: "user@example.com",
            password: "password123"
        )
    }
}
```

### 2. Error Handling
```swift
// Check for errors
if let error = authManager.errorMessage {
    Text("Error: \(error)")
        .foregroundColor(.red)
}

// Check for success
if authManager.isSignedUp {
    Text("✅ Account created successfully!")
        .foregroundColor(.green)
}
```

### 3. Loading States
```swift
// Show loading indicator
if authManager.isLoading {
    ProgressView("Creating account...")
}
```

## 🔐 Security Features

### Row Level Security (RLS)
- Users can only access their own profile data
- Automatic policy enforcement
- Secure by default

### Input Validation
- Email format validation
- Password length requirements (minimum 6 characters)
- Real-time validation feedback

## 🎨 UI Integration

### Custom Styling
The `SignUpView` uses your existing `UltraLightDesignSystem`:

```swift
.background(UltraLightDesignSystem.primaryOrange)
.cornerRadius(UltraLightDesignSystem.radiusM)
```

### Error Alerts
```swift
.alert("Sign Up Error", isPresented: $showingAlert) {
    Button("OK") {
        authManager.clearError()
    }
} message: {
    Text(authManager.errorMessage ?? "Unknown error occurred")
}
```

## 🧪 Testing

### 1. Test User Creation
```swift
// Test with valid data
await authManager.signUpUser(
    email: "test@example.com",
    password: "testpassword123"
)
```

### 2. Test Error Handling
```swift
// Test with invalid email
await authManager.signUpUser(
    email: "invalid-email",
    password: "password123"
)
```

### 3. Test Database Integration
Check your Supabase dashboard to verify:
- User appears in `auth.users` table
- Profile appears in `profiles` table
- RLS policies are working correctly

## 🚨 Troubleshooting

### Common Issues

1. **"Cannot find SupabaseClient"**
   - Ensure Supabase Swift SDK is properly installed
   - Check import statements

2. **"Invalid URL"**
   - Verify your Supabase URL format
   - Ensure no trailing slashes

3. **"Database error"**
   - Check if profiles table exists
   - Verify RLS policies are set up
   - Check database permissions

4. **"User creation failed"**
   - Verify email format
   - Check password requirements
   - Ensure Supabase project is active

### Debug Tips
- Enable console logging in `SupabaseAuthManager`
- Check Supabase dashboard for error logs
- Use Supabase CLI for local development

## 📚 Additional Resources

- [Supabase Swift Documentation](https://supabase.com/docs/reference/swift)
- [Supabase Auth Guide](https://supabase.com/docs/guides/auth)
- [Row Level Security](https://supabase.com/docs/guides/auth/row-level-security)

## 🔄 Next Steps

1. **Email Verification**: Add email confirmation flow
2. **Password Reset**: Implement password reset functionality
3. **Social Auth**: Add Google/Apple sign-in
4. **User Profiles**: Extend profile data structure
5. **Offline Support**: Add offline authentication caching

---

**Happy coding! 🎉**

