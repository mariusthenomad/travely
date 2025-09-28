# Authentifizierung & Login-System - Travely

## 🔐 Übersicht
Implementierung eines umfassenden Authentifizierungssystems mit mehreren Login-Optionen für optimale User Experience.

---

## 🎯 Login-Optionen

### 📧 E-Mail Login (Priorität: Hoch)
**Features:**
- [ ] E-Mail Registrierung
- [ ] E-Mail Login
- [ ] Password Reset
- [ ] E-Mail Verification

**Implementierung:**
```swift
// E-Mail Authentication
struct EmailAuthView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isSignUp = false
    
    var body: some View {
        VStack(spacing: 16) {
            TextField("E-Mail", text: $email)
                .textFieldStyle(FlatTextFieldStyle())
            
            SecureField("Passwort", text: $password)
                .textFieldStyle(FlatTextFieldStyle())
            
            PrimaryButton(
                title: isSignUp ? "Registrieren" : "Anmelden",
                action: handleAuth
            )
        }
    }
}
```

### 🍎 Apple Login
**Features:**
- [ ] Apple Sign-In Integration
- [ ] Privacy-konforme Anmeldung
- [ ] Seamless User Experience

**Setup:**
```swift
// Apple Sign-In
import AuthenticationServices

struct AppleSignInButton: View {
    var body: some View {
        SignInWithAppleButton(
            onRequest: { request in
                request.requestedScopes = [.fullName, .email]
            },
            onCompletion: { result in
                // Handle result
            }
        )
        .signInWithAppleButtonStyle(.black)
        .frame(height: 50)
    }
}
```

### 🔍 Google Login
**Features:**
- [ ] Google Sign-In Integration
- [ ] OAuth 2.0 Flow
- [ ] Profile Information Sync

**Setup:**
```swift
// Google Sign-In
import GoogleSignIn

struct GoogleSignInButton: View {
    var body: some View {
        Button(action: signInWithGoogle) {
            HStack {
                Image("google_logo")
                Text("Mit Google anmelden")
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.white)
            .foregroundColor(.black)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )
        }
    }
}
```

---

## 🚀 Onboarding Flow

### 👋 Welcome Screen
```swift
struct WelcomeView: View {
    var body: some View {
        VStack(spacing: 32) {
            // App Logo & Branding
            Image("travely_logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 120)
            
            VStack(spacing: 16) {
                Text("Willkommen bei Travely")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Entdecke die Welt mit deinem persönlichen Reiseassistenten")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            VStack(spacing: 16) {
                PrimaryButton(title: "Jetzt starten", action: showAuthOptions)
                SecondaryButton(title: "Demo erkunden", action: showDemo)
            }
        }
        .padding(.paddingXL)
    }
}
```

### 🔐 Authentication Selection
```swift
struct AuthSelectionView: View {
    var body: some View {
        VStack(spacing: 24) {
            Text("Anmeldung")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            VStack(spacing: 16) {
                AppleSignInButton()
                GoogleSignInButton()
                
                Divider()
                    .padding(.horizontal)
                
                Button("Mit E-Mail anmelden") {
                    showEmailAuth = true
                }
                .buttonStyle(FlatButtonStyle())
            }
            
            Button("Als Gast fortfahren") {
                continueAsGuest()
            }
            .foregroundColor(.secondary)
        }
        .padding(.paddingXL)
    }
}
```

### 💰 Subscription Selection
```swift
struct SubscriptionSelectionView: View {
    var body: some View {
        VStack(spacing: 32) {
            Text("Wähle deinen Plan")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            VStack(spacing: 16) {
                // Free Plan Card
                SubscriptionCard(
                    title: "Travely Free",
                    price: "Kostenlos",
                    features: [
                        "5 Routen speichern",
                        "Basis-Suche",
                        "Community Features"
                    ],
                    isSelected: selectedPlan == .free,
                    action: { selectedPlan = .free }
                )
                
                // Premium Plan Card
                SubscriptionCard(
                    title: "Travely Pro",
                    price: "9,99€ / Monat",
                    features: [
                        "Unbegrenzte Routen",
                        "Erweiterte Suche",
                        "Offline-Karten",
                        "Premium Support"
                    ],
                    isSelected: selectedPlan == .pro,
                    action: { selectedPlan = .pro }
                )
            }
            
            PrimaryButton(
                title: "Plan auswählen",
                action: processSubscription
            )
        }
        .padding(.paddingXL)
    }
}
```

---

## 🔄 User Flow

### 📊 Flow Diagramm
```
Welcome Screen
    ↓
Authentication Selection
    ↓
[Apple] [Google] [Email] [Guest]
    ↓
Email Auth (falls gewählt)
    ↓
Subscription Selection
    ↓
[Free] [Pro Monthly]
    ↓
Main App
```

### 🎯 User Journey
1. **App Launch** → Welcome Screen
2. **Authentication** → Login-Option wählen
3. **Account Creation** → Profil einrichten
4. **Subscription** → Plan auswählen
5. **Onboarding** → App-Features erklären
6. **Main App** → Vollzugriff

---

## 🛠️ Implementation Details

### 🔧 Authentication Manager
```swift
class AuthManager: ObservableObject {
    @Published var isAuthenticated = false
    @Published var currentUser: User?
    @Published var authState: AuthState = .loading
    
    enum AuthState {
        case loading
        case unauthenticated
        case authenticated
        case error(String)
    }
    
    func signInWithEmail(email: String, password: String) async {
        // E-Mail Login Logic
    }
    
    func signInWithApple() async {
        // Apple Sign-In Logic
    }
    
    func signInWithGoogle() async {
        // Google Sign-In Logic
    }
    
    func signOut() async {
        // Sign Out Logic
    }
}
```

### 👤 User Model
```swift
struct User: Codable, Identifiable {
    let id: String
    let email: String?
    let displayName: String
    let profileImageURL: String?
    let subscriptionPlan: SubscriptionPlan
    let createdAt: Date
    
    enum SubscriptionPlan: String, CaseIterable {
        case free = "free"
        case pro = "pro"
    }
}
```

---

## ⚙️ Settings Integration

### 🔄 Subscription Management
```swift
struct SubscriptionSettingsView: View {
    @StateObject private var subscriptionManager = SubscriptionManager()
    
    var body: some View {
        List {
            Section("Aktueller Plan") {
                HStack {
                    Text(subscriptionManager.currentPlan.title)
                    Spacer()
                    Text(subscriptionManager.currentPlan.price)
                        .foregroundColor(.secondary)
                }
            }
            
            Section("Verwaltung") {
                Button("Kauf wiederherstellen") {
                    subscriptionManager.restorePurchases()
                }
                
                Button("Plan verwalten") {
                    subscriptionManager.openSubscriptionManagement()
                }
            }
        }
        .navigationTitle("Abonnement")
    }
}
```

---

## 🔒 Security Considerations

### 🛡️ Best Practices
- [ ] **Password Hashing**: bcrypt oder ähnlich
- [ ] **JWT Tokens**: Sichere Token-Verwaltung
- [ ] **OAuth 2.0**: Standard-konforme Implementation
- [ ] **Data Encryption**: Sensible Daten verschlüsseln
- [ ] **Rate Limiting**: Login-Versuche begrenzen

### 📱 iOS Security
- [ ] **Keychain**: Sichere Speicherung von Credentials
- [ ] **Biometric Auth**: Face ID/Touch ID Support
- [ ] **App Transport Security**: HTTPS nur
- [ ] **Certificate Pinning**: API-Sicherheit

---

## 📋 Implementation Checklist

### 🔐 Authentication
- [ ] E-Mail Login/Registrierung
- [ ] Apple Sign-In Integration
- [ ] Google Sign-In Integration
- [ ] Guest Mode
- [ ] Password Reset
- [ ] Account Verification

### 💰 Subscription
- [ ] Free vs Pro Plan Selection
- [ ] App Store Integration
- [ ] Purchase Restoration
- [ ] Subscription Management
- [ ] Feature Gating

### 🎨 UI/UX
- [ ] Onboarding Flow
- [ ] Authentication Screens
- [ ] Settings Integration
- [ ] Error Handling
- [ ] Loading States

---

*Authentifizierung & Login-System - Travely iOS App*
