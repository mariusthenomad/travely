# 🚀 PathFinder - The Travel Planner

[![SwiftUI](https://img.shields.io/badge/SwiftUI-iOS_15+-orange)]()
[![Supabase](https://img.shields.io/badge/Backend-Supabase-blue)]()
[![OpenStreetMap](https://img.shields.io/badge/Maps-OpenStreetMap-green)]()
[![Status](https://img.shields.io/badge/Status-In_Development-yellow)]()

A modern iOS Travel Planner with **Supabase Backend**, **Email Authentication**, **OpenStreetMap Integration**, and planned **Google/Apple Sign-In** integration.  
Built with SwiftUI and designed to deliver a clean, modern travel experience with intelligent route planning and real-time location search.

## 📚 Project Documentation

This project now includes comprehensive documentation in the `/DOCUMENTATION` folder:

- **[DAILY_WORK_PLAN.md](DOCUMENTATION/DAILY_WORK_PLAN.md)** - 10-day sprint with 3 tasks per day
- **[TODO_LIST.md](DOCUMENTATION/TODO_LIST.md)** - Complete task breakdown with 29+ sub-tasks
- **[TECH_STACK.md](DOCUMENTATION/TECH_STACK.md)** - Technology stack and cost overview
- **[BACKEND_PLAN.md](DOCUMENTATION/BACKEND_PLAN.md)** - Backend development roadmap
- **[UI_DESIGN_GUIDE.md](DOCUMENTATION/UI_DESIGN_GUIDE.md)** - Design system and guidelines
- **[AUTH_FLOW.md](DOCUMENTATION/AUTH_FLOW.md)** - Authentication implementation plan
- **[SUBTASK_DETAILS.md](DOCUMENTATION/SUBTASK_DETAILS.md)** - Detailed implementation instructions

## 🎯 Current Development Status

### ✅ Completed Features
- OpenStreetMap integration (Länder/Städte Suche)
- Basic UI structure
- Route planning with swipe gestures
- **🌐 Landing Page & Waitlist System** - LIVE at https://pathfinder.app

### 🚧 Active Development (29 Sub-Tasks)
- **Backend**: Complete API development (5 tasks)
- **Authentication**: Apple/Google/Email login (8 tasks)  
- **Onboarding**: User flow and subscription selection (4 tasks)
- **UI Design**: Flat design implementation (4 tasks)
- **Routes**: Enhanced swipe functionality (4 tasks)
- **Settings**: Subscription management (3 tasks)
- **Documentation**: GitHub integration (1 task)

### 💰 Cost Structure
- **Current**: $20/month (Cursor Pro)
- **Future**: $339/year total (including Apple Developer Program)
- **Free Services**: GitHub, Vercel, PostgreSQL, Firebase Auth

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

## 🗺 Development Roadmap

### 📅 9-Day Sprint Plan (UI Design Focus)
| Day | Focus Area | Tasks | Time |
|-----|------------|-------|------|
| **Sunday, Sep 29** | UI Design - Flat Design System | Flat design components, initial setup | 0.5h |
| **Monday, Sep 30** | UI Design - Flat Design System | Routes Tab Redesign, Swipe Enhancement, Menu Optimization | 2h |
| **Tuesday, Oct 1** | Landing Page Development & Launch + Flat Design & Tickets | Professional landing page, waitlist system, live website, flat design improvements, tickets tab | 1.5h |
| **Wednesday, Oct 2** | Logo Creation | PathFinder logo design and branding | 30min |
| **Thursday, Oct 3** | Foundation & Authentication Setup | Apple SDK, Google SDK, Email UI | 0h |
| **Friday, Oct 4** | Authentication Implementation | Apple Login, Google Login, Email Backend | 0h |
| **Saturday, Oct 5** | Onboarding Flow | Welcome Screen, Auth Selection, Subscription | 0h |
| **Sunday, Oct 6** | UI Design - Home Tab | Home Tab Redesign, FlatCard Implementation, Polish | 0h |
| **Monday, Oct 7** | UI Design - Routes Tab Enhancement | Routes Redesign, Swipe Enhancement, Polish | 0h |
| **Tuesday, Oct 8** | UI Design - Destination Tab | Destination Redesign, Search Enhancement, Polish | 0h |
| **Wednesday, Oct 9** | UI Design - Settings Tab | Settings Redesign, Account Management, Final Polish | 0h |
| **Thursday, Oct 10** | Final UI Polish & Testing | Complete UI Design, Performance Optimization, Testing | 0h |

### ✅ Completed Features
| Feature | Status | Description |
|---------|--------|-------------|
| OpenStreetMap Integration | ✅ Done | Nominatim + Overpass API |
| Basic UI Structure | ✅ Done | SwiftUI tabs and navigation |
| Route Planning | ✅ Done | Swipe gestures, floating button |
| Project Documentation | ✅ Done | Complete task breakdown and daily work plan |
| Flat Design System | ✅ Done | FlatDesignComponents.swift with complete design system |
| **Landing Page & Waitlist** | ✅ **LIVE** | Professional website at https://pathfinder.app |
| **Mobile Dark Mode** | ✅ **FIXED** | Complete mobile dark mode support with proper CSS variables |
| **Cookie Banner** | ✅ **ADDED** | DSGVO-compliant cookie consent with accept/decline options |
| **Imprint Page** | ✅ **CREATED** | Professional imprint page with German legal requirements |

### 🚀 Next Phase (After 7-Day Sprint)
| Feature | Status | Description |
|---------|--------|-------------|
| Advanced Features | 📝 Future | Push notifications, social features, offline caching |
| Performance Optimization | 📝 Future | Route optimization, caching, analytics |
| App Store Submission | 📝 Future | Final testing, review, and release |

---

## 🛠 Technology Stack & Costs

### 💻 Development Tools
- **IDE**: Cursor Pro ($20/month) - AI-powered development
- **Platform**: Xcode (Free) - iOS development
- **Version Control**: GitHub (Free) - Code repository

### 📱 iOS Development
- **Framework**: SwiftUI (iOS 15+) - Modern UI framework
- **Language**: Swift - Apple's programming language
- **Architecture**: MVVM - Model-View-ViewModel pattern
- **State Management**: Combine + SwiftUI state containers

### 🔧 Backend & Database
- **Backend**: Node.js + Express (Free) - API development
- **Database**: PostgreSQL (Free) - Data storage
- **ORM**: Prisma (Free) - Database management
- **Hosting**: Vercel (Free) - Backend deployment

### 🔐 Authentication
- **Apple Sign-In**: AuthenticationServices (Free)
- **Google Sign-In**: GoogleSignIn SDK (Free)
- **E-Mail Auth**: Custom implementation (Free)
- **Firebase Auth**: Google platform (Free up to 10k MAU)

### 🗺 Maps & Location
- **Maps**: Apple Maps + OpenStreetMap (Free)
- **APIs**: Nominatim + Overpass API (Free)
- **Framework**: MapKit (Free)

### 💰 Total Monthly Cost: $20 (Cursor Pro only)
### 💰 Total Annual Cost: $339 (including Apple Developer Program)

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
   git clone https://github.com/yourusername/pathfinder.git
   cd pathfinder
   ```

2. **Configure Supabase**
   - Create a new Supabase project
   - Update `PathFinderApp.swift` with your Supabase URL and API key
   - Set up authentication providers in Supabase dashboard

3. **Open in Xcode**
   ```bash
   open PathFinder.xcodeproj
   ```

4. **Build and Run**
   - Select your target device/simulator
   - Press ⌘+R to build and run

### Configuration

#### Supabase Setup
```swift
// PathFinderApp.swift
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
PathFinder/
├── 🏠 HomeView.swift - Welcome screen and navigation hub
├── 🗺 TravelRouteView.swift - Route planning with swipe gestures
├── 🌍 DestinationSelectionView.swift - OSM-powered location search
├── ✈️ FlightSearchView.swift - Flight search and booking
├── 🏨 HotelDetailView.swift - Hotel information and booking
├── 👤 ProfileSettingsView.swift - User profile and settings
├── 🎨 ThemeManager.swift - Dark/light mode management
├── 🔧 Extensions.swift - Utility extensions
└── 📱 PathFinderApp.swift - Main app entry point
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

- 🐛 Issues: [GitHub Issues](https://github.com/mariusthenomad/pathfinder/issues)
- 💬 Discussions: [GitHub Discussions](https://github.com/mariusthenomad/pathfinder/discussions)

---

**Made with ❤️ using SwiftUI, Supabase, and OpenStreetMap**