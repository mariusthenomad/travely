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

### 🏠 **Home View**
- Welcome screen with quick actions
- Featured destinations carousel
- Navigation hub with action cards

### ✈️ **Flight Search**
- Comprehensive flight search with origin/destination selection
- Date picker for departure and return dates
- Passenger count selection
- One-way and round-trip options
- Interactive flight cards with booking options

### 🏨 **Hotel Management**
- Hotel listing with detailed information
- Hotel detail view with amenities, reviews, and booking options
- Image galleries and rating systems
- Booking date selection and guest count

### 🗺️ **Destination Selection**
- Grid-based destination browsing
- Search and filter functionality
- Category-based filtering (Europe, Asia, Americas, etc.)
- Destination detail pages with booking options

### 👤 **Profile & Settings**
- User profile management with editable information
- Travel preferences and booking history
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

## 🛠 **Technology Stack**
- **Frontend**: SwiftUI (iOS 15.0+)
- **Backend**: Supabase (PostgreSQL, Auth, Storage)
- **Authentication**: Supabase Auth + Google Sign-In
- **State Management**: @StateObject, @EnvironmentObject
- **Networking**: URLSession + Supabase Swift SDK
- **UI Framework**: SwiftUI with modern design patterns

## 📁 **Project Structure**
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

## 🔧 **Key Components**

### 🔐 **Authentication System**
- **Supabase Auth Client** - Real user authentication
- **Email/Password Login** - Fully functional
- **Google Sign-In** - Temporarily disabled
- **Session Management** - Automatic login

### 📊 **Data Models**
- **User**: Profile information and preferences
- **Flight**: Airline, timing, pricing, and route information
- **Hotel**: Name, location, amenities, ratings, and pricing
- **Destination**: Name, country, region, images, and pricing
- **Booking**: Travel bookings and history

### 🎯 **State Management**
- **@StateObject** and **@EnvironmentObject** for global state
- **@State** and **@Binding** for local state management
- **Form validation** and user input handling
- **Toggle states** for settings and preferences
- **Loading states** for async operations

### 🗄️ **Backend Integration**
- **Supabase Database** - PostgreSQL with real-time updates
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
1. **Open Xcode** and load the project
2. **Ensure iOS 15.0+** as deployment target
3. **Supabase Dependencies** are already configured
4. **Build and Run** - `Cmd + R`
5. **Test the app** with Email/Password Login or Skip Login

### **Test Authentication:**
- **Email/Password Login** - Create an account or sign in
- **Skip Login** - For quick testing without authentication
- **Test Supabase Connection** - Test the database connection

## 📋 **Requirements**

- **iOS 15.0+**
- **Xcode 15.0+**
- **Swift 5.9+**
- **Internet connection** for Supabase

## 🔧 **Troubleshooting**

### **If the app doesn't start:**
1. **Build errors**: `Cmd + Shift + K` to clean, then `Cmd + R`
2. **Simulator issues**: Select a different simulator
3. **Supabase connection**: Check internet connection

### **Authentication issues:**
- **Email/Password Login not working**: Check internet connection
- **Google Sign-In disabled**: Temporarily disabled, use Email/Password
- **Skip Login**: Always works for quick testing

## 🚀 **Next Steps**
1. **Enable Google Sign-In** - Fix URL Scheme issue
2. **Expand database** - Add more travel features
3. **Push Notifications** - Flight notifications
4. **Offline Support** - Local data storage
5. **Payment Integration** - Real payment processing
6. **Advanced Search** - Enhanced filters and search

## 🎨 **Design Philosophy**

The app follows modern iOS design principles with focus on:
- **Simplicity**: Clean, uncluttered interfaces
- **Consistency**: Uniform design patterns throughout
- **Accessibility**: Support for various user needs
- **Performance**: Efficient rendering and smooth animations
- **User Experience**: Intuitive navigation and clear information hierarchy
- **Modern UI**: SwiftUI with current iOS design patterns
- **Theme Support**: Dark/Light Mode for better user experience

## 📱 **Screenshots**

*Screenshots will be added soon*

## 🤝 **Contributing**

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 **License**

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

**Built with ❤️ using SwiftUI + Supabase**

*Travely - Your modern iOS Travel App* 🚀✈️🏨

