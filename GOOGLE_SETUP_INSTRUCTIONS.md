# Google Login Setup für Travely App

## Schritt 1: Google Cloud Console konfigurieren

### 1.1 Neues Projekt erstellen
1. Gehe zu [Google Cloud Console](https://console.cloud.google.com/)
2. Erstelle ein neues Projekt: "Travely" oder wähle ein bestehendes

### 1.2 Google Sign-In API aktivieren
1. Gehe zu **APIs & Services → Library**
2. Suche nach "Google Sign-In API"
3. Klicke auf "Enable"

### 1.3 OAuth 2.0 Client ID erstellen
1. Gehe zu **APIs & Services → Credentials**
2. Klicke **"+ CREATE CREDENTIALS" → "OAuth 2.0 Client ID"**
3. Wähle **"Web application"** als Application type
4. **Name**: "Travely Web Client"
5. **Authorized redirect URIs**: 
   ```
   https://mlnrhqbnphspbqcpzwez.supabase.co/auth/v1/callback
   ```
6. Klicke **"Create"**
7. **Kopiere die Client ID und Client Secret** (du brauchst sie für Supabase)

### 1.4 iOS Client ID erstellen
1. Klicke erneut **"+ CREATE CREDENTIALS" → "OAuth 2.0 Client ID"**
2. Wähle **"iOS"** als Application type
3. **Name**: "Travely iOS"
4. **Bundle ID**: `com.mariusthenomad.travely`
5. Klicke **"Create"**
6. **Kopiere die Client ID** (du brauchst sie für die GoogleService-Info.plist)

## Schritt 2: Supabase konfigurieren

### 2.1 Google Provider aktivieren
1. Gehe zu deinem [Supabase Dashboard](https://supabase.com/dashboard)
2. Wähle dein Travely Projekt
3. Gehe zu **Authentication → Providers**
4. Aktiviere **Google**
5. **Client ID**: (aus Schritt 1.3 - Web Client ID)
6. **Client Secret**: (aus Schritt 1.3 - Web Client Secret)
7. Klicke **"Save"**

## Schritt 3: iOS App konfigurieren

### 3.1 GoogleService-Info.plist aktualisieren
1. Öffne `Travely/GoogleService-Info.plist`
2. Ersetze `YOUR_GOOGLE_CLIENT_ID_HERE` mit deiner iOS Client ID (aus Schritt 1.4)
3. Ersetze `YOUR_CLIENT_ID` in `REVERSED_CLIENT_ID` mit deiner iOS Client ID

### 3.2 URL Schemes hinzufügen
1. Öffne dein Xcode Projekt
2. Wähle dein Target → **Info** Tab
3. Erweitere **"URL Types"**
4. Füge einen neuen URL Type hinzu:
   - **Identifier**: `GoogleSignIn`
   - **URL Schemes**: (deine REVERSED_CLIENT_ID aus GoogleService-Info.plist)

### 3.3 Google Sign-In SDK hinzufügen
1. **File → Add Package Dependencies**
2. **URL**: `https://github.com/google/GoogleSignIn-iOS`
3. **Add to Target**: Travely

### 3.4 AppDelegate konfigurieren
Füge in deiner `TravelyApp.swift` die Google Sign-In Konfiguration hinzu:

```swift
import SwiftUI
import GoogleSignIn

@main
struct TravelyApp: App {
    @StateObject private var themeManager = ThemeManager()
    @StateObject private var supabaseManager = SupabaseManager.shared
    
    init() {
        // Configure Google Sign-In
        guard let path = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist"),
              let plist = NSDictionary(contentsOfFile: path),
              let clientId = plist["CLIENT_ID"] as? String else {
            fatalError("GoogleService-Info.plist not found or CLIENT_ID missing")
        }
        
        GIDSignIn.sharedInstance.configuration = GIDConfiguration(clientID: clientId)
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
        }
    }
}
```

## Schritt 4: Testen

1. **Build und Run** deine App
2. Klicke auf **"Continue with Google"**
3. Du solltest zur Google Anmeldung weitergeleitet werden
4. Nach erfolgreicher Anmeldung wirst du zur Hauptapp weitergeleitet

## Fehlerbehebung

### Häufige Probleme:
1. **"Could not find root view controller"**
   - Stelle sicher, dass die App vollständig geladen ist
   
2. **"No ID token received from Google"**
   - Überprüfe deine Google Cloud Console Konfiguration
   - Stelle sicher, dass die Bundle ID korrekt ist
   
3. **Supabase Authentication Fehler**
   - Überprüfe deine Supabase Google Provider Konfiguration
   - Stelle sicher, dass die Redirect URI korrekt ist

### Debugging:
- Aktiviere Console Logging in Xcode
- Überprüfe die Supabase Auth Logs im Dashboard
- Teste mit einem anderen Google Account

## Fertig! 🎉

Deine Travely App hat jetzt:
- ✅ Google Login Integration
- ✅ Supabase Authentication
- ✅ Funktionsfähiges Login/Logout
- ✅ Schöne UI mit Google Sign-In Button
