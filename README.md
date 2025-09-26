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

### 🏠 **Home View**
- Welcome screen mit Quick Actions
- Featured destinations carousel
- Navigation hub mit Action Cards

### ✈️ **Flight Search**
- Comprehensive flight search mit origin/destination selection
- Date picker für departure und return dates
- Passenger count selection
- One-way und round-trip options
- Interactive flight cards mit booking options

### 🏨 **Hotel Management**
- Hotel listing mit detailed information
- Hotel detail view mit amenities, reviews, und booking options
- Image galleries und rating systems
- Booking date selection und guest count

### 🗺️ **Destination Selection**
- Grid-based destination browsing
- Search und filter functionality
- Category-based filtering (Europe, Asia, Americas, etc.)
- Destination detail pages mit booking options

### 👤 **Profile & Settings**
- User profile management mit editable information
- Travel preferences und booking history
- Comprehensive app settings
- Dark/Light Mode toggle

## Design System

### Typography
- **Font Family**: Inter
- **Primary Text Color**: #FF9500 (Orange)
- **Secondary Text Color**: Gray
- **Background**: White

### UI Components
- **Corner Radius**: 20px for cards and buttons
- **Shadows**: Light shadows for depth and elevation
- **Icons**: SF Symbols throughout the app
- **Color Scheme**: Orange (#FF9500) as primary, white background

### Navigation
- **Tab Bar**: Bottom navigation with 4 main sections
- **Navigation Links**: Seamless navigation between views
- **Modal Presentations**: Settings and detail views

## 🛠 **Technologie-Stack**
- **Frontend**: SwiftUI (iOS 15.0+)
- **Backend**: Supabase (PostgreSQL, Auth, Storage)
- **Authentication**: Supabase Auth + Google Sign-In
- **State Management**: @StateObject, @EnvironmentObject
- **Networking**: URLSession + Supabase Swift SDK
- **UI Framework**: SwiftUI mit modernen Design Patterns

## 📁 **Projekt-Struktur**
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

## 🔧 **Key Components**

### 🔐 **Authentication System**
- **Supabase Auth Client** - Echte Benutzer-Authentifizierung
- **Email/Password Login** - Voll funktionsfähig
- **Google Sign-In** - Temporär deaktiviert
- **Session Management** - Automatische Anmeldung

### 📊 **Data Models**
- **User**: Profile information und preferences
- **Flight**: Airline, timing, pricing, und route information
- **Hotel**: Name, location, amenities, ratings, und pricing
- **Destination**: Name, country, region, images, und pricing
- **Booking**: Travel bookings und history

### 🎯 **State Management**
- **@StateObject** und **@EnvironmentObject** für global state
- **@State** und **@Binding** für local state management
- **Form validation** und user input handling
- **Toggle states** für settings und preferences
- **Loading states** für async operations

### 🗄️ **Backend Integration**
- **Supabase Database** - PostgreSQL mit real-time updates
- **Supabase Storage** - File upload/download
- **Supabase Auth** - User management
- **Supabase Functions** - Serverless functions

## Features in Detail

### Flight Search
- Advanced search form with validation
- Dynamic flight results generation
- Price comparison and sorting
- Interactive booking flow

### Hotel Booking
- Detailed hotel information display
- Amenity icons and descriptions
- Review system with ratings
- Date selection and guest management

### Destination Exploration
- Visual destination cards with images
- Search and filter capabilities
- Regional categorization
- Booking integration

### User Experience
- Intuitive navigation patterns
- Consistent design language
- Responsive layouts
- Accessibility considerations

## Technical Implementation

### SwiftUI Features Used
- NavigationView and NavigationLink
- TabView for main navigation
- LazyVGrid for efficient list rendering
- AsyncImage for remote image loading
- Sheet presentations for modals
- Alert dialogs for confirmations

### Custom Components
- Reusable card components
- Custom toggle and selection rows
- Form input components
- Action buttons with consistent styling

## 🚀 **Getting Started**

### **Installation & Setup**
1. **Xcode öffnen** und Projekt laden
2. **iOS 15.0+** als deployment target sicherstellen
3. **Supabase Dependencies** sind bereits konfiguriert
4. **Build und Run** - `Cmd + R`
5. **App testen** mit Email/Password Login oder Skip Login

### **Authentication testen:**
- **Email/Password Login** - Erstelle einen Account oder logge dich ein
- **Skip Login** - Für schnelles Testen ohne Anmeldung
- **Test Supabase Connection** - Teste die Datenbank-Verbindung

## 📋 **Requirements**

- **iOS 15.0+**
- **Xcode 15.0+**
- **Swift 5.9+**
- **Internetverbindung** für Supabase

## 🔧 **Troubleshooting**

### **Falls die App nicht startet:**
1. **Build-Fehler**: `Cmd + Shift + K` um zu cleanen, dann `Cmd + R`
2. **Simulator-Probleme**: Anderen Simulator auswählen
3. **Supabase Verbindung**: Internetverbindung prüfen

### **Authentication Probleme:**
- **Email/Password Login funktioniert nicht**: Internetverbindung prüfen
- **Google Sign-In deaktiviert**: Temporär deaktiviert, verwende Email/Password
- **Skip Login**: Funktioniert immer für schnelles Testen

## 🚀 **Nächste Schritte**
1. **Google Sign-In aktivieren** - URL Scheme Problem lösen
2. **Datenbank erweitern** - Weitere Travel-Features hinzufügen
3. **Push Notifications** - Benachrichtigungen für Flüge
4. **Offline Support** - Lokale Daten-Speicherung
5. **Payment Integration** - Echte Zahlungsabwicklung
6. **Advanced Search** - Erweiterte Filter und Suche

## 🎨 **Design Philosophy**

Die App folgt modernen iOS Design-Prinzipien mit Fokus auf:
- **Simplicity**: Clean, uncluttered interfaces
- **Consistency**: Uniform design patterns throughout
- **Accessibility**: Support for various user needs
- **Performance**: Efficient rendering and smooth animations
- **User Experience**: Intuitive navigation and clear information hierarchy
- **Modern UI**: SwiftUI mit aktuellen iOS Design Patterns
- **Theme Support**: Dark/Light Mode für bessere User Experience

## 📱 **Screenshots**

*Screenshots werden in Kürze hinzugefügt*

## 🤝 **Contributing**

1. Fork das Repository
2. Erstelle einen Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Committe deine Änderungen (`git commit -m 'Add some AmazingFeature'`)
4. Push zum Branch (`git push origin feature/AmazingFeature`)
5. Öffne einen Pull Request

## 📄 **License**

Dieses Projekt ist unter der MIT License - siehe [LICENSE](LICENSE) Datei für Details.

---

**Entwickelt mit ❤️ in SwiftUI + Supabase**

*Travely - Deine moderne iOS Travel App* 🚀✈️🏨

