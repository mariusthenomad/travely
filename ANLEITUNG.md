# 🚀 Travely - iOS Travel App

A modern iOS Travel App with **Supabase Backend** and **Google Sign-In** integration.

## ✨ Features

### 🔐 **Authentication System**
- **Email/Password Login** - Fully functional with Supabase
- **Google Sign-In** - Temporarily disabled (URL Scheme fix in progress)
- **Skip Login** - For quick testing without authentication
- **Supabase Integration** - Real database connection

### 🎨 **UI/UX Features**
- **Dark/Light Mode** - Automatic theme switching
- **Modern Design** - SwiftUI with current iOS design patterns
- **Responsive Layout** - Optimized for all iPhone sizes
- **Loading States** - Smooth loading indicators

### 🏨 **Travel Features**
- **Flight Search** - Flight search with various parameters
- **Hotel Details** - Detailed hotel information
- **Destination Browser** - Destination overview with grid layout
- **Profile Management** - User profile and settings

## 🛠 Installation & Setup

### Step 1: Open Xcode
1. Open Xcode on your Mac
2. Choose "Open a project or file" or press `Cmd + O`

### Step 2: Open Project
1. Navigate to the folder: `/Users/marius/Documents/Corsor/Travely`
2. Select the file `Travely.xcodeproj`
3. Click "Open"

### Step 3: Select Simulator
1. In Xcode, top left next to the Play button, select an iOS Simulator
2. Recommended options:
   - **iPhone 17** (iOS 18.0) - Recommended
   - iPhone 15 Pro (iOS 17.0)
   - iPhone 14 Pro (iOS 16.0)

### Step 4: Start App
1. Click the Play button (▶️) or press `Cmd + R`
2. Xcode will compile and start the app in the simulator

## 🎯 Test the App
The Travely app will open in the simulator and you can:

### 🔐 **Test Authentication:**
- **Email/Password Login** - Create an account or sign in
- **Skip Login** - For quick testing without authentication
- **Test Supabase Connection** - Test the database connection

### 🧭 **Test Navigation:**
- **Home Tab**: Overview with quick actions
- **Flights Tab**: Flight search with search form
- **Destinations Tab**: Destination browser with grid layout
- **Profile Tab**: User profile and settings

### ✈️ **Try Travel Features:**
- Flight search with various parameters
- View hotel details
- Browse and filter destinations
- Edit profile
- Adjust app settings
- Switch Dark/Light Mode

## 🔧 Troubleshooting

### If the app doesn't start:
1. **Build errors**: Press `Cmd + Shift + K` to clean, then `Cmd + R` to recompile
2. **Simulator issues**: Select a different simulator
3. **iOS version**: Make sure the simulator uses iOS 15.0+
4. **Supabase connection**: Check internet connection for database access

### 🔐 **Authentication issues:**
- **Email/Password Login not working**: Check internet connection
- **Google Sign-In disabled**: Temporarily disabled, use Email/Password
- **Skip Login**: Always works for quick testing

### 🖼 **If images don't load:**
- The app uses Unsplash images over the internet
- Make sure the simulator has internet connection
- Images are loaded asynchronously (may take a moment)

### 🎨 **Theme issues:**
- **Dark/Light Mode**: Works automatically based on system settings
- **Colors**: All colors are defined in `Assets.xcassets`

## 📁 Project Structure
```
Travely/
├── Travely.xcodeproj                    # Xcode project file
├── Travely/                             # Main folder
│   ├── TravelyApp.swift                 # App entry point + Authentication
│   ├── ContentView.swift                # Tab navigation
│   ├── HomeView.swift                   # Home screen
│   ├── FlightSearchView.swift           # Flight search
│   ├── HotelDetailView.swift            # Hotel details
│   ├── DestinationSelectionView.swift   # Destinations
│   ├── ProfileSettingsView.swift        # Profile
│   ├── AppSettingsView.swift            # Settings
│   ├── ThemeManager.swift               # Dark/Light Mode Management
│   ├── Assets.xcassets/                 # App icons and colors
│   │   ├── AppIcon.appiconset/          # App icons
│   │   ├── AccentColor.colorset/        # Accent colors
│   │   └── profile.imageset/            # Profile images
│   ├── GoogleService-Info.plist         # Google Sign-In configuration
│   └── Info.plist                       # App configuration
├── database_schema.sql                  # Supabase database schema
├── GOOGLE_SETUP_INSTRUCTIONS.md         # Google Sign-In setup
└── README.md                            # Project documentation
```

## 🛠 **Technology Stack**
- **Frontend**: SwiftUI (iOS 15.0+)
- **Backend**: Supabase (PostgreSQL, Auth, Storage)
- **Authentication**: Supabase Auth + Google Sign-In
- **State Management**: @StateObject, @EnvironmentObject
- **Networking**: URLSession + Supabase Swift SDK
- **UI Framework**: SwiftUI with modern design patterns

## ⌨️ **Useful Xcode Shortcuts:**
- `Cmd + R`: Start app
- `Cmd + Shift + K`: Clean project
- `Cmd + .`: Stop app
- `Cmd + Shift + O`: Open file quickly
- `Cmd + 1-9`: Open different panels
- `Cmd + Shift + A`: Reset simulator

## 🎨 **Design System**
- **Font Family**: Inter
- **Primary Color**: #FF9500 (Orange)
- **Secondary Text Color**: Gray
- **Background**: White
- **Corner Radius**: 20px for cards and buttons
- **Shadows**: Light shadows for depth and elevation
- **Icons**: SF Symbols throughout the app
- **Color Scheme**: Orange (#FF9500) as primary, white background

### 🧭 **Navigation System**
- **Tab Bar**: Bottom navigation with 4 main sections
- **Navigation Links**: Seamless navigation between views
- **Modal Presentations**: Settings and detail views

## 🚀 **Next Steps**
1. **Enable Google Sign-In** - Fix URL Scheme issue
2. **Expand database** - Add more travel features
3. **Push Notifications** - Flight notifications
4. **Offline Support** - Local data storage

---

**Have fun testing the Travely app!** 🚀✈️🏨

*Built with ❤️ using SwiftUI + Supabase*
