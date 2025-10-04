# 🚀 PathFinder Adventures Supabase Setup

## ✅ Was wurde erstellt:

### 📁 Dateien:
- `adventures_supabase_migration.sql` - Komplette SQL-Migration
- `AdventuresSupabaseManager.swift` - Swift-Integration für deine App
- `run_adventures_migration.swift` - Migration-Runner Script

### 🗄️ Supabase Tabellen:
- `adventures` - Haupttabelle für Adventures
- `adventure_flights` - Flugdaten
- `adventure_places` - Orte und Hotels
- `adventure_badges` - Badges/Emojis

## 🎯 Deine aktuellen Adventures:

1. **European Adventure** - €1,290, 11 Nächte
2. **Asian Discovery** - €1,245, 21 Nächte  
3. **Asia Adventure March 2026** - €2,664, 20 Nächte

## 🚀 So führst du die Migration aus:

### Option 1: Supabase Dashboard (Empfohlen)
1. Öffne dein Supabase Dashboard
2. Gehe zu **SQL Editor**
3. Kopiere den gesamten Inhalt aus `adventures_supabase_migration.sql`
4. Füge ihn in den SQL Editor ein
5. Klicke auf **Run** oder **Execute**

### Option 2: Supabase CLI
```bash
# Falls du Supabase CLI installiert hast:
supabase db push
```

## 📱 Swift-Integration:

### 1. Supabase-Credentials aktualisieren:
In `AdventuresSupabaseManager.swift`:
```swift
let supabaseURL = URL(string: "DEINE_SUPABASE_URL")!
let supabaseKey = "DEINE_SUPABASE_ANON_KEY"
```

### 2. In deiner App verwenden:
```swift
@StateObject private var supabaseManager = AdventuresSupabaseManager()

// Adventures von Supabase laden
Task {
    await supabaseManager.fetchAdventures()
}

// Adventure speichern
Task {
    try await supabaseManager.saveAdventure(adventure)
}
```

## 🔍 Verifikation:

Nach der Migration solltest du in deinem Supabase Dashboard sehen:
- 4 neue Tabellen
- 3 Adventures in der `adventures` Tabelle
- Flugdaten, Orte und Badges in den jeweiligen Tabellen

## 🎉 Fertig!

Deine Adventures sind jetzt bereit für Supabase! Die Tabellen enthalten alle deine aktuellen Adventure-Daten und sind bereit für die Synchronisation mit deiner iOS-App.

## 📞 Support:

Falls du Probleme hast:
1. Prüfe deine Supabase-Credentials
2. Stelle sicher, dass RLS (Row Level Security) aktiviert ist
3. Teste die Verbindung mit dem `AdventuresSupabaseManager`

