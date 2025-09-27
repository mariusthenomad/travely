# 🚀 Travely - iOS Travel App

[![SwiftUI](https://img.shields.io/badge/SwiftUI-iOS_15+-orange)]()
[![Supabase](https://img.shields.io/badge/Backend-Supabase-blue)]()
[![OpenStreetMap](https://img.shields.io/badge/Maps-OpenStreetMap-green)]()
[![Status](https://img.shields.io/badge/Status-In_Development-yellow)]()

A modern iOS Travel App with **Supabase Backend**, **Email Authentication**, **OpenStreetMap Integration**, and planned **Google/Apple Sign-In** integration.  
Built with SwiftUI and designed to deliver a clean, modern travel experience with real-time location search.

---

## ✨ Features

### 🔐 Authentication
- Email/Password login with Supabase
- Google Sign-In (temporarily disabled, URL scheme fix pending)
- Apple Sign-In (planned)
- Skip Login mode for testing

### 🗺 Location & Maps
- **OpenStreetMap Nominatim API** - Real-time city and country search
- **OpenStreetMap Overpass API** - Points of Interest (POIs) search
- **Google Places API** - Alternative location search (simulated)
- **Smart Search** - Automatic search activation, no button required
- **Multi-source Search** - Switch between OSM and Google data sources

### 🎨 UI/UX
- Dark/Light mode with ThemeManager
- SwiftUI design with modern iOS patterns
- Responsive layouts
- Smooth loading states and animations
- **Swipe Gestures** - Swipe to delete/edit route stops
- **Floating Action Button** - Quick add location in Routes tab

### 🏨 Travel & Routes
- **Interactive Route Planning** - Add, edit, and delete route stops
- **Nights Management** - Adjust trip length with date calculations
- **Flight Search** - One-way & round-trip with booking integration
- **Hotel Details** - Amenities, reviews, and booking information
- **Destination Browser** - Grid layout with search and filtering
- **Add Location** - Real-time search with OpenStreetMap integration

### 🏠 Home & Navigation
- Welcome screen with quick actions
- Featured destinations carousel
- Navigation hub with action cards
- **Tab-based Navigation** - Home, Routes, Destinations, Profile
- **Floating Plus Button** - Context-aware location addition

---

## 🗺 Roadmap

| Status | Feature |
|--------|----------|
| ✅ Done | Basic Supabase integration (Auth, DB connection) |
| ✅ Done | Email/Password Login |
| ✅ Done | **OpenStreetMap Nominatim API** integration |
| ✅ Done | **OpenStreetMap Overpass API** integration |
| ✅ Done | **Real-time location search** in Destinations |
| ✅ Done | **Add Location** with OSM search in Routes |
| ✅ Done | **Swipe gestures** for route management |
| ✅ Done | **Nights editing** with automatic date calculation |
| ✅ Done | **Floating action button** for quick location addition |
| 🚧 In Progress | Google Sign-In (fix URL scheme) |
| 🚧 In Progress | Apple Sign-In integration |
| 🚧 In Progress | Backend: Travel routes database |
| 📝 Planned | **Enhanced POI categories** (restaurants, attractions, etc.) |
| 📝 Planned | **Offline map caching** for better performance |
| 📝 Planned | **Route optimization** and travel time calculations |
| 📝 Planned | **Push Notifications** (flight updates) |
| 📝 Planned | **Payment integration** for bookings |
| 📝 Planned | **Social features** - share routes with friends |

---

## 🛠 Technology Stack

- **Frontend**: SwiftUI (iOS 15+)  
- **Backend**: Supabase (PostgreSQL, Auth, Storage, Functions)  
- **Maps & Location**: OpenStreetMap (Nominatim + Overpass APIs)
- **Auth**: Supabase Auth + Google/Apple Sign-In  
- **Networking**: URLSession + Supabase Swift SDK  
- **State Management**: SwiftUI state containers (@State, @StateObject, @EnvironmentObject)
- **Gestures**: SwiftUI DragGesture for swipe interactions
- **Animations**: SwiftUI withAnimation and spring animations

---

## 🚀 Getting Started

### Prerequisites
- Xcode 15.0+
- iOS 15.0+ deployment target
- Supabase account and project
- OpenStreetMap API access (free, no API key required)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/travely.git
   cd travely
   ```

2. **Configure Supabase**
   - Create a new Supabase project
   - Update `TravelyApp.swift` with your Supabase URL and API key
   - Set up authentication providers in Supabase dashboard

3. **Open in Xcode**
   ```bash
   open Travely.xcodeproj
   ```

4. **Build and Run**
   - Select your target device/simulator
   - Press ⌘+R to build and run

### Configuration

#### Supabase Setup
```swift
// TravelyApp.swift
private let supabaseURL = "YOUR_SUPABASE_URL"
private let supabaseKey = "YOUR_SUPABASE_ANON_KEY"
```

#### OpenStreetMap APIs
- **Nominatim API**: No configuration required (free tier)
- **Overpass API**: No API key needed
- **Rate Limits**: 1 request per second (automatically handled)

---

## 📱 App Structure

```
Travely/
├── 🏠 HomeView.swift - Welcome screen and navigation hub
├── 🗺 TravelRouteView.swift - Route planning with swipe gestures
├── 🌍 DestinationSelectionView.swift - OSM-powered location search
├── ✈️ FlightSearchView.swift - Flight search and booking
├── 🏨 HotelDetailView.swift - Hotel information and booking
├── 👤 ProfileSettingsView.swift - User profile and settings
├── 🎨 ThemeManager.swift - Dark/light mode management
├── 🔧 Extensions.swift - Utility extensions
└── 📱 TravelyApp.swift - Main app entry point
```

### Key Components

- **NominatimManager** - Handles city/country search via OpenStreetMap
- **OverpassManager** - Manages POI search (restaurants, cafes, etc.)
- **PlacesManager** - Google Places API integration (simulated)
- **ThemeManager** - Centralized theme and color management

---

## 🔍 API Integration Details

### OpenStreetMap Nominatim API
```swift
// Real-time city and country search
let url = "https://nominatim.openstreetmap.org/search?format=json&q=\(query)&limit=10"
```

**Features:**
- Global coverage of cities, countries, and landmarks
- No API key required
- 1 request per second rate limit
- Returns coordinates, display names, and location types

### OpenStreetMap Overpass API
```swift
// Points of Interest search
let query = """
[out:json][timeout:25];
(
  node["amenity"~"restaurant|cafe|bar"](around:1000,\(lat),\(lon));
  way["amenity"~"restaurant|cafe|bar"](around:1000,\(lat),\(lon));
);
out center;
"""
```

**Features:**
- POI search (restaurants, cafes, attractions)
- Radius-based queries
- Real-time data from OpenStreetMap
- No API key required

---

## 🎯 Usage Examples

### Adding a Location to Route
1. Navigate to **Routes** tab
2. Tap the **floating plus button**
3. Enter location name (e.g., "Berlin")
4. Select from OpenStreetMap results
5. Choose number of nights
6. Location is added to your route

### Searching Destinations
1. Go to **Destinations** tab
2. Type in search bar (e.g., "Paris")
3. Results appear automatically from OpenStreetMap
4. Switch between OSM and Google data sources
5. Tap result to view details

### Managing Route Stops
- **Swipe left** on a route stop to delete
- **Swipe right** on a route stop to edit
- **Tap "Planned Nights"** to adjust trip length
- **Drag to reorder** route stops (planned)

---

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Development Guidelines
- Follow SwiftUI best practices
- Use meaningful variable and function names
- Add comments for complex logic
- Test on multiple device sizes
- Ensure accessibility compliance

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

- **OpenStreetMap** contributors for providing free, open-source map data
- **Supabase** for the excellent backend-as-a-service platform
- **SwiftUI** community for inspiration and best practices
- **Apple** for the amazing SwiftUI framework

---

## 📞 Support

- 🐛 Issues: [GitHub Issues](https://github.com/mariusthenomad/travely/issues)
- 💬 Discussions: [GitHub Discussions](https://github.com/mariusthenomad/travely/discussions)

---

**Made with ❤️ using SwiftUI and OpenStreetMap**