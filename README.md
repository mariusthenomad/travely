# Travely - iOS Travel Planning App

A comprehensive iOS travel planning application built with SwiftUI, featuring flight search, hotel booking, destination exploration, and user profile management.

## Features

### 🏠 Home View
- Welcome screen with quick access to all main features
- Featured destinations carousel
- Navigation hub with action cards for Flights, Hotels, Destinations, and Profile

### ✈️ Flight Search
- Comprehensive flight search with origin/destination selection
- Date picker for departure and return dates
- Passenger count selection
- One-way and round-trip options
- Real-time flight results with airline, timing, and pricing
- Interactive flight cards with booking options

### 🏨 Hotel Management
- Hotel listing with detailed information
- Hotel detail view with amenities, reviews, and booking options
- Image galleries and rating systems
- Booking date selection and guest count
- Review system with user feedback

### 🗺️ Destination Selection
- Grid-based destination browsing
- Search and filter functionality
- Category-based filtering (Europe, Asia, Americas, etc.)
- Destination detail pages with booking options
- Featured destinations showcase

### 👤 Profile & Settings
- User profile management with editable information
- Travel preferences and booking history
- Comprehensive app settings including:
  - Notification preferences
  - Language and currency selection
  - Security settings (biometric authentication)
  - Privacy controls
  - Account management

## Design System

### Typography
- **Font Family**: Inter
- **Primary Text Color**: #1D4ED8 (Blue)
- **Secondary Text Color**: Gray
- **Background**: White

### UI Components
- **Corner Radius**: 20px for cards and buttons
- **Shadows**: Light shadows for depth and elevation
- **Icons**: SF Symbols throughout the app
- **Color Scheme**: Blue (#1D4ED8) as primary, white background

### Navigation
- **Tab Bar**: Bottom navigation with 4 main sections
- **Navigation Links**: Seamless navigation between views
- **Modal Presentations**: Settings and detail views

## Project Structure

```
Travely/
├── TravelyApp.swift              # Main app entry point
├── ContentView.swift             # Tab view container
├── HomeView.swift                # Home screen with navigation hub
├── FlightSearchView.swift        # Flight search and booking
├── HotelDetailView.swift         # Hotel information and booking
├── DestinationSelectionView.swift # Destination browsing
├── ProfileSettingsView.swift     # User profile management
├── AppSettingsView.swift         # App preferences and settings
└── README.md                     # Project documentation
```

## Key Components

### Data Models
- **Flight**: Airline, timing, pricing, and route information
- **Hotel**: Name, location, amenities, ratings, and pricing
- **Destination**: Name, country, region, images, and pricing
- **User**: Profile information and preferences
- **Booking**: Travel bookings and history

### State Management
- Uses `@State` and `@Binding` for local state management
- Form validation and user input handling
- Toggle states for settings and preferences

### Sample Data
- Comprehensive dummy data for flights, hotels, and destinations
- Realistic pricing and information
- Multiple categories and regions covered

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

## Getting Started

1. Open the project in Xcode
2. Ensure you have iOS 15.0+ as the deployment target
3. Build and run the project
4. Navigate through the app using the bottom tab bar

## Requirements

- iOS 15.0+
- Xcode 13.0+
- Swift 5.5+

## Future Enhancements

- Real API integration for flights and hotels
- User authentication and account management
- Payment processing integration
- Push notifications
- Offline mode support
- Advanced filtering and search
- Social features and sharing
- Travel itinerary management

## Design Philosophy

The app follows modern iOS design principles with a focus on:
- **Simplicity**: Clean, uncluttered interfaces
- **Consistency**: Uniform design patterns throughout
- **Accessibility**: Support for various user needs
- **Performance**: Efficient rendering and smooth animations
- **User Experience**: Intuitive navigation and clear information hierarchy

---

Built with ❤️ using SwiftUI

