# Google Sign-In Keys bekommen

## 1. Gehe zur Google Cloud Console
- URL: https://console.cloud.google.com/
- Logge dich mit deinem Google Account ein

## 2. Wähle oder erstelle ein Projekt
- Falls noch kein Projekt: **"New Project"** erstellen
- Name: "PathFinder" oder ähnlich

## 3. Aktiviere Google Sign-In API
- **APIs & Services** → **Library**
- Suche nach "Google Sign-In API"
- Klicke **"Enable"**

## 4. Erstelle OAuth 2.0 Credentials
- **APIs & Services** → **Credentials**
- Klicke **"+ CREATE CREDENTIALS"**
- Wähle **"OAuth 2.0 Client ID"**

## 5. Konfiguriere iOS Client
- **Application type:** iOS
- **Name:** "PathFinder iOS"
- **Bundle ID:** `com.pathfinder.app` (oder deine Bundle ID)

## 6. Kopiere die Client ID
Du bekommst eine Client ID wie:
```
1033990407187-mffia1va0it83u51clbvmi40ol0adi3l.apps.googleusercontent.com
```

## 7. Konfiguriere für Supabase (falls nötig)
Falls du Google Sign-In mit Supabase verwenden willst:

### Web Client erstellen:
- **Application type:** Web application
- **Name:** "PathFinder Web"
- **Authorized redirect URIs:** 
  ```
  https://mlnrhqbnphspbqcpzwez.supabase.co/auth/v1/callback
  ```

## 8. Verwendung in deiner App
```swift
let clientId = "1033990407187-mffia1va0it83u51clbvmi40ol0adi3l.apps.googleusercontent.com"

GIDSignIn.sharedInstance.configuration = GIDConfiguration(
    clientID: clientId,
    serverClientID: nil,
    hostedDomain: nil,
    openIDRealm: nil
)
```

## 9. Info.plist konfigurieren
Füge die URL Schemes hinzu:
```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLName</key>
        <string>GoogleSignIn</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>com.googleusercontent.apps.1033990407187-mffia1va0it83u51clbvmi40ol0adi3l</string>
        </array>
    </dict>
</array>
```

## ⚠️ Wichtige Hinweise:
- Die Client ID ist öffentlich und sicher
- URL Scheme = Client ID ohne ".apps.googleusercontent.com"
- Bundle ID muss exakt übereinstimmen
