# Sub-Task Details & Arbeitsanweisungen - Travely

## 📋 Übersicht
Detaillierte Arbeitsanweisungen für alle Sub-Tasks zur effizienten Umsetzung der Travely iOS App Features.

---

## 🔧 Backend Entwicklung

### 🚀 Backend: User Authentication API
**Priorität:** Hoch | **Geschätzte Zeit:** 3-4 Tage

**Aufgaben:**
1. **JWT Token System implementieren**
   - JWT Secret konfigurieren
   - Token Generation/Validation
   - Refresh Token Logic

2. **Registration Endpoint**
   - `POST /api/auth/register`
   - Email/Password Validation
   - Password Hashing (bcrypt)
   - Email Verification System

3. **Login Endpoint**
   - `POST /api/auth/login`
   - Credential Validation
   - JWT Token Response
   - Error Handling

4. **Password Reset**
   - `POST /api/auth/forgot-password`
   - `POST /api/auth/reset-password`
   - Email Token System

**Technische Details:**
```javascript
// Beispiel JWT Implementation
const jwt = require('jsonwebtoken');
const bcrypt = require('bcrypt');

// Registration
app.post('/api/auth/register', async (req, res) => {
  const { email, password } = req.body;
  const hashedPassword = await bcrypt.hash(password, 10);
  // User creation logic
});

// Login
app.post('/api/auth/login', async (req, res) => {
  const { email, password } = req.body;
  // Validation and token generation
});
```

---

### 👤 Backend: User Management API
**Priorität:** Mittel | **Geschätzte Zeit:** 2-3 Tage

**Aufgaben:**
1. **Profile Management**
   - `GET /api/user/profile`
   - `PUT /api/user/profile`
   - Profile Image Upload

2. **Settings Management**
   - `GET /api/user/settings`
   - `PUT /api/user/settings`
   - Preferences Storage

3. **User Preferences**
   - Language Settings
   - Notification Preferences
   - Privacy Settings

---

### 🗺️ Backend: Travel Features API
**Priorität:** Mittel | **Geschätzte Zeit:** 4-5 Tage

**Aufgaben:**
1. **Route Management**
   - `POST /api/routes` - Route speichern
   - `GET /api/routes` - User Routes abrufen
   - `PUT /api/routes/:id` - Route bearbeiten
   - `DELETE /api/routes/:id` - Route löschen

2. **Favorites System**
   - `POST /api/favorites` - Destination favorisieren
   - `GET /api/favorites` - Favorites abrufen
   - `DELETE /api/favorites/:id` - Favorite entfernen

3. **Travel History**
   - Route History Tracking
   - Search History
   - Activity Logging

---

### 💰 Backend: Subscription Management API
**Priorität:** Niedrig | **Geschätzte Zeit:** 2-3 Tage

**Aufgaben:**
1. **Subscription Status**
   - `GET /api/subscription/status`
   - Plan Verification
   - Feature Access Control

2. **Payment Integration**
   - App Store Receipt Validation
   - Subscription Renewal Handling
   - Cancellation Management

---

## 🔐 Authentifizierung iOS

### 🍎 Apple Login: SDK Integration
**Priorität:** Hoch | **Geschätzte Zeit:** 1-2 Tage

**Aufgaben:**
1. **Xcode Setup**
   - Sign In with Apple Capability hinzufügen
   - Entitlements konfigurieren
   - Info.plist Updates

2. **AuthenticationServices Framework**
   - Import und Setup
   - ASAuthorizationController Delegate
   - Error Handling

**Code Template:**
```swift
import AuthenticationServices

class AppleSignInManager: NSObject, ASAuthorizationControllerDelegate {
    func signInWithApple() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.performRequests()
    }
}
```

---

### 🔍 Google Login: SDK Integration
**Priorität:** Hoch | **Geschätzte Zeit:** 1-2 Tage

**Aufgaben:**
1. **GoogleService-Info.plist**
   - Datei bereits vorhanden ✓
   - Configuration überprüfen
   - Client ID validieren

2. **GoogleSignIn Framework**
   - Pod/Swift Package hinzufügen
   - Configuration in AppDelegate
   - Sign-In Flow implementieren

**Code Template:**
```swift
import GoogleSignIn

class GoogleSignInManager: ObservableObject {
    func signIn() {
        guard let presentingViewController = UIApplication.shared.windows.first?.rootViewController else {
            return
        }
        
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController) { result, error in
            // Handle result
        }
    }
}
```

---

### 📧 E-Mail Login: Implementation
**Priorität:** Hoch | **Geschätzte Zeit:** 2-3 Tage

**Aufgaben:**
1. **Registration Screen**
   - Email/Password Input
   - Validation Logic
   - API Integration

2. **Login Screen**
   - Credential Input
   - Remember Me Option
   - Error Handling

3. **Password Reset**
   - Forgot Password Flow
   - Email Verification
   - Reset Token Handling

**UI Components:**
```swift
struct EmailAuthView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isSignUp = false
    
    var body: some View {
        VStack(spacing: 20) {
            TextField("E-Mail", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
            
            SecureField("Passwort", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button(isSignUp ? "Registrieren" : "Anmelden") {
                handleAuth()
            }
            .buttonStyle(PrimaryButtonStyle())
        }
        .padding()
    }
}
```

---

## 🚀 Onboarding-Flow

### 👋 Welcome Screen
**Priorität:** Mittel | **Geschätzte Zeit:** 1 Tag

**Aufgaben:**
1. **UI Design**
   - App Logo Integration
   - Welcome Text
   - Call-to-Action Buttons

2. **Navigation**
   - Flow Management
   - State Persistence
   - Skip Option

---

### 🔐 Authentication Selection Screen
**Priorität:** Hoch | **Geschätzte Zeit:** 1-2 Tage

**Aufgaben:**
1. **Login Options**
   - Apple Sign-In Button
   - Google Sign-In Button
   - Email Login Button
   - Guest Mode Option

2. **UI Layout**
   - Vertikale Button-Anordnung
   - Spacing und Alignment
   - Visual Hierarchy

---

### 💰 Subscription Selection Screen
**Priorität:** Mittel | **Geschätzte Zeit:** 2 Tage

**Aufgaben:**
1. **Plan Cards**
   - Free Plan Card
   - Pro Plan Card
   - Feature Comparison
   - Pricing Display

2. **App Store Integration**
   - In-App Purchase Setup
   - Product Configuration
   - Purchase Flow

---

## ⚙️ Einstellungen

### 💰 Subscription Management
**Priorität:** Niedrig | **Geschätzte Zeit:** 1-2 Tage

**Aufgaben:**
1. **Settings Section**
   - Current Plan Display
   - Subscription Status
   - Renewal Information

2. **Management Actions**
   - Restore Purchases Button
   - Manage Subscription Link
   - Upgrade/Downgrade Options

**Implementation:**
```swift
struct SubscriptionSettingsView: View {
    @StateObject private var subscriptionManager = SubscriptionManager()
    
    var body: some View {
        Section("Abonnement") {
            HStack {
                Text("Aktueller Plan")
                Spacer()
                Text(subscriptionManager.currentPlan.title)
                    .foregroundColor(.secondary)
            }
            
            Button("Kauf wiederherstellen") {
                subscriptionManager.restorePurchases()
            }
        }
    }
}
```

---

## 🎨 UI/UX Design

### 🏠 Home Tab: Flaches Design
**Priorität:** Hoch | **Geschätzte Zeit:** 1-2 Tage

**Aufgaben:**
1. **Card Redesign**
   - Schatten reduzieren (shadowOpacity: 0.05)
   - Border hinzufügen (borderWidth: 1)
   - Corner Radius optimieren (12pt)

2. **Button Styles**
   - Schatten entfernen
   - Flache Gestaltung
   - Konsistente Spacing

**Design System:**
```swift
struct FlatCard: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(.systemGray5), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}
```

---

### 🔄 Routes: Swipe-Gesten Update
**Priorität:** Hoch | **Geschätzte Zeit:** 1-2 Tage

**Aufgaben:**
1. **Links-Swipe Actions**
   - Edit Button hinzufügen
   - Delete Button beibehalten
   - Action Layout optimieren

2. **Rechts-Swipe entfernen**
   - Aktuelle Edit-Funktion entfernen
   - Gesture Handler anpassen

**Implementation:**
```swift
struct RouteRowView: View {
    var body: some View {
        HStack {
            // Route Content
        }
        .swipeActions(edge: .leading, allowsFullSwipe: false) {
            Button("Bearbeiten") {
                editRoute()
            }
            .tint(.blue)
            
            Button("Löschen") {
                deleteRoute()
            }
            .tint(.red)
        }
    }
}
```

---

## 📊 Prioritäten & Timeline

### 🔥 Sofort (Diese Woche)
1. Apple/Google Login SDK Setup
2. E-Mail Login Implementation
3. UI Design Updates (Home, Routes)
4. Swipe-Gesten in Routes

### 🟡 Nächste Woche
1. Onboarding Flow
2. Backend Authentication API
3. Subscription Management
4. Destination Tab Design

### 🟢 Später
1. Backend Travel Features
2. Advanced UI Components
3. Performance Optimizations
4. Testing & Bug Fixes

---

## 🛠️ Development Guidelines

### 📱 iOS Best Practices
- **SwiftUI**: Moderne UI-Framework nutzen
- **Combine**: Reactive Programming für State Management
- **MVVM**: Architektur-Pattern befolgen
- **Accessibility**: VoiceOver und Dynamic Type Support

### 🔧 Code Standards
- **Naming**: Descriptive Variable/Function Names
- **Comments**: Wichtige Logik dokumentieren
- **Error Handling**: Comprehensive Error Management
- **Testing**: Unit Tests für kritische Funktionen

---

*Sub-Task Details & Arbeitsanweisungen - Travely iOS App*
