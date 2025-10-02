# 🖼️ Profilbild hinzufügen - EINFACH

## Schritt 1: Bild vorbereiten
- **Format**: JPG oder PNG
- **Größe**: 300x300 bis 500x500 Pixel (quadratisch)
- **Name**: `profile.jpg` oder `profile.png`

## Schritt 2: In Xcode hinzufügen
1. **Xcode öffnen** → PathFinder.xcodeproj
2. **Rechtsklick** auf "PathFinder" Ordner (nicht PathFinder.xcodeproj!)
3. **"Add Files to PathFinder"** wählen
4. **Dein Bild auswählen** (profile.jpg)
5. **WICHTIG**: ✅ "Add to target: PathFinder" ankreuzen
6. **"Add"** klicken

## Schritt 3: Testen
- **App neu starten** im Simulator
- **Profile Tab** öffnen
- **Profilbild sollte angezeigt werden**

## Falls es nicht funktioniert:
1. **Build Clean**: Product → Clean Build Folder
2. **App neu starten**
3. **Bildname prüfen**: Muss genau "profile" heißen (ohne .jpg)

## Alternative:
- **Bild in Assets.xcassets** hinzufügen
- **Name**: "profile"
- **In Code**: `UIImage(named: "profile")`

---
**Tipp**: Das Bild wird automatisch auf 100x100 Pixel skaliert! 🎯
