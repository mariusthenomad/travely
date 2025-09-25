# 📸 Profilbild Anleitung

## So fügst du dein eigenes Profilbild hinzu:

### 1. **Bild vorbereiten**
- **Format**: JPG oder PNG
- **Größe**: 300x300 bis 500x500 Pixel (quadratisch)
- **Name**: `profile.jpg` oder `profile.png`
- **Wichtig**: Das Bild wird automatisch auf 100x100 Pixel skaliert

### 2. **Bild in Xcode hinzufügen**

#### Option A: Über Xcode (Empfohlen)
1. Öffne das **Travely.xcodeproj** Projekt in Xcode
2. Klicke mit der rechten Maustaste auf den **Travely** Ordner
3. Wähle **"Add Files to Travely"**
4. Navigiere zu deinem Profilbild
5. Stelle sicher, dass **"Add to target: Travely"** ausgewählt ist
6. Klicke **"Add"**

#### Option B: Über Finder
1. Kopiere dein Profilbild in den Ordner: `/Users/marius/Documents/Corsor/Travely/Travely/`
2. Benenne es um zu: `profile.jpg` oder `profile.png`

### 3. **Bild im Assets.xcassets hinzufügen (Optional)**
1. Öffne **Assets.xcassets** in Xcode
2. Klicke mit der rechten Maustaste → **"New Image Set"**
3. Benenne es zu **"profile"**
4. Ziehe dein Bild in den **1x** Slot

### 4. **Testen**
- Starte die App im Simulator
- Gehe zum **Profile** Tab
- Dein Profilbild sollte jetzt angezeigt werden!

## 🎯 **Wichtige Hinweise:**
- Das Bild wird automatisch als Kreis angezeigt
- Falls kein Bild gefunden wird, wird das Standard-Icon angezeigt
- Das Bild wird in der Größe 100x100 Pixel angezeigt
- **Unterstützte Größen**: 300x300 bis 500x500 Pixel
- **Automatische Skalierung**: Größere Bilder werden automatisch angepasst

## 📁 **Ordnerstruktur:**
```
Travely/
├── ProfileImages/          # Hier kannst du dein Bild ablegen
│   └── README.md
├── Assets.xcassets/        # Oder hier als Asset
└── profile.jpg            # Oder direkt hier
```

### 🎨 **Empfohlene Bildgröße:**
- **300x300 bis 500x500 Pixel** (quadratisch)
- **Format**: JPG oder PNG
- **Automatische Skalierung**: Das Bild wird perfekt auf 100x100 Pixel angepasst

Viel Spaß mit deinem persönlichen Profilbild! 🚀✨
