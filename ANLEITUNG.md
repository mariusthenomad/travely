# 🚀 Travely - iOS Travel App

Eine moderne iOS Travel App mit **Supabase Backend** und **Google Sign-In** Integration.

## ✨ Features

### 🔐 **Authentication System**
- **Email/Password Login** - Voll funktionsfähig mit Supabase
- **Google Sign-In** - Temporär deaktiviert (URL Scheme Fix in Arbeit)
- **Skip Login** - Für schnelles Testen ohne Anmeldung
- **Supabase Integration** - Echte Datenbank-Verbindung

### 🎨 **UI/UX Features**
- **Dark/Light Mode** - Automatischer Theme-Switch
- **Modern Design** - SwiftUI mit aktuellen iOS Design Patterns
- **Responsive Layout** - Optimiert für alle iPhone Größen
- **Loading States** - Smooth Loading-Indikatoren

### 🏨 **Travel Features**
- **Flight Search** - Flugsuche mit verschiedenen Parametern
- **Hotel Details** - Detaillierte Hotel-Informationen
- **Destination Browser** - Zielort-Übersicht mit Grid-Layout
- **Profile Management** - Benutzerprofil und Einstellungen

## 🛠 Installation & Setup

### Schritt 1: Xcode öffnen
1. Öffne Xcode auf deinem Mac
2. Wähle "Open a project or file" oder drücke `Cmd + O`

### Schritt 2: Projekt öffnen
1. Navigiere zu dem Ordner: `/Users/marius/Documents/Corsor/Travely`
2. Wähle die Datei `Travely.xcodeproj` aus
3. Klicke auf "Open"

### Schritt 3: Simulator auswählen
1. In Xcode, oben links neben dem Play-Button, wähle einen iOS Simulator aus
2. Empfohlene Optionen:
   - **iPhone 17** (iOS 18.0) - Empfohlen
   - iPhone 15 Pro (iOS 17.0)
   - iPhone 14 Pro (iOS 16.0)

### Schritt 4: App starten
1. Klicke auf den Play-Button (▶️) oder drücke `Cmd + R`
2. Xcode wird die App kompilieren und im Simulator starten

## 🎯 App testen
Die Travely App wird im Simulator geöffnet und du kannst:

### 🔐 **Authentication testen:**
- **Email/Password Login** - Erstelle einen Account oder logge dich ein
- **Skip Login** - Für schnelles Testen ohne Anmeldung
- **Test Supabase Connection** - Teste die Datenbank-Verbindung

### 🧭 **Navigation testen:**
- **Home Tab**: Übersicht mit Quick Actions
- **Flights Tab**: Flugsuche mit Suchformular
- **Destinations Tab**: Zielort-Browser mit Grid-Layout
- **Profile Tab**: Benutzerprofil und Einstellungen

### ✈️ **Travel Features ausprobieren:**
- Flugsuche mit verschiedenen Parametern
- Hotel-Details ansehen
- Zielorte durchsuchen und filtern
- Profil bearbeiten
- App-Einstellungen anpassen
- Dark/Light Mode wechseln

## 🔧 Troubleshooting

### Falls die App nicht startet:
1. **Build-Fehler**: Drücke `Cmd + Shift + K` um zu cleanen, dann `Cmd + R` zum neu kompilieren
2. **Simulator-Probleme**: Wähle einen anderen Simulator aus
3. **iOS Version**: Stelle sicher, dass der Simulator iOS 15.0+ verwendet
4. **Supabase Verbindung**: Prüfe Internetverbindung für Datenbank-Zugriff

### 🔐 **Authentication Probleme:**
- **Email/Password Login funktioniert nicht**: Prüfe Internetverbindung
- **Google Sign-In deaktiviert**: Temporär deaktiviert, verwende Email/Password
- **Skip Login**: Funktioniert immer für schnelles Testen

### 🖼 **Falls Bilder nicht laden:**
- Die App verwendet Unsplash-Bilder über das Internet
- Stelle sicher, dass der Simulator Internetverbindung hat
- Bilder werden asynchron geladen (kann einen Moment dauern)

### 🎨 **Theme Probleme:**
- **Dark/Light Mode**: Funktioniert automatisch basierend auf System-Einstellungen
- **Farben**: Alle Farben sind in `Assets.xcassets` definiert

## 📁 Projekt-Struktur
```
Travely/
├── Travely.xcodeproj                    # Xcode Projektdatei
├── Travely/                             # Hauptordner
│   ├── TravelyApp.swift                 # App-Einstiegspunkt + Authentication
│   ├── ContentView.swift                # Tab-Navigation
│   ├── HomeView.swift                   # Startseite
│   ├── FlightSearchView.swift           # Flugsuche
│   ├── HotelDetailView.swift            # Hotel-Details
│   ├── DestinationSelectionView.swift   # Zielorte
│   ├── ProfileSettingsView.swift        # Profil
│   ├── AppSettingsView.swift            # Einstellungen
│   ├── ThemeManager.swift               # Dark/Light Mode Management
│   ├── Assets.xcassets/                 # App-Icons und Farben
│   │   ├── AppIcon.appiconset/          # App-Icons
│   │   ├── AccentColor.colorset/        # Akzent-Farben
│   │   └── profile.imageset/            # Profil-Bilder
│   ├── GoogleService-Info.plist         # Google Sign-In Konfiguration
│   └── Info.plist                       # App-Konfiguration
├── database_schema.sql                  # Supabase Datenbank-Schema
├── GOOGLE_SETUP_INSTRUCTIONS.md         # Google Sign-In Setup
└── README.md                            # Projekt-Dokumentation
```

## 🛠 **Technologie-Stack**
- **Frontend**: SwiftUI (iOS 15.0+)
- **Backend**: Supabase (PostgreSQL, Auth, Storage)
- **Authentication**: Supabase Auth + Google Sign-In
- **State Management**: @StateObject, @EnvironmentObject
- **Networking**: URLSession + Supabase Swift SDK
- **UI Framework**: SwiftUI mit modernen Design Patterns

## ⌨️ **Nützliche Tastenkürzel in Xcode:**
- `Cmd + R`: App starten
- `Cmd + Shift + K`: Projekt cleanen
- `Cmd + .`: App stoppen
- `Cmd + Shift + O`: Datei schnell öffnen
- `Cmd + 1-9`: Verschiedene Panels öffnen
- `Cmd + Shift + A`: Simulator zurücksetzen

## 🎨 **Design System**
- **Primary Color**: Blau (#007AFF)
- **Secondary Color**: Grau (#8E8E93)
- **Accent Color**: Orange (#FF9500)
- **Background**: System Background (Dark/Light)
- **Text**: System Label (Dark/Light)

## 🚀 **Nächste Schritte**
1. **Google Sign-In aktivieren** - URL Scheme Problem lösen
2. **Datenbank erweitern** - Weitere Travel-Features hinzufügen
3. **Push Notifications** - Benachrichtigungen für Flüge
4. **Offline Support** - Lokale Daten-Speicherung

---

**Viel Spaß beim Testen der Travely App!** 🚀✈️🏨

*Entwickelt mit ❤️ in SwiftUI + Supabase*
