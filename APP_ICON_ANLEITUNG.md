# App Icon Anleitung für PathFinder

## 🎨 App Icon Design

Das App Icon basiert auf dem Launch Screen Design und verwendet:
- **Gradient-Hintergrund**: Blauer Gradient (#1D4ED8 zu #0D2640)
- **Flugzeug-Icon**: `airplane.departure` in weiß
- **Abgerundete Ecken**: 22% Corner Radius
- **Schatten-Effekt**: Subtiler blauer Schatten

## 📱 Benötigte Icon-Größen

### iPhone Icons:
- **20x20** (1x, 2x, 3x) - Settings, Spotlight
- **29x29** (1x, 2x, 3x) - Settings, Spotlight
- **40x40** (1x, 2x, 3x) - Settings, Spotlight
- **60x60** (2x, 3x) - Home Screen
- **120x120** (2x) - Home Screen
- **180x180** (3x) - Home Screen

### iPad Icons:
- **20x20** (1x, 2x) - Settings
- **29x29** (1x, 2x) - Settings
- **40x40** (1x, 2x) - Settings
- **76x76** (1x, 2x) - Home Screen
- **83.5x83.5** (2x) - Home Screen

### App Store:
- **1024x1024** (1x) - App Store

## 🛠️ Icon-Generierung

### Methode 1: SwiftUI Preview
1. Öffne `AppIconSizes.swift` in Xcode
2. Verwende die Preview-Funktion
3. Mache Screenshots der verschiedenen Größen
4. Speichere als PNG-Dateien

### Methode 2: IconGeneratorView
1. Öffne `IconGeneratorView.swift` in Xcode
2. Führe die App im Simulator aus
3. Navigiere zur IconGeneratorView
4. Mache Screenshots der gewünschten Größen

## 📁 Datei-Struktur

```
Assets.xcassets/AppIcon.appiconset/
├── Contents.json
├── AppIcon-20.png (20x20)
├── AppIcon-20@2x.png (40x40)
├── AppIcon-20@3x.png (60x60)
├── AppIcon-29.png (29x29)
├── AppIcon-29@2x.png (58x58)
├── AppIcon-29@3x.png (87x87)
├── AppIcon-40.png (40x40)
├── AppIcon-40@2x.png (80x80)
├── AppIcon-40@3x.png (120x120)
├── AppIcon-60@2x.png (120x120)
├── AppIcon-60@3x.png (180x180)
├── AppIcon-76.png (76x76)
├── AppIcon-76@2x.png (152x152)
├── AppIcon-83.5@2x.png (167x167)
└── AppIcon-1024.png (1024x1024)
```

## 🎯 Design-Spezifikationen

### Farben:
- **Primär**: #1D4ED8 (RGB: 29, 78, 216)
- **Sekundär**: #0D2640 (RGB: 13, 38, 64)
- **Icon**: Weiß (#FFFFFF)

### Abmessungen:
- **Corner Radius**: 22% der Icon-Größe
- **Icon-Größe**: 40% der Icon-Größe
- **Schatten**: 10% der Icon-Größe

### Rotation:
- **Flugzeug**: -15° für dynamischen Look

## ✅ Checkliste

- [ ] Alle 20 Icon-Größen generiert
- [ ] PNG-Format verwendet
- [ ] Dateien in AppIcon.appiconset/ gespeichert
- [ ] Contents.json aktualisiert
- [ ] Icons in Xcode getestet
- [ ] App Store Icon (1024x1024) erstellt

## 🚀 Nächste Schritte

1. **Icons generieren** mit SwiftUI Preview
2. **PNG-Dateien erstellen** in allen benötigten Größen
3. **Assets.xcassets aktualisieren** mit den neuen Icons
4. **App testen** im Simulator
5. **App Store Upload** vorbereiten

Das App Icon wird dann automatisch in der App und im App Store angezeigt! 🎉
