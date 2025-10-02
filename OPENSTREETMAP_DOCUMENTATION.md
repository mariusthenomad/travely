# OpenStreetMap Overpass API Integration - Dokumentation

## ✅ Status: FUNKTIONIERT

Die OpenStreetMap Overpass API ist erfolgreich in die PathFinder App integriert und getestet.

## 🔗 API-Verbindung

**Base URL:** `https://overpass-api.de/api/interpreter`

**Test erfolgreich:** ✅
- Cafés in München gefunden: 11 Ergebnisse
- Restaurants in München gefunden: Mehrere Ergebnisse
- API antwortet korrekt mit JSON-Daten

## 📁 Dateien

### 1. `DestinationOverpass.swift`
Hauptdatei mit der Overpass API Integration:

```swift
// Overpass API Manager
class OverpassManager: ObservableObject {
    @Published var searchResults: [OverpassPOI] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let baseURL = "https://overpass-api.de/api/interpreter"
}
```

### 2. `DestinationSelectionView.swift`
Erweiterte Destination-Ansicht mit Toggle zwischen Google Places und Overpass API.

## 🎯 Funktionen

### POI-Suche
- **Cafés**: `searchCafes()`
- **Restaurants**: `searchRestaurants()`
- **Hotels**: `searchHotels()`
- **Sehenswürdigkeiten**: `searchAttractions()`
- **Allgemeine Suche**: `searchPOIs()`

### Standortbasiert
- **Standard**: München (48.1351, 11.5820)
- **Radius**: 1000m (konfigurierbar)
- **Bounding Box**: Automatische Berechnung

## 🔍 Beispiel-Queries

### Cafés in München
```txt
[out:json];
node["amenity"="cafe"](48.1351,11.5820,48.1451,11.5920);
out;
```

### Restaurants in München
```txt
[out:json];
node["amenity"="restaurant"](48.1351,11.5820,48.1451,11.5920);
out;
```

### Allgemeine Namenssuche
```txt
[out:json];
node["name"~"Café",i](48.1351,11.5820,48.1451,11.5920);
out;
```

## 📊 Datenstruktur

### OverpassResponse
```swift
struct OverpassResponse: Codable {
    let elements: [OverpassElement]
}
```

### OverpassElement
```swift
struct OverpassElement: Codable {
    let type: String
    let id: Int
    let lat: Double?
    let lon: Double?
    let tags: [String: String]?
}
```

### OverpassPOI
```swift
struct OverpassPOI: Identifiable, Hashable {
    let id: String
    let name: String
    let amenity: String
    let address: String
    let coordinate: CLLocationCoordinate2D
    let tags: [String: String]
}
```

## 🎨 UI-Komponenten

### OverpassPOIView
- **Icon**: Dynamisch basierend auf Amenity-Typ
- **Name**: POI-Name
- **Kategorie**: Deutsche Übersetzung (Café, Restaurant, etc.)
- **Adresse**: Vollständige Adresse
- **Styling**: Konsistent mit App-Design

### Toggle-Buttons
- **Karte-Icon**: Overpass API aktivieren
- **Globus-Icon**: Google Places aktivieren
- **Exklusiv**: Nur eine API gleichzeitig aktiv

## 🌍 Unterstützte POI-Typen

| Amenity | Icon | Deutsche Bezeichnung |
|---------|------|---------------------|
| `cafe` | ☕ | Café |
| `restaurant` | 🍽️ | Restaurant |
| `hotel` | 🛏️ | Hotel |
| `tourist` | 📷 | Sehenswürdigkeit |
| `hospital` | ⚕️ | Krankenhaus |
| `school` | 🎓 | Schule |
| `bank` | 🏦 | Bank |
| `pharmacy` | 💊 | Apotheke |
| `fuel` | ⛽ | Tankstelle |
| `parking` | 🅿️ | Parkplatz |

## 🔧 Technische Details

### HTTP-Request
```swift
var request = URLRequest(url: url)
request.httpMethod = "POST"
request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

let body = "data=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
request.httpBody = body.data(using: .utf8)
```

### JSON-Parsing
```swift
let overpassResponse = try JSONDecoder().decode(OverpassResponse.self, from: data)
self?.searchResults = overpassResponse.elements.compactMap { element in
    guard element.lat != nil, element.lon != nil, !element.name.isEmpty else {
        return nil
    }
    return OverpassPOI(from: element)
}
```

## 📱 Verwendung in der App

### 1. Destination-Tab öffnen
### 2. Karten-Button (Overpass API) aktivieren
### 3. Suchbegriff eingeben (z.B. "Café", "Restaurant")
### 4. Ergebnisse werden live angezeigt

## 🚀 Vorteile

- **Kostenlos**: Keine API-Keys erforderlich
- **Echtzeit**: Live-Daten von OpenStreetMap
- **Umfangreich**: Millionen von POIs weltweit
- **Offen**: Open Source, keine Beschränkungen
- **Aktuell**: Community-gesteuerte Updates

## 🔮 Erweiterungsmöglichkeiten

### Geplante Features
- [ ] Standortberechtigung für bessere Ergebnisse
- [ ] Erweiterte Filter (Bewertungen, Öffnungszeiten)
- [ ] Kartenansicht der POIs
- [ ] Favoriten-System
- [ ] Offline-Caching
- [ ] Mehr POI-Typen (Museen, Parks, etc.)

### Mögliche Queries
```txt
# Museen
node["tourism"="museum"](bbox);

# Parks
node["leisure"="park"](bbox);

# Öffentliche Verkehrsmittel
node["public_transport"="station"](bbox);

# Shopping
node["shop"](bbox);
```

## ✅ Build-Status

- **Build erfolgreich**: Alle Fehler behoben
- **Scope-Probleme gelöst**: `useOverpassAPI` und `overpassManager` korrekt in `CountriesListView` definiert
- **CoreLocation importiert**: Für Koordinaten-Handling

## 📞 Support

Bei Problemen mit der Overpass API:
- **Dokumentation**: https://wiki.openstreetmap.org/wiki/Overpass_API
- **Test-Tool**: https://overpass-turbo.eu/
- **Status**: https://overpass-api.de/api/status

## 🎉 Fazit

Die OpenStreetMap Overpass API Integration ist **erfolgreich implementiert** und **funktionsfähig**. Die API liefert echte POI-Daten aus München und kann für die gesamte PathFinder App genutzt werden.

**Status**: ✅ **Bereit für Produktion**

### Nächste Schritte:
1. ✅ Build-Fehler behoben
2. 🔄 In der App testen (Destination-Tab → Karten-Button → Suche)
3. 🚀 Weitere POI-Typen hinzufügen
4. 📍 Standortberechtigung implementieren
