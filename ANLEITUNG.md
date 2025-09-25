# Anleitung: Travely App im iOS Simulator öffnen

## Schritt 1: Xcode öffnen
1. Öffne Xcode auf deinem Mac
2. Wähle "Open a project or file" oder drücke `Cmd + O`

## Schritt 2: Projekt öffnen
1. Navigiere zu dem Ordner: `/Users/marius/Documents/Corsor/Travely`
2. Wähle die Datei `Travely.xcodeproj` aus
3. Klicke auf "Open"

## Schritt 3: Simulator auswählen
1. In Xcode, oben links neben dem Play-Button, wähle einen iOS Simulator aus
2. Empfohlene Optionen:
   - iPhone 15 Pro (iOS 17.0)
   - iPhone 14 Pro (iOS 16.0)
   - iPhone 13 Pro (iOS 15.0)

## Schritt 4: App starten
1. Klicke auf den Play-Button (▶️) oder drücke `Cmd + R`
2. Xcode wird die App kompilieren und im Simulator starten

## Schritt 5: App testen
Die Travely App wird im Simulator geöffnet und du kannst:

### Navigation testen:
- **Home Tab**: Übersicht mit Quick Actions
- **Flights Tab**: Flugsuche mit Suchformular
- **Destinations Tab**: Zielort-Browser mit Grid-Layout
- **Profile Tab**: Benutzerprofil und Einstellungen

### Features ausprobieren:
- Flugsuche mit verschiedenen Parametern
- Hotel-Details ansehen
- Zielorte durchsuchen und filtern
- Profil bearbeiten
- App-Einstellungen anpassen

## Troubleshooting

### Falls die App nicht startet:
1. **Build-Fehler**: Drücke `Cmd + Shift + K` um zu cleanen, dann `Cmd + R` zum neu kompilieren
2. **Simulator-Probleme**: Wähle einen anderen Simulator aus
3. **iOS Version**: Stelle sicher, dass der Simulator iOS 15.0+ verwendet

### Falls Bilder nicht laden:
- Die App verwendet Unsplash-Bilder über das Internet
- Stelle sicher, dass der Simulator Internetverbindung hat
- Bilder werden asynchron geladen (kann einen Moment dauern)

## Projekt-Struktur
```
Travely/
├── Travely.xcodeproj          # Xcode Projektdatei
├── Travely/                   # Hauptordner
│   ├── TravelyApp.swift       # App-Einstiegspunkt
│   ├── ContentView.swift      # Tab-Navigation
│   ├── HomeView.swift         # Startseite
│   ├── FlightSearchView.swift # Flugsuche
│   ├── HotelDetailView.swift  # Hotel-Details
│   ├── DestinationSelectionView.swift # Zielorte
│   ├── ProfileSettingsView.swift # Profil
│   ├── AppSettingsView.swift  # Einstellungen
│   ├── Assets.xcassets/       # App-Icons und Farben
│   └── Info.plist            # App-Konfiguration
└── README.md                 # Projekt-Dokumentation
```

## Nützliche Tastenkürzel in Xcode:
- `Cmd + R`: App starten
- `Cmd + Shift + K`: Projekt cleanen
- `Cmd + .`: App stoppen
- `Cmd + Shift + O`: Datei schnell öffnen
- `Cmd + 1-9`: Verschiedene Panels öffnen

Viel Spaß beim Testen der Travely App! 🚀✈️🏨
