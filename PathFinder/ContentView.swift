import SwiftUI
import CoreLocation
import MapKit
import Auth
import PostgREST

// MARK: - Premium Dark Design System
struct UltraLightDesignSystem {
    // Premium Dark Colors
    static let background = Color(red: 0.05, green: 0.05, blue: 0.05) // Deep black
    static let surface = Color(red: 0.08, green: 0.08, blue: 0.08) // Dark surface
    static let surfaceElevated = Color(red: 0.12, green: 0.12, blue: 0.12) // Elevated surface
    static let surfaceGlass = Color(red: 0.1, green: 0.1, blue: 0.1).opacity(0.8) // Glass effect
    
    // Premium Accent Colors - Orange Only
    static let primaryOrange = Color(red: 1.0, green: 0.6, blue: 0.2) // Brighter orange
    static let primaryGreen = Color(red: 1.0, green: 0.6, blue: 0.2) // Same as orange
    static let accentGold = Color(red: 1.0, green: 0.8, blue: 0.2) // Premium gold
    
    // Text Colors
    static let text = Color.white
    static let textSecondary = Color(red: 0.7, green: 0.7, blue: 0.7)
    static let textTertiary = Color(red: 0.5, green: 0.5, blue: 0.5)
    static let textMuted = Color(red: 0.4, green: 0.4, blue: 0.4)
    
    // Premium Shadows
    static let shadowLight = Color.black.opacity(0.3)
    static let shadowMedium = Color.black.opacity(0.5)
    static let shadowHeavy = Color.black.opacity(0.7)
    static let glowOrange = Color(red: 1.0, green: 0.6, blue: 0.2).opacity(0.3)
    static let glowGreen = Color(red: 1.0, green: 0.6, blue: 0.2).opacity(0.3) // Same as orange
    
        // Spacing (Ultra Clean Elegant)
        static let spaceXS: CGFloat = 3
        static let spaceS: CGFloat = 6
        static let spaceM: CGFloat = 12
        static let spaceL: CGFloat = 16
        static let spaceXL: CGFloat = 20
        static let spaceXXL: CGFloat = 28
        static let spaceXXXL: CGFloat = 36
        
        // Radius (Ultra Clean Elegant)
        static let radiusXS: CGFloat = 6
        static let radiusS: CGFloat = 8
        static let radiusM: CGFloat = 10
        static let radiusL: CGFloat = 12
        static let radiusXL: CGFloat = 16
        static let radiusXXL: CGFloat = 24
}

struct ContentView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @State private var showingAddLocation = false
    @State private var selectedTab = 0
    
    let tabs = [
        TabItem(
            icon: "house",
            selectedIcon: "house.fill",
            title: "Home"
        ),
        TabItem(
            icon: "map",
            selectedIcon: "map.fill",
            title: "Routes"
        ),
        TabItem(
            icon: "globe",
            selectedIcon: "globe",
            title: "Explore"
        ),
        TabItem(
            icon: "person",
            selectedIcon: "person.fill",
            title: "Profile"
        )
    ]
    
    var body: some View {
        ZStack {
            // Background
            UltraLightDesignSystem.background
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Main Content
                TabView(selection: $selectedTab) {
                    UltraLightHomeView()
                        .tag(0)
                    
                    UltraLightRoutesView()
                        .tag(1)
                    
                    UltraLightExploreView()
                        .tag(2)
                    
                    UltraLightProfileView()
                        .tag(3)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                // Trade Republic Style Tab Bar
                UltraLightTabBar(selectedTab: $selectedTab, tabs: tabs)
                    .padding(.bottom, 8)
            }
        }
        .sheet(isPresented: $showingAddLocation) {
            AddLocationView(
                onSave: { location, date, nights in
                    // TODO: Implement save functionality
                    showingAddLocation = false
                },
                onCancel: {
                    showingAddLocation = false
                }
            )
            .onAppear {
                // Ensure the sheet content is properly loaded
            }
        }
    }
}

struct AddLocationView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @StateObject private var nominatimManager = NominatimManager()
    let onSave: (String, Date, Int) -> Void
    let onCancel: () -> Void
    
    @State private var searchText = ""
    @State private var selectedDate = Date()
    @State private var selectedNights = 3
    @State private var selectedCategory = "All"
    @State private var showingSearch = false
    
    let categories = ["All", "Europe", "Asia", "Americas", "Africa", "Oceania"]
    
    // Nominatim API Search
    private func performNominatimSearch() {
        guard !searchText.isEmpty else {
            nominatimManager.searchResults = []
            return
        }
        
        nominatimManager.searchPlaces(query: searchText) { results in
            // Results are automatically set in the manager
        }
    }
    
    var endDateString: String {
        let endDate = Calendar.current.date(byAdding: .day, value: selectedNights, to: selectedDate) ?? selectedDate
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: endDate)
    }
    
    // Sample data for countries and cities
    let popularCountries = [
        Country(id: 1, name: "Germany", flag: "🇩🇪", imageURL: "https://images.unsplash.com/photo-1467269204594-9661b134dd2b?w=400&h=300&fit=crop&crop=center", cityCount: 5),
        Country(id: 2, name: "France", flag: "🇫🇷", imageURL: "https://images.unsplash.com/photo-1502602898536-47ad22581b52?w=400&h=300&fit=crop&crop=center", cityCount: 8),
        Country(id: 3, name: "Italy", flag: "🇮🇹", imageURL: "https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=400&h=300&fit=crop&crop=center", cityCount: 6),
        Country(id: 4, name: "Spain", flag: "🇪🇸", imageURL: "https://images.unsplash.com/photo-1496442226666-8d4d0e62e6e9?w=400&h=300&fit=crop&crop=center", cityCount: 7),
        Country(id: 5, name: "Japan", flag: "🇯🇵", imageURL: "https://images.unsplash.com/photo-1552832230-c0197dd311b5?w=400&h=300&fit=crop&crop=center", cityCount: 4),
        Country(id: 6, name: "Thailand", flag: "🇹🇭", imageURL: "https://images.unsplash.com/photo-1539037116277-4db20889f2d4?w=400&h=300&fit=crop&crop=center", cityCount: 3),
        Country(id: 7, name: "USA", flag: "🇺🇸", imageURL: "https://images.unsplash.com/photo-1563492065-1a120d5d8b96?w=400&h=300&fit=crop&crop=center", cityCount: 10),
        Country(id: 8, name: "Australia", flag: "🇦🇺", imageURL: "https://images.unsplash.com/photo-1502602898536-47ad22581b52?w=400&h=300&fit=crop&crop=center", cityCount: 5)
    ]
    
    let popularCities = [
        City(id: 1, name: "Berlin", country: "Germany", imageURL: "https://images.unsplash.com/photo-1467269204594-9661b134dd2b?w=400&h=300&fit=crop&crop=center"),
        City(id: 2, name: "Munich", country: "Germany", imageURL: "https://images.unsplash.com/photo-1502602898536-47ad22581b52?w=400&h=300&fit=crop&crop=center"),
        City(id: 3, name: "Paris", country: "France", imageURL: "https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=400&h=300&fit=crop&crop=center"),
        City(id: 4, name: "Lyon", country: "France", imageURL: "https://images.unsplash.com/photo-1496442226666-8d4d0e62e6e9?w=400&h=300&fit=crop&crop=center"),
        City(id: 5, name: "Rome", country: "Italy", imageURL: "https://images.unsplash.com/photo-1552832230-c0197dd311b5?w=400&h=300&fit=crop&crop=center"),
        City(id: 6, name: "Milan", country: "Italy", imageURL: "https://images.unsplash.com/photo-1539037116277-4db20889f2d4?w=400&h=300&fit=crop&crop=center"),
        City(id: 7, name: "Madrid", country: "Spain", imageURL: "https://images.unsplash.com/photo-1563492065-1a120d5d8b96?w=400&h=300&fit=crop&crop=center"),
        City(id: 8, name: "Barcelona", country: "Spain", imageURL: "https://images.unsplash.com/photo-1502602898536-47ad22581b52?w=400&h=300&fit=crop&crop=center"),
        City(id: 9, name: "Tokyo", country: "Japan", imageURL: "https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=400&h=300&fit=crop&crop=center"),
        City(id: 10, name: "Osaka", country: "Japan", imageURL: "https://images.unsplash.com/photo-1496442226666-8d4d0e62e6e9?w=400&h=300&fit=crop&crop=center"),
        City(id: 11, name: "Bangkok", country: "Thailand", imageURL: "https://images.unsplash.com/photo-1552832230-c0197dd311b5?w=400&h=300&fit=crop&crop=center"),
        City(id: 12, name: "Chiang Mai", country: "Thailand", imageURL: "https://images.unsplash.com/photo-1539037116277-4db20889f2d4?w=400&h=300&fit=crop&crop=center"),
        City(id: 13, name: "New York", country: "USA", imageURL: "https://images.unsplash.com/photo-1563492065-1a120d5d8b96?w=400&h=300&fit=crop&crop=center"),
        City(id: 14, name: "Los Angeles", country: "USA", imageURL: "https://images.unsplash.com/photo-1502602898536-47ad22581b52?w=400&h=300&fit=crop&crop=center"),
        City(id: 15, name: "Sydney", country: "Australia", imageURL: "https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=400&h=300&fit=crop&crop=center"),
        City(id: 16, name: "Melbourne", country: "Australia", imageURL: "https://images.unsplash.com/photo-1496442226666-8d4d0e62e6e9?w=400&h=300&fit=crop&crop=center")
    ]
    
    var filteredCountries: [Country] {
        let filtered = popularCountries.filter { country in
            if selectedCategory == "All" {
                return true
            } else {
                let region = getRegionForCountry(country.name)
                return region == selectedCategory
            }
        }
        
        if searchText.isEmpty {
            return filtered
        } else {
            return filtered.filter { country in
                country.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var filteredCities: [City] {
        let filtered = popularCities.filter { city in
            if selectedCategory == "All" {
                return true
            } else {
                let region = getRegionForCountry(city.country)
                return region == selectedCategory
            }
        }
        
        if searchText.isEmpty {
            return filtered
        } else {
            return filtered.filter { city in
                city.name.localizedCaseInsensitiveContains(searchText) ||
                city.country.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    func getRegionForCountry(_ country: String) -> String {
        switch country {
        case "France", "Italy", "Spain", "UK", "Germany", "Austria", "Switzerland", "Netherlands", "Belgium", "Portugal", "Greece", "Poland", "Czechia", "Hungary", "Sweden", "Norway", "Denmark", "Finland", "Ireland", "Croatia", "Bulgaria", "Romania", "Slovakia", "Slovenia", "Estonia", "Latvia", "Lithuania":
            return "Europe"
        case "Japan", "Thailand", "China", "India", "South Korea", "Singapore", "Malaysia", "Indonesia", "Philippines", "Vietnam", "Cambodia", "Laos", "Myanmar", "Sri Lanka", "Nepal", "Bhutan", "Bangladesh", "Pakistan", "Afghanistan", "Iran", "Iraq", "Turkey", "Saudi Arabia", "UAE", "Israel", "Jordan", "Lebanon", "Syria", "Kuwait", "Qatar", "Bahrain", "Oman", "Yemen":
            return "Asia"
        case "USA", "Canada", "Mexico", "Brazil", "Argentina", "Chile", "Colombia", "Peru", "Venezuela", "Ecuador", "Bolivia", "Paraguay", "Uruguay", "Guyana", "Suriname", "French Guiana", "Costa Rica", "Panama", "Guatemala", "Honduras", "Nicaragua", "El Salvador", "Belize", "Cuba", "Jamaica", "Haiti", "Dominican Republic", "Puerto Rico", "Trinidad and Tobago", "Barbados", "Antigua and Barbuda", "Saint Lucia", "Grenada", "Saint Vincent and the Grenadines", "Dominica", "Saint Kitts and Nevis":
            return "Americas"
        case "South Africa", "Egypt", "Nigeria", "Kenya", "Morocco", "Algeria", "Tunisia", "Libya", "Sudan", "Ethiopia", "Ghana", "Tanzania", "Uganda", "Cameroon", "Ivory Coast", "Madagascar", "Mozambique", "Angola", "Burkina Faso", "Mali", "Malawi", "Zambia", "Somalia", "Senegal", "Zimbabwe", "Guinea", "Rwanda", "Benin", "Tunisia", "Burundi", "South Sudan", "Togo", "Sierra Leone", "Libya", "Liberia", "Central African Republic", "Mauritania", "Eritrea", "Gambia", "Botswana", "Namibia", "Gabon", "Lesotho", "Guinea-Bissau", "Equatorial Guinea", "Mauritius", "Eswatini", "Djibouti", "Fiji", "Comoros", "Cabo Verde", "São Tomé and Príncipe", "Seychelles", "Marshall Islands", "Kiribati", "Tonga", "Micronesia", "Palau", "Samoa", "Vanuatu", "Solomon Islands", "Tuvalu", "Nauru":
            return "Africa"
        case "Australia", "New Zealand", "Papua New Guinea", "Fiji", "Samoa", "Tonga", "Vanuatu", "Solomon Islands", "Kiribati", "Tuvalu", "Nauru", "Palau", "Marshall Islands", "Micronesia":
            return "Oceania"
        default:
            return "All"
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                // Premium Dark Background
                UltraLightDesignSystem.background
                    .ignoresSafeArea()
                
                // Background Gradient Overlay
                LinearGradient(
                    colors: [
                        UltraLightDesignSystem.primaryOrange.opacity(0.1),
                        Color.clear,
                        UltraLightDesignSystem.primaryOrange.opacity(0.1)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    Spacer()
                    
                    // Premium Header
                    UltraLightWindow(
                        title: "Add Location",
                        subtitle: "Plan your next destination",
                        style: .premium
                    ) {
                        EmptyView()
                    }
                    .padding(.horizontal, UltraLightDesignSystem.spaceL)
                    .padding(.top, UltraLightDesignSystem.spaceS)
                    .padding(.bottom, UltraLightDesignSystem.spaceM)
                    
                    // Date and Nights Selection
                    UltraLightWindow(
                        title: "Travel Dates",
                        style: .glass
                    ) {
                        VStack(spacing: UltraLightDesignSystem.spaceL) {
                            // Date Picker
                            VStack(alignment: .leading, spacing: UltraLightDesignSystem.spaceS) {
                                Text("Start Date")
                                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                                    .foregroundColor(UltraLightDesignSystem.textSecondary)
                                
                                Button(action: {
                                    // Date picker will be triggered by the button
                                }) {
                                    HStack {
                                        Image(systemName: "calendar")
                                            .foregroundColor(UltraLightDesignSystem.primaryOrange)
                                            .font(.system(size: 16))
                                        
                                        Text(selectedDate, style: .date)
                                            .font(.system(size: 16, weight: .medium, design: .rounded))
                                            .foregroundColor(UltraLightDesignSystem.text)
                                        
                                        Spacer()
                                    }
                                    .padding(.horizontal, UltraLightDesignSystem.spaceL)
                                    .padding(.vertical, UltraLightDesignSystem.spaceM)
                                    .background(UltraLightDesignSystem.surface)
                                    .cornerRadius(UltraLightDesignSystem.radiusM)
                                }
                                .overlay(
                                    DatePicker("", selection: $selectedDate, displayedComponents: .date)
                                        .datePickerStyle(CompactDatePickerStyle())
                                        .opacity(0.011)
                                )
                            }
                        
                            // Nights Selection
                            VStack(alignment: .leading, spacing: UltraLightDesignSystem.spaceS) {
                                HStack {
                                    Text("Nights to stay")
                                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                                        .foregroundColor(UltraLightDesignSystem.textSecondary)
                                    
                                    Spacer()
                                    
                                    Text("\(selectedNights) nights")
                                        .font(.system(size: 14, weight: .medium, design: .rounded))
                                        .foregroundColor(UltraLightDesignSystem.primaryOrange)
                                }
                                
                                HStack {
                                    Button(action: {
                                        if selectedNights > 1 {
                                            selectedNights -= 1
                                        }
                                    }) {
                                        Image(systemName: "minus.circle.fill")
                                            .font(.system(size: 24))
                                            .foregroundColor(selectedNights > 1 ? UltraLightDesignSystem.primaryOrange : UltraLightDesignSystem.textSecondary)
                                    }
                                    .disabled(selectedNights <= 1)
                                    
                                    Spacer()
                                    
                                    Text("\(selectedNights)")
                                        .font(.system(size: 20, weight: .bold, design: .rounded))
                                        .foregroundColor(UltraLightDesignSystem.text)
                                        .frame(minWidth: 40)
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        if selectedNights < 14 {
                                            selectedNights += 1
                                        }
                                    }) {
                                        Image(systemName: "plus.circle.fill")
                                            .font(.system(size: 24))
                                            .foregroundColor(selectedNights < 14 ? UltraLightDesignSystem.primaryOrange : UltraLightDesignSystem.textSecondary)
                                    }
                                    .disabled(selectedNights >= 14)
                                }
                                .padding(.horizontal, UltraLightDesignSystem.spaceL)
                            }
                        
                            // End Date Display
                            VStack(alignment: .leading, spacing: UltraLightDesignSystem.spaceS) {
                                Text("End Date")
                                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                                    .foregroundColor(UltraLightDesignSystem.textSecondary)
                                
                                HStack {
                                    Image(systemName: "calendar")
                                        .foregroundColor(UltraLightDesignSystem.primaryOrange)
                                        .font(.system(size: 16))
                                    
                                    Text(endDateString)
                                        .font(.system(size: 16, weight: .medium, design: .rounded))
                                        .foregroundColor(UltraLightDesignSystem.text)
                                    
                                    Spacer()
                                }
                                .padding(.horizontal, UltraLightDesignSystem.spaceL)
                                .padding(.vertical, UltraLightDesignSystem.spaceM)
                                .background(UltraLightDesignSystem.surface)
                                .cornerRadius(UltraLightDesignSystem.radiusM)
                            }
                        }
                    }
                    .padding(.horizontal, UltraLightDesignSystem.spaceL)
                    .padding(.bottom, UltraLightDesignSystem.spaceS)
                    
                    // Search Bar - Premium Style
                    UltraLightWindow(style: .glass) {
                        HStack(spacing: UltraLightDesignSystem.spaceM) {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(UltraLightDesignSystem.primaryOrange)
                                .font(.system(size: 18))
                            
                            TextField("Search destinations...", text: $searchText)
                                .font(.system(size: 16, weight: .medium, design: .rounded))
                                .foregroundColor(UltraLightDesignSystem.text)
                                .onChange(of: searchText) { _ in
                                    performNominatimSearch()
                                }
                            
                            if !searchText.isEmpty {
                                Button(action: {
                                    searchText = ""
                                    nominatimManager.searchResults = []
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(UltraLightDesignSystem.textSecondary)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, UltraLightDesignSystem.spaceL)
                    .padding(.bottom, UltraLightDesignSystem.spaceS)
                    
                    // Main Content - API Results Only
                    if !searchText.isEmpty {
                        ScrollView {
                            LazyVStack(spacing: UltraLightDesignSystem.spaceM) {
                                // Nominatim API Results
                                if nominatimManager.isLoading {
                                    UltraLightWindow(style: .glass) {
                                        HStack {
                                            ProgressView()
                                                .progressViewStyle(CircularProgressViewStyle(tint: UltraLightDesignSystem.primaryOrange))
                                                .scaleEffect(1.2)
                                            
                                            Text("Searching...")
                                                .font(.system(size: 16, weight: .medium, design: .rounded))
                                                .foregroundColor(UltraLightDesignSystem.textSecondary)
                                            
                                            Spacer()
                                        }
                                    }
                                    .padding(.horizontal, UltraLightDesignSystem.spaceL)
                                    .padding(.top, 60)
                                } else if nominatimManager.searchResults.isEmpty {
                                    UltraLightWindow(style: .glass) {
                                        VStack(spacing: UltraLightDesignSystem.spaceL) {
                                            Image(systemName: "magnifyingglass")
                                                .font(.system(size: 48))
                                                .foregroundColor(UltraLightDesignSystem.textSecondary)
                                            
                                            Text("No places found")
                                                .font(.system(size: 18, weight: .semibold, design: .rounded))
                                                .foregroundColor(UltraLightDesignSystem.text)
                                            
                                            Text("Try a different search term")
                                                .font(.system(size: 14, weight: .medium, design: .rounded))
                                                .foregroundColor(UltraLightDesignSystem.textSecondary)
                                        }
                                        .padding(.vertical, UltraLightDesignSystem.spaceL)
                                    }
                                    .padding(.horizontal, UltraLightDesignSystem.spaceL)
                                    .padding(.top, 60)
                                } else {
                                    ForEach(nominatimManager.searchResults) { place in
                                        Button(action: {
                                            onSave(place.display_name, selectedDate, selectedNights)
                                        }) {
                                            UltraLightNominatimPlaceView(place: place)
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                }
                            }
                            .padding(.horizontal, UltraLightDesignSystem.spaceL)
                            .padding(.top, UltraLightDesignSystem.spaceM)
                            .padding(.bottom, 120)
                        }
                    } else {
                        // Centered Search Icon between Search Field and Buttons
                        UltraLightWindow(style: .glass) {
                            VStack(spacing: UltraLightDesignSystem.spaceM) {
                                Image(systemName: "magnifyingglass")
                                    .font(.system(size: 32))
                                    .foregroundColor(UltraLightDesignSystem.primaryOrange.opacity(0.6))
                                
                                VStack(spacing: UltraLightDesignSystem.spaceXS) {
                                    Text("Search")
                                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                                        .foregroundColor(UltraLightDesignSystem.text)
                                    
                                    Text("Enter a place to search")
                                        .font(.system(size: 14, weight: .medium, design: .rounded))
                                        .foregroundColor(UltraLightDesignSystem.textSecondary)
                                        .multilineTextAlignment(.center)
                                }
                                
                                // Error message display
                                if let errorMessage = nominatimManager.errorMessage {
                                    Text("Error: \(errorMessage)")
                                        .font(.system(size: 14, weight: .medium, design: .rounded))
                                        .foregroundColor(UltraLightDesignSystem.primaryOrange)
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal, UltraLightDesignSystem.spaceL)
                                }
                            }
                            .padding(.vertical, UltraLightDesignSystem.spaceL)
                        }
                        .padding(.horizontal, UltraLightDesignSystem.spaceL)
                    }
                    
                    // Premium Action Buttons
                    VStack(spacing: UltraLightDesignSystem.spaceM) {
                        Button(action: {
                            // Add the selected location if any
                            if !searchText.isEmpty && !nominatimManager.searchResults.isEmpty {
                                let firstResult = nominatimManager.searchResults.first!
                                onSave(firstResult.display_name, selectedDate, selectedNights)
                            }
                        }) {
                            HStack(spacing: UltraLightDesignSystem.spaceS) {
                                Image(systemName: "plus")
                                    .font(.system(size: 20, weight: .semibold))
                                
                                Text("Add Location")
                                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(
                                RoundedRectangle(cornerRadius: UltraLightDesignSystem.radiusM)
                                    .fill(
                                        LinearGradient(
                                            colors: [UltraLightDesignSystem.primaryOrange, UltraLightDesignSystem.primaryOrange.opacity(0.8)],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .shadow(
                                        color: UltraLightDesignSystem.glowOrange,
                                        radius: 10,
                                        x: 0,
                                        y: 4
                                    )
                            )
                        }
                        .disabled(searchText.isEmpty || nominatimManager.searchResults.isEmpty)
                        .opacity(searchText.isEmpty || nominatimManager.searchResults.isEmpty ? 0.5 : 1.0)
                        
                        Button(action: {
                            onCancel()
                        }) {
                            Text("Cancel")
                                .font(.system(size: 16, weight: .medium, design: .rounded))
                                .foregroundColor(UltraLightDesignSystem.textSecondary)
                                .frame(maxWidth: .infinity)
                                .frame(height: 48)
                                .background(
                                    RoundedRectangle(cornerRadius: UltraLightDesignSystem.radiusM)
                                        .fill(UltraLightDesignSystem.surface)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: UltraLightDesignSystem.radiusM)
                                                .stroke(UltraLightDesignSystem.textMuted.opacity(0.3), lineWidth: 1)
                                        )
                                )
                        }
                    }
                    .padding(.horizontal, UltraLightDesignSystem.spaceL)
                    .padding(.top, 60)
                    .padding(.bottom, 60)
                }
            }
            .navigationBarHidden(true)
        }
    }
}

// MARK: - Ultra Light Views
struct UltraLightHomeView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: UltraLightDesignSystem.spaceL) {
                // Welcome Header
                UltraLightWindow(
                    title: "Welcome back!",
                    subtitle: "Ready for your next adventure?",
                    style: .gradient
                ) {
                    HStack {
                        VStack(alignment: .leading, spacing: UltraLightDesignSystem.spaceS) {
                            Text("Your Travel Stats")
                                .font(.system(size: 16, weight: .semibold, design: .rounded))
                                .foregroundColor(UltraLightDesignSystem.text)
                            
                            HStack(spacing: UltraLightDesignSystem.spaceM) {
                                StatCard(title: "Countries", value: "12", icon: "globe")
                                StatCard(title: "Cities", value: "47", icon: "building.2")
                                StatCard(title: "Trips", value: "8", icon: "airplane")
                            }
                        }
                        
                        Spacer()
                    }
                }
                
                // Quick Actions
                UltraLightWindow(
                    title: "Quick Actions",
                    style: .standard
                ) {
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: UltraLightDesignSystem.spaceM) {
                        QuickActionCard(
                            icon: "plus.circle.fill",
                            title: "Add Route",
                            subtitle: "Plan new trip",
                            color: UltraLightDesignSystem.primaryOrange
                        )
                        
                        QuickActionCard(
                            icon: "airplane.circle.fill",
                            title: "Book Flight",
                            subtitle: "Find flights",
                            color: UltraLightDesignSystem.primaryGreen
                        )
                        
                        QuickActionCard(
                            icon: "bed.double.fill",
                            title: "Hotels",
                            subtitle: "Find stays",
                            color: UltraLightDesignSystem.primaryOrange
                        )
                        
                        QuickActionCard(
                            icon: "map.circle.fill",
                            title: "Explore",
                            subtitle: "Discover places",
                            color: UltraLightDesignSystem.primaryGreen
                        )
                    }
                }
            }
            .padding(.horizontal, UltraLightDesignSystem.spaceM)
            .padding(.top, UltraLightDesignSystem.spaceM)
        }
    }
}

struct UltraLightRoutesView: View {
    @State private var selectedAdventure: Adventure?
    @State private var showingRouteDetail = false
    @State private var showingRoutesSubmenu = false
    @State private var showingCreateAdventure = false
    @State private var showingEditAdventure: Adventure?
    @State private var showingDeleteConfirmation: Adventure?
    
    @State private var adventures = [
        Adventure(
            id: "european",
            name: "European Adventure",
            description: "Discover the best of Europe with this amazing journey through iconic cities, rich history, and stunning architecture.",
            duration: "14 days",
            difficulty: "Easy",
            budget: "€€€",
            image: "europe.africa.fill",
            color: UltraLightDesignSystem.primaryOrange,
            destinations: ["Paris", "Rome", "Barcelona", "Amsterdam"],
            highlights: ["Eiffel Tower", "Colosseum", "Sagrada Familia", "Van Gogh Museum"],
            routeData: AdventureRouteData(
                flights: [
                    FlightInfo(route: "Munich → Paris", date: "Dec 15, 2024", duration: "1h 30m", price: "€89"),
                    FlightInfo(route: "Paris → Rome", date: "Dec 18, 2024", duration: "2h 15m", price: "€95"),
                    FlightInfo(route: "Rome → Barcelona", date: "Dec 21, 2024", duration: "1h 45m", price: "€67"),
                    FlightInfo(route: "Barcelona → Amsterdam", date: "Dec 24, 2024", duration: "2h 30m", price: "€78")
                ],
                places: [
                    EditablePlace(name: "Paris", coordinate: CLLocationCoordinate2D(latitude: 48.8566, longitude: 2.3522), nights: 3, isStartPoint: true, hotelName: "Hotel Plaza", pricePerNight: 120),
                    EditablePlace(name: "Rome", coordinate: CLLocationCoordinate2D(latitude: 41.9028, longitude: 12.4964), nights: 3, isStartPoint: false, hotelName: "Hotel Colosseum", pricePerNight: 95),
                    EditablePlace(name: "Barcelona", coordinate: CLLocationCoordinate2D(latitude: 41.3851, longitude: 2.1734), nights: 3, isStartPoint: false, hotelName: "Hotel Sagrada", pricePerNight: 110),
                    EditablePlace(name: "Amsterdam", coordinate: CLLocationCoordinate2D(latitude: 52.3676, longitude: 4.9041), nights: 2, isStartPoint: false, hotelName: "Hotel Canal", pricePerNight: 130)
                ],
                badges: ["🏛️", "🍝", "🏰", "🎨", "🚂", "✈️"],
                totalCost: 1290,
                totalNights: 11
            )
        ),
        Adventure(
            id: "asian",
            name: "Asian Discovery",
            description: "Experience the vibrant cultures, delicious cuisines, and modern marvels of Asia's most exciting cities.",
            duration: "21 days",
            difficulty: "Medium",
            budget: "€€",
            image: "globe.asia.australia.fill",
            color: UltraLightDesignSystem.primaryOrange,
            destinations: ["Tokyo", "Seoul", "Bangkok", "Singapore"],
            highlights: ["Tokyo Skytree", "Gyeongbokgung Palace", "Grand Palace", "Marina Bay Sands"],
            routeData: AdventureRouteData(
                flights: [
                    FlightInfo(route: "Munich → Tokyo", date: "Jan 10, 2025", duration: "11h 30m", price: "€650"),
                    FlightInfo(route: "Tokyo → Seoul", date: "Jan 17, 2025", duration: "2h 15m", price: "€180"),
                    FlightInfo(route: "Seoul → Bangkok", date: "Jan 24, 2025", duration: "5h 30m", price: "€320"),
                    FlightInfo(route: "Bangkok → Singapore", date: "Jan 28, 2025", duration: "2h 15m", price: "€95")
                ],
                places: [
                    EditablePlace(name: "Tokyo", coordinate: CLLocationCoordinate2D(latitude: 35.6762, longitude: 139.6503), nights: 7, isStartPoint: true, hotelName: "Hotel Tokyo Central", pricePerNight: 85),
                    EditablePlace(name: "Seoul", coordinate: CLLocationCoordinate2D(latitude: 37.5665, longitude: 126.9780), nights: 7, isStartPoint: false, hotelName: "Hotel Gangnam", pricePerNight: 75),
                    EditablePlace(name: "Bangkok", coordinate: CLLocationCoordinate2D(latitude: 13.7563, longitude: 100.5018), nights: 4, isStartPoint: false, hotelName: "Hotel Sukhumvit", pricePerNight: 45),
                    EditablePlace(name: "Singapore", coordinate: CLLocationCoordinate2D(latitude: 1.3521, longitude: 103.8198), nights: 3, isStartPoint: false, hotelName: "Hotel Marina Bay", pricePerNight: 120)
                ],
                badges: ["🗼", "🏯", "🏛️", "🌴", "🍜", "✈️"],
                totalCost: 1895,
                totalNights: 21
            )
        ),
        Adventure(
            id: "asia_march_2026",
            name: "Asia Adventure March 2026",
            description: "Epic journey through Taiwan, Bali, Malaysia & Thailand. From Taipei's night markets to Bali's beaches, Kuala Lumpur's skyline to Bangkok's temples.",
            duration: "22 days",
            difficulty: "Medium",
            budget: "€€€",
            image: "airplane.departure",
            color: UltraLightDesignSystem.primaryOrange,
            destinations: ["Taipei", "Taichung", "Bali", "Kuala Lumpur", "Bangkok"],
            highlights: ["Taipei 101", "Taichung Night Market", "Bali Temples", "Petronas Towers", "Grand Palace Bangkok"],
            routeData: AdventureRouteData(
                flights: [
                    FlightInfo(route: "Munich → Taipei", date: "Mar 7, 2026", duration: "12h 0m", price: "€545"),
                    FlightInfo(route: "Taipei → Bali", date: "Mar 13, 2026", duration: "5h 30m", price: "€280"),
                    FlightInfo(route: "Bali → Kuala Lumpur", date: "Mar 18, 2026", duration: "2h 55m", price: "€51"),
                    FlightInfo(route: "Kuala Lumpur → Bangkok", date: "Mar 23, 2026", duration: "2h 10m", price: "€139"),
                    FlightInfo(route: "Bangkok → Munich", date: "Mar 28, 2026", duration: "11h 50m", price: "€535")
                ],
                places: [
                    EditablePlace(name: "Taichung", coordinate: CLLocationCoordinate2D(latitude: 24.1477, longitude: 120.6736), nights: 3, isStartPoint: true, hotelName: "SOF Hotel", pricePerNight: 57),
                    EditablePlace(name: "Taipei", coordinate: CLLocationCoordinate2D(latitude: 25.0330, longitude: 121.5654), nights: 2, isStartPoint: false, hotelName: "Hotel Relax 5", pricePerNight: 60),
                    EditablePlace(name: "Bali", coordinate: CLLocationCoordinate2D(latitude: -8.3405, longitude: 115.0920), nights: 5, isStartPoint: false, hotelName: "Boutique Hotel Mengwi", pricePerNight: 46),
                    EditablePlace(name: "Kuala Lumpur", coordinate: CLLocationCoordinate2D(latitude: 3.1390, longitude: 101.6869), nights: 5, isStartPoint: false, hotelName: "Sleeping Lion Suites", pricePerNight: 53),
                    EditablePlace(name: "Bangkok", coordinate: CLLocationCoordinate2D(latitude: 13.7563, longitude: 100.5018), nights: 5, isStartPoint: false, hotelName: "Rama 9 Luxury Condo", pricePerNight: 51)
                ],
                badges: ["🏮", "🏖️", "🏢", "🏛️", "🍜", "✈️"],
                totalCost: 2664,
                totalNights: 20
            )
        ),
        Adventure(
            id: "american",
            name: "American Road Trip",
            description: "The ultimate American experience from coast to coast, featuring iconic landmarks and diverse landscapes.",
            duration: "18 days",
            difficulty: "Medium",
            budget: "€€€",
            image: "car.fill",
            color: UltraLightDesignSystem.primaryOrange,
            destinations: ["New York", "Los Angeles", "Las Vegas", "San Francisco"],
            highlights: ["Statue of Liberty", "Hollywood Sign", "Strip", "Golden Gate Bridge"],
            routeData: AdventureRouteData(
                flights: [
                    FlightInfo(route: "Munich → New York", date: "Jun 1, 2025", duration: "8h 30m", price: "€420"),
                    FlightInfo(route: "New York → Los Angeles", date: "Jun 6, 2025", duration: "5h 45m", price: "€180"),
                    FlightInfo(route: "Los Angeles → Las Vegas", date: "Jun 10, 2025", duration: "1h 15m", price: "€85"),
                    FlightInfo(route: "Las Vegas → San Francisco", date: "Jun 14, 2025", duration: "1h 30m", price: "€95")
                ],
                places: [
                    EditablePlace(name: "New York", coordinate: CLLocationCoordinate2D(latitude: 40.7128, longitude: -74.0060), nights: 5, isStartPoint: true, hotelName: "Hotel Manhattan", pricePerNight: 180),
                    EditablePlace(name: "Los Angeles", coordinate: CLLocationCoordinate2D(latitude: 34.0522, longitude: -118.2437), nights: 4, isStartPoint: false, hotelName: "Hotel Hollywood", pricePerNight: 160),
                    EditablePlace(name: "Las Vegas", coordinate: CLLocationCoordinate2D(latitude: 36.1699, longitude: -115.1398), nights: 4, isStartPoint: false, hotelName: "Hotel Strip", pricePerNight: 120),
                    EditablePlace(name: "San Francisco", coordinate: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194), nights: 5, isStartPoint: false, hotelName: "Hotel Bay Area", pricePerNight: 200)
                ],
                badges: ["🗽", "🎬", "🎰", "🌉", "🚗", "✈️"],
                totalCost: 2340,
                totalNights: 18
            )
        )
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            // Fixed Header
            UltraLightWindow(
                title: "Adventures",
                subtitle: "Choose your next journey",
                style: .minimal
            ) {
                HStack {
                    Spacer()
                    Button(action: {
                        showingCreateAdventure = true
                    }) {
                        HStack(spacing: UltraLightDesignSystem.spaceXS) {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 16, weight: .semibold))
                            Text("New Adventure")
                                .font(.system(size: 14, weight: .semibold, design: .rounded))
                        }
                        .foregroundColor(UltraLightDesignSystem.primaryOrange)
                        .padding(.horizontal, UltraLightDesignSystem.spaceM)
                        .padding(.vertical, UltraLightDesignSystem.spaceS)
                        .background(UltraLightDesignSystem.primaryOrange.opacity(0.1))
                        .cornerRadius(UltraLightDesignSystem.radiusM)
                    }
                }
            }
            .padding(.horizontal, UltraLightDesignSystem.spaceM)
            .padding(.top, UltraLightDesignSystem.spaceM)
            
            // Scrollable Adventures Grid
            ScrollView {
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: UltraLightDesignSystem.spaceM) {
                    ForEach(adventures) { adventure in
                        UltraLightAdventureCard(
                            adventure: adventure,
                            onEdit: {
                                showingEditAdventure = adventure
                            },
                            onDelete: {
                                showingDeleteConfirmation = adventure
                            }
                        )
                        .onTapGesture {
                            selectedAdventure = adventure
                            showingRoutesSubmenu = true
                        }
                    }
                }
                .padding(.horizontal, UltraLightDesignSystem.spaceM)
                .padding(.top, UltraLightDesignSystem.spaceM)
            }
        }
        .sheet(isPresented: $showingRouteDetail) {
            if let adventure = selectedAdventure {
                UltraLightAdventureDetailView(adventure: adventure, isPresented: $showingRouteDetail)
            }
        }
        .sheet(isPresented: $showingRoutesSubmenu) {
            if let adventure = selectedAdventure {
                UltraLightRoutesSubmenuView(adventure: adventure)
            }
        }
        .sheet(isPresented: $showingCreateAdventure) {
            UltraLightCreateAdventureView { newAdventure in
                adventures.append(newAdventure)
            }
        }
        .sheet(item: $showingEditAdventure) { adventure in
            UltraLightEditAdventureView(adventure: adventure) { updatedAdventure in
                if let index = adventures.firstIndex(where: { $0.id == adventure.id }) {
                    adventures[index] = updatedAdventure
                }
            }
        }
        .alert("Adventure löschen", isPresented: .constant(showingDeleteConfirmation != nil)) {
            Button("Abbrechen", role: .cancel) {
                showingDeleteConfirmation = nil
            }
            Button("Löschen", role: .destructive) {
                if let adventure = showingDeleteConfirmation {
                    deleteAdventure(adventure)
                }
                showingDeleteConfirmation = nil
            }
        } message: {
            if let adventure = showingDeleteConfirmation {
                Text("Bist du sicher, dass du '\(adventure.name)' löschen möchtest? Diese Aktion kann nicht rückgängig gemacht werden.")
            }
        }
    }
    
    private func deleteAdventure(_ adventure: Adventure) {
        adventures.removeAll { $0.id == adventure.id }
    }
    
    private func openAppleMapsWithRoute() {
        // European Adventure route coordinates
        let paris = "48.8566,2.3522" // Paris
        let rome = "41.9028,12.4964" // Rome
        let barcelona = "41.3851,2.1734" // Barcelona
        let amsterdam = "52.3676,4.9041" // Amsterdam
        
        // Create Apple Maps URL with multiple destinations
        let mapsURL = "http://maps.apple.com/?saddr=\(paris)&daddr=\(rome)&daddr=\(barcelona)&daddr=\(amsterdam)&dirflg=d"
        
        if let url = URL(string: mapsURL) {
            UIApplication.shared.open(url)
        }
    }
}

// MARK: - Adventure Data Model
struct Adventure: Identifiable {
    let id: String
    let name: String
    let description: String
    let duration: String
    let difficulty: String
    let budget: String
    let image: String
    let color: Color
    let destinations: [String]
    let highlights: [String]
    let routeData: AdventureRouteData
}

struct AdventureRouteData {
    let flights: [FlightInfo]
    let places: [EditablePlace]
    let badges: [String]
    let totalCost: Int
    let totalNights: Int
}

struct FlightInfo: Identifiable {
    let id = UUID()
    let route: String
    let date: String
    let duration: String
    let price: String
}

// MARK: - Adventure Card
struct UltraLightAdventureCard: View {
    let adventure: Adventure
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        UltraLightWindow(style: .standard) {
            VStack(alignment: .leading, spacing: UltraLightDesignSystem.spaceL) {
                // Header with Icon
                HStack {
                    ZStack {
                        Circle()
                            .fill(adventure.color.opacity(0.15))
                            .frame(width: 36, height: 36)
                        
                        Image(systemName: adventure.image)
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(adventure.color)
                    }
                    
                    Spacer()
                    
                    Text(adventure.difficulty)
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundColor(UltraLightDesignSystem.textSecondary)
                        .padding(.horizontal, UltraLightDesignSystem.spaceS)
                        .padding(.vertical, UltraLightDesignSystem.spaceXS)
                        .background(UltraLightDesignSystem.surface)
                        .cornerRadius(UltraLightDesignSystem.radiusS)
                }
                
                // Title and Description
                VStack(alignment: .leading, spacing: UltraLightDesignSystem.spaceXS) {
                    Text(adventure.name)
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(UltraLightDesignSystem.text)
                        .lineLimit(2)
                    
                    Text(adventure.description)
                        .font(.system(size: 13, weight: .medium, design: .rounded))
                        .foregroundColor(UltraLightDesignSystem.textSecondary)
                        .lineLimit(3)
                }
                
                // Stats
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(adventure.duration)
                            .font(.system(size: 12, weight: .semibold, design: .rounded))
                            .foregroundColor(UltraLightDesignSystem.text)
                        
                        Text("Duration")
                            .font(.system(size: 10, weight: .medium, design: .rounded))
                            .foregroundColor(UltraLightDesignSystem.textSecondary)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 2) {
                        Text(adventure.budget)
                            .font(.system(size: 12, weight: .semibold, design: .rounded))
                            .foregroundColor(adventure.color)
                        
                        Text("Budget")
                            .font(.system(size: 10, weight: .medium, design: .rounded))
                            .foregroundColor(UltraLightDesignSystem.textSecondary)
                    }
                }
                
                // Destinations Preview
                HStack {
                    ForEach(Array(adventure.destinations.prefix(3)), id: \.self) { destination in
                        Text(destination)
                            .font(.system(size: 10, weight: .medium, design: .rounded))
                            .foregroundColor(UltraLightDesignSystem.textSecondary)
                            .padding(.horizontal, UltraLightDesignSystem.spaceXS)
                            .padding(.vertical, 2)
                            .background(UltraLightDesignSystem.surface)
                            .cornerRadius(UltraLightDesignSystem.radiusS)
                    }
                    
                    if adventure.destinations.count > 3 {
                        Text("+\(adventure.destinations.count - 3)")
                            .font(.system(size: 10, weight: .medium, design: .rounded))
                            .foregroundColor(UltraLightDesignSystem.textTertiary)
                    }
                    
                    Spacer()
                }
                
                // Action Buttons
                HStack(spacing: UltraLightDesignSystem.spaceS) {
                    Button(action: onEdit) {
                        HStack(spacing: UltraLightDesignSystem.spaceXS) {
                            Image(systemName: "pencil.circle.fill")
                                .font(.system(size: 14))
                            Text("Edit")
                                .font(.system(size: 12, weight: .medium, design: .rounded))
                        }
                        .foregroundColor(UltraLightDesignSystem.primaryOrange)
                        .padding(.horizontal, UltraLightDesignSystem.spaceS)
                        .padding(.vertical, UltraLightDesignSystem.spaceXS)
                        .background(UltraLightDesignSystem.primaryOrange.opacity(0.1))
                        .cornerRadius(UltraLightDesignSystem.radiusS)
                    }
                    
                    Button(action: onDelete) {
                        HStack(spacing: UltraLightDesignSystem.spaceXS) {
                            Image(systemName: "trash.circle.fill")
                                .font(.system(size: 14))
                            Text("Delete")
                                .font(.system(size: 12, weight: .medium, design: .rounded))
                        }
                        .foregroundColor(.red)
                        .padding(.horizontal, UltraLightDesignSystem.spaceS)
                        .padding(.vertical, UltraLightDesignSystem.spaceXS)
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(UltraLightDesignSystem.radiusS)
                    }
                    
                    Spacer()
                }
            }
        }
    }
}

// MARK: - Adventure Detail View
struct UltraLightAdventureDetailView: View {
    let adventure: Adventure
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationView {
            ZStack {
                UltraLightDesignSystem.background
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: UltraLightDesignSystem.spaceM) {
                        // Header
                        UltraLightWindow(
                            title: adventure.name,
                            subtitle: adventure.description,
                            style: .premium
                        ) {
                            VStack(spacing: UltraLightDesignSystem.spaceM) {
                                // Adventure Stats
                                HStack(spacing: UltraLightDesignSystem.spaceL) {
                                    StatCard(title: "Duration", value: adventure.duration, icon: "clock")
                                    StatCard(title: "Difficulty", value: adventure.difficulty, icon: "star")
                                    StatCard(title: "Budget", value: adventure.budget, icon: "eurosign.circle")
                                }
                                
                                // Highlights
                                VStack(alignment: .leading, spacing: UltraLightDesignSystem.spaceS) {
                                    Text("Highlights")
                                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                                        .foregroundColor(UltraLightDesignSystem.text)
                                    
                                    LazyVGrid(columns: [
                                        GridItem(.flexible()),
                                        GridItem(.flexible())
                                    ], spacing: UltraLightDesignSystem.spaceS) {
                                        ForEach(adventure.highlights, id: \.self) { highlight in
                                            HStack(spacing: UltraLightDesignSystem.spaceXS) {
                                                Image(systemName: "star.fill")
                                                    .font(.system(size: 12))
                                                    .foregroundColor(UltraLightDesignSystem.accentGold)
                                                
                                                Text(highlight)
                                                    .font(.system(size: 13, weight: .medium, design: .rounded))
                                                    .foregroundColor(UltraLightDesignSystem.text)
                                                    .lineLimit(2)
                                                
                                                Spacer()
                                            }
                                            .padding(UltraLightDesignSystem.spaceS)
                                            .background(UltraLightDesignSystem.surface)
                                            .cornerRadius(UltraLightDesignSystem.radiusM)
                                        }
                                    }
                                }
                            }
                        }
                        
                        // Destinations
                        UltraLightWindow(
                            title: "Destinations",
                            style: .standard
                        ) {
                            VStack(spacing: UltraLightDesignSystem.spaceS) {
                                ForEach(Array(adventure.destinations.enumerated()), id: \.offset) { index, destination in
                                    HStack {
                                        Text("\(index + 1)")
                                            .font(.system(size: 14, weight: .bold, design: .rounded))
                                            .foregroundColor(UltraLightDesignSystem.primaryOrange)
                                            .frame(width: 24, height: 24)
                                            .background(UltraLightDesignSystem.primaryOrange.opacity(0.2))
                                            .cornerRadius(12)
                                        
                                        Text(destination)
                                            .font(.system(size: 16, weight: .medium, design: .rounded))
                                            .foregroundColor(UltraLightDesignSystem.text)
                                        
                                        Spacer()
                                    }
                                    .padding(.vertical, UltraLightDesignSystem.spaceXS)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, UltraLightDesignSystem.spaceM)
                    .padding(.top, UltraLightDesignSystem.spaceM)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        isPresented = false
                    }
                    .foregroundColor(UltraLightDesignSystem.primaryOrange)
                }
            }
        }
    }
}

// MARK: - Create Adventure View
struct UltraLightCreateAdventureView: View {
    @Environment(\.dismiss) private var dismiss
    let onSave: (Adventure) -> Void
    
    @State private var name = ""
    @State private var description = ""
    @State private var duration = "7 days"
    @State private var difficulty = "Easy"
    @State private var budget = "€€"
    @State private var selectedImage = "airplane.departure"
    @State private var selectedColor = UltraLightDesignSystem.primaryOrange
    
    let availableImages = ["airplane.departure", "globe.asia.australia.fill", "europe.africa.fill", "car.fill", "map.fill", "location.fill"]
    let availableDifficulties = ["Easy", "Medium", "Hard"]
    let availableBudgets = ["€", "€€", "€€€"]
    let availableColors = [UltraLightDesignSystem.primaryOrange, .blue, .green, .purple, .red, .pink]
    
    var body: some View {
        NavigationView {
            ZStack {
                UltraLightDesignSystem.background
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: UltraLightDesignSystem.spaceL) {
                        // Basic Info
                        UltraLightWindow(
                            title: "Adventure Details",
                            style: .standard
                        ) {
                            VStack(spacing: UltraLightDesignSystem.spaceL) {
                                // Name
                                VStack(alignment: .leading, spacing: UltraLightDesignSystem.spaceS) {
                                    Text("Adventure Name")
                                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                                        .foregroundColor(UltraLightDesignSystem.textSecondary)
                                    
                                    TextField("Enter adventure name", text: $name)
                                        .padding(UltraLightDesignSystem.spaceM)
                                        .background(UltraLightDesignSystem.surface)
                                        .cornerRadius(UltraLightDesignSystem.radiusM)
                                        .foregroundColor(UltraLightDesignSystem.text)
                                }
                                
                                // Description
                                VStack(alignment: .leading, spacing: UltraLightDesignSystem.spaceS) {
                                    Text("Description")
                                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                                        .foregroundColor(UltraLightDesignSystem.textSecondary)
                                    
                                    TextField("Enter adventure description", text: $description)
                                        .lineLimit(3)
                                        .padding(UltraLightDesignSystem.spaceM)
                                        .background(UltraLightDesignSystem.surface)
                                        .cornerRadius(UltraLightDesignSystem.radiusM)
                                        .foregroundColor(UltraLightDesignSystem.text)
                                }
                                
                                // Duration
                                VStack(alignment: .leading, spacing: UltraLightDesignSystem.spaceS) {
                                    Text("Duration")
                                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                                        .foregroundColor(UltraLightDesignSystem.textSecondary)
                                    
                                    TextField("Enter duration", text: $duration)
                                        .padding(UltraLightDesignSystem.spaceM)
                                        .background(UltraLightDesignSystem.surface)
                                        .cornerRadius(UltraLightDesignSystem.radiusM)
                                        .foregroundColor(UltraLightDesignSystem.text)
                                }
                            }
                        }
                        
                        // Settings
                        UltraLightWindow(
                            title: "Adventure Settings",
                            style: .standard
                        ) {
                            VStack(spacing: UltraLightDesignSystem.spaceL) {
                                // Difficulty
                                VStack(alignment: .leading, spacing: UltraLightDesignSystem.spaceS) {
                                    Text("Difficulty")
                                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                                        .foregroundColor(UltraLightDesignSystem.textSecondary)
                                    
                                    HStack(spacing: UltraLightDesignSystem.spaceS) {
                                        ForEach(availableDifficulties, id: \.self) { diff in
                                            Button(action: {
                                                difficulty = diff
                                            }) {
                                                Text(diff)
                                                    .font(.system(size: 12, weight: .medium, design: .rounded))
                                                    .foregroundColor(difficulty == diff ? .white : UltraLightDesignSystem.textSecondary)
                                                    .padding(.horizontal, UltraLightDesignSystem.spaceM)
                                                    .padding(.vertical, UltraLightDesignSystem.spaceS)
                                                    .background(difficulty == diff ? UltraLightDesignSystem.primaryOrange : UltraLightDesignSystem.surface)
                                                    .cornerRadius(UltraLightDesignSystem.radiusS)
                                            }
                                        }
                                    }
                                }
                                
                                // Budget
                                VStack(alignment: .leading, spacing: UltraLightDesignSystem.spaceS) {
                                    Text("Budget")
                                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                                        .foregroundColor(UltraLightDesignSystem.textSecondary)
                                    
                                    HStack(spacing: UltraLightDesignSystem.spaceS) {
                                        ForEach(availableBudgets, id: \.self) { bud in
                                            Button(action: {
                                                budget = bud
                                            }) {
                                                Text(bud)
                                                    .font(.system(size: 12, weight: .medium, design: .rounded))
                                                    .foregroundColor(budget == bud ? .white : UltraLightDesignSystem.textSecondary)
                                                    .padding(.horizontal, UltraLightDesignSystem.spaceM)
                                                    .padding(.vertical, UltraLightDesignSystem.spaceS)
                                                    .background(budget == bud ? UltraLightDesignSystem.primaryOrange : UltraLightDesignSystem.surface)
                                                    .cornerRadius(UltraLightDesignSystem.radiusS)
                                            }
                                        }
                                    }
                                }
                                
                                // Icon
                                VStack(alignment: .leading, spacing: UltraLightDesignSystem.spaceS) {
                                    Text("Icon")
                                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                                        .foregroundColor(UltraLightDesignSystem.textSecondary)
                                    
                                    LazyVGrid(columns: [
                                        GridItem(.flexible()),
                                        GridItem(.flexible()),
                                        GridItem(.flexible())
                                    ], spacing: UltraLightDesignSystem.spaceS) {
                                        ForEach(availableImages, id: \.self) { image in
                                            Button(action: {
                                                selectedImage = image
                                            }) {
                                                Image(systemName: image)
                                                    .font(.system(size: 20))
                                                    .foregroundColor(selectedImage == image ? .white : UltraLightDesignSystem.textSecondary)
                                                    .frame(width: 44, height: 44)
                                                    .background(selectedImage == image ? UltraLightDesignSystem.primaryOrange : UltraLightDesignSystem.surface)
                                                    .cornerRadius(UltraLightDesignSystem.radiusM)
                                            }
                                        }
                                    }
                                }
                                
                                // Color
                                VStack(alignment: .leading, spacing: UltraLightDesignSystem.spaceS) {
                                    Text("Color")
                                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                                        .foregroundColor(UltraLightDesignSystem.textSecondary)
                                    
                                    HStack(spacing: UltraLightDesignSystem.spaceS) {
                                        ForEach(availableColors, id: \.self) { color in
                                            Button(action: {
                                                selectedColor = color
                                            }) {
                                                Circle()
                                                    .fill(color)
                                                    .frame(width: 32, height: 32)
                                                    .overlay(
                                                        Circle()
                                                            .stroke(selectedColor == color ? .white : Color.clear, lineWidth: 2)
                                                    )
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding(UltraLightDesignSystem.spaceL)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(UltraLightDesignSystem.primaryOrange)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Create") {
                        let newAdventure = Adventure(
                            id: UUID().uuidString,
                            name: name,
                            description: description,
                            duration: duration,
                            difficulty: difficulty,
                            budget: budget,
                            image: selectedImage,
                            color: selectedColor,
                            destinations: ["New Destination"],
                            highlights: ["New Highlight"],
                            routeData: AdventureRouteData(
                                flights: [],
                                places: [],
                                badges: ["🎯"],
                                totalCost: 0,
                                totalNights: 0
                            )
                        )
                        onSave(newAdventure)
                        dismiss()
                    }
                    .foregroundColor(UltraLightDesignSystem.primaryOrange)
                    .disabled(name.isEmpty || description.isEmpty)
                }
            }
        }
    }
}

// MARK: - Edit Adventure View
struct UltraLightEditAdventureView: View {
    @Environment(\.dismiss) private var dismiss
    let adventure: Adventure
    let onSave: (Adventure) -> Void
    
    @State private var name: String
    @State private var description: String
    @State private var duration: String
    @State private var difficulty: String
    @State private var budget: String
    @State private var selectedImage: String
    @State private var selectedColor: Color
    
    let availableImages = ["airplane.departure", "globe.asia.australia.fill", "europe.africa.fill", "car.fill", "map.fill", "location.fill"]
    let availableDifficulties = ["Easy", "Medium", "Hard"]
    let availableBudgets = ["€", "€€", "€€€"]
    let availableColors = [UltraLightDesignSystem.primaryOrange, .blue, .green, .purple, .red, .pink]
    
    init(adventure: Adventure, onSave: @escaping (Adventure) -> Void) {
        self.adventure = adventure
        self.onSave = onSave
        self._name = State(initialValue: adventure.name)
        self._description = State(initialValue: adventure.description)
        self._duration = State(initialValue: adventure.duration)
        self._difficulty = State(initialValue: adventure.difficulty)
        self._budget = State(initialValue: adventure.budget)
        self._selectedImage = State(initialValue: adventure.image)
        self._selectedColor = State(initialValue: adventure.color)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                UltraLightDesignSystem.background
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: UltraLightDesignSystem.spaceL) {
                        // Basic Info
                        UltraLightWindow(
                            title: "Edit Adventure",
                            style: .standard
                        ) {
                            VStack(spacing: UltraLightDesignSystem.spaceL) {
                                // Name
                                VStack(alignment: .leading, spacing: UltraLightDesignSystem.spaceS) {
                                    Text("Adventure Name")
                                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                                        .foregroundColor(UltraLightDesignSystem.textSecondary)
                                    
                                    TextField("Enter adventure name", text: $name)
                                        .padding(UltraLightDesignSystem.spaceM)
                                        .background(UltraLightDesignSystem.surface)
                                        .cornerRadius(UltraLightDesignSystem.radiusM)
                                        .foregroundColor(UltraLightDesignSystem.text)
                                }
                                
                                // Description
                                VStack(alignment: .leading, spacing: UltraLightDesignSystem.spaceS) {
                                    Text("Description")
                                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                                        .foregroundColor(UltraLightDesignSystem.textSecondary)
                                    
                                    TextField("Enter adventure description", text: $description)
                                        .lineLimit(3)
                                        .padding(UltraLightDesignSystem.spaceM)
                                        .background(UltraLightDesignSystem.surface)
                                        .cornerRadius(UltraLightDesignSystem.radiusM)
                                        .foregroundColor(UltraLightDesignSystem.text)
                                }
                                
                                // Duration
                                VStack(alignment: .leading, spacing: UltraLightDesignSystem.spaceS) {
                                    Text("Duration")
                                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                                        .foregroundColor(UltraLightDesignSystem.textSecondary)
                                    
                                    TextField("Enter duration", text: $duration)
                                        .padding(UltraLightDesignSystem.spaceM)
                                        .background(UltraLightDesignSystem.surface)
                                        .cornerRadius(UltraLightDesignSystem.radiusM)
                                        .foregroundColor(UltraLightDesignSystem.text)
                                }
                            }
                        }
                        
                        // Settings
                        UltraLightWindow(
                            title: "Adventure Settings",
                            style: .standard
                        ) {
                            VStack(spacing: UltraLightDesignSystem.spaceL) {
                                // Difficulty
                                VStack(alignment: .leading, spacing: UltraLightDesignSystem.spaceS) {
                                    Text("Difficulty")
                                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                                        .foregroundColor(UltraLightDesignSystem.textSecondary)
                                    
                                    HStack(spacing: UltraLightDesignSystem.spaceS) {
                                        ForEach(availableDifficulties, id: \.self) { diff in
                                            Button(action: {
                                                difficulty = diff
                                            }) {
                                                Text(diff)
                                                    .font(.system(size: 12, weight: .medium, design: .rounded))
                                                    .foregroundColor(difficulty == diff ? .white : UltraLightDesignSystem.textSecondary)
                                                    .padding(.horizontal, UltraLightDesignSystem.spaceM)
                                                    .padding(.vertical, UltraLightDesignSystem.spaceS)
                                                    .background(difficulty == diff ? UltraLightDesignSystem.primaryOrange : UltraLightDesignSystem.surface)
                                                    .cornerRadius(UltraLightDesignSystem.radiusS)
                                            }
                                        }
                                    }
                                }
                                
                                // Budget
                                VStack(alignment: .leading, spacing: UltraLightDesignSystem.spaceS) {
                                    Text("Budget")
                                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                                        .foregroundColor(UltraLightDesignSystem.textSecondary)
                                    
                                    HStack(spacing: UltraLightDesignSystem.spaceS) {
                                        ForEach(availableBudgets, id: \.self) { bud in
                                            Button(action: {
                                                budget = bud
                                            }) {
                                                Text(bud)
                                                    .font(.system(size: 12, weight: .medium, design: .rounded))
                                                    .foregroundColor(budget == bud ? .white : UltraLightDesignSystem.textSecondary)
                                                    .padding(.horizontal, UltraLightDesignSystem.spaceM)
                                                    .padding(.vertical, UltraLightDesignSystem.spaceS)
                                                    .background(budget == bud ? UltraLightDesignSystem.primaryOrange : UltraLightDesignSystem.surface)
                                                    .cornerRadius(UltraLightDesignSystem.radiusS)
                                            }
                                        }
                                    }
                                }
                                
                                // Icon
                                VStack(alignment: .leading, spacing: UltraLightDesignSystem.spaceS) {
                                    Text("Icon")
                                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                                        .foregroundColor(UltraLightDesignSystem.textSecondary)
                                    
                                    LazyVGrid(columns: [
                                        GridItem(.flexible()),
                                        GridItem(.flexible()),
                                        GridItem(.flexible())
                                    ], spacing: UltraLightDesignSystem.spaceS) {
                                        ForEach(availableImages, id: \.self) { image in
                                            Button(action: {
                                                selectedImage = image
                                            }) {
                                                Image(systemName: image)
                                                    .font(.system(size: 20))
                                                    .foregroundColor(selectedImage == image ? .white : UltraLightDesignSystem.textSecondary)
                                                    .frame(width: 44, height: 44)
                                                    .background(selectedImage == image ? UltraLightDesignSystem.primaryOrange : UltraLightDesignSystem.surface)
                                                    .cornerRadius(UltraLightDesignSystem.radiusM)
                                            }
                                        }
                                    }
                                }
                                
                                // Color
                                VStack(alignment: .leading, spacing: UltraLightDesignSystem.spaceS) {
                                    Text("Color")
                                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                                        .foregroundColor(UltraLightDesignSystem.textSecondary)
                                    
                                    HStack(spacing: UltraLightDesignSystem.spaceS) {
                                        ForEach(availableColors, id: \.self) { color in
                                            Button(action: {
                                                selectedColor = color
                                            }) {
                                                Circle()
                                                    .fill(color)
                                                    .frame(width: 32, height: 32)
                                                    .overlay(
                                                        Circle()
                                                            .stroke(selectedColor == color ? .white : Color.clear, lineWidth: 2)
                                                    )
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding(UltraLightDesignSystem.spaceL)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(UltraLightDesignSystem.primaryOrange)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        let updatedAdventure = Adventure(
                            id: adventure.id,
                            name: name,
                            description: description,
                            duration: duration,
                            difficulty: difficulty,
                            budget: budget,
                            image: selectedImage,
                            color: selectedColor,
                            destinations: adventure.destinations,
                            highlights: adventure.highlights,
                            routeData: adventure.routeData
                        )
                        onSave(updatedAdventure)
                        dismiss()
                    }
                    .foregroundColor(UltraLightDesignSystem.primaryOrange)
                    .disabled(name.isEmpty || description.isEmpty)
                }
            }
        }
    }
}

// MARK: - Routes Submenu View
struct UltraLightRoutesSubmenuView: View {
    @Environment(\.dismiss) private var dismiss
    let adventure: Adventure
    
    var body: some View {
        NavigationView {
            ZStack {
                UltraLightDesignSystem.background
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: UltraLightDesignSystem.spaceM) {
                        // Header
                        UltraLightWindow(
                            title: adventure.name,
                            subtitle: "Hotels, flights & more",
                            style: .minimal
                        ) {
                            EmptyView()
                        }
                        
                        // Large Travel Overview Card - Hotels & Locations
                        UltraLightTravelOverviewCard(adventure: adventure)
                        
                        // Flight Tickets Card
                        UltraLightWindow(
                            title: "Flight Tickets",
                            subtitle: "Your upcoming flights",
                            style: .standard
                        ) {
                            VStack(spacing: UltraLightDesignSystem.spaceM) {
                                ForEach(adventure.routeData.flights) { flight in
                                    HStack {
                                        VStack(alignment: .leading, spacing: UltraLightDesignSystem.spaceXS) {
                                            Text(flight.route)
                                                .font(.system(size: 16, weight: .semibold, design: .rounded))
                                                .foregroundColor(UltraLightDesignSystem.text)
                                            
                                            Text("\(flight.date) • \(flight.duration)")
                                                .font(.system(size: 14, weight: .medium, design: .rounded))
                                                .foregroundColor(UltraLightDesignSystem.textSecondary)
                                        }
                                        
                                        Spacer()
                                        
                                        Text(flight.price)
                                            .font(.system(size: 18, weight: .bold, design: .rounded))
                                            .foregroundColor(UltraLightDesignSystem.primaryOrange)
                                    }
                                }
                            }
                        }
                        
                        // Locations List Card
                        UltraLightWindow(
                            title: "Places to Visit",
                            subtitle: "Your planned destinations",
                            style: .standard
                        ) {
                            VStack(spacing: UltraLightDesignSystem.spaceS) {
                                ForEach(adventure.routeData.places) { place in
                                    HStack {
                                        Image(systemName: place.isStartPoint ? "play.circle.fill" : "location.fill")
                                            .foregroundColor(UltraLightDesignSystem.primaryOrange)
                                            .font(.system(size: 16))
                                        
                                        Text(place.name)
                                            .font(.system(size: 16, weight: .medium, design: .rounded))
                                            .foregroundColor(UltraLightDesignSystem.text)
                                        
                                        Spacer()
                                        
                                        Text("\(place.nights) days")
                                            .font(.system(size: 14, weight: .medium, design: .rounded))
                                            .foregroundColor(UltraLightDesignSystem.textSecondary)
                                    }
                                    .padding(.vertical, UltraLightDesignSystem.spaceXS)
                                }
                            }
                        }
                        
                        // Flight Time Stats Card
                        UltraLightWindow(
                            title: "Trip Statistics",
                            subtitle: "Your travel overview",
                            style: .standard
                        ) {
                            HStack(spacing: UltraLightDesignSystem.spaceL) {
                                VStack(spacing: UltraLightDesignSystem.spaceXS) {
                                    Text("\(adventure.routeData.flights.count)")
                                        .font(.system(size: 24, weight: .bold, design: .rounded))
                                        .foregroundColor(UltraLightDesignSystem.primaryOrange)
                                    
                                    Text("Flights")
                                        .font(.system(size: 12, weight: .medium, design: .rounded))
                                        .foregroundColor(UltraLightDesignSystem.textSecondary)
                                }
                                
                                VStack(spacing: UltraLightDesignSystem.spaceXS) {
                                    Text("\(adventure.routeData.places.count)")
                                        .font(.system(size: 24, weight: .bold, design: .rounded))
                                        .foregroundColor(UltraLightDesignSystem.primaryOrange)
                                    
                                    Text("Destinations")
                                        .font(.system(size: 12, weight: .medium, design: .rounded))
                                        .foregroundColor(UltraLightDesignSystem.textSecondary)
                                }
                                
                                VStack(spacing: UltraLightDesignSystem.spaceXS) {
                                    Text("\(adventure.routeData.totalNights)")
                                        .font(.system(size: 24, weight: .bold, design: .rounded))
                                        .foregroundColor(UltraLightDesignSystem.primaryOrange)
                                    
                                    Text("Nights Total")
                                        .font(.system(size: 12, weight: .medium, design: .rounded))
                                        .foregroundColor(UltraLightDesignSystem.textSecondary)
                                }
                            }
                        }
                        
                        // Collectible Badges Card
                        UltraLightWindow(
                            title: "Collectible Badges",
                            subtitle: "Earn achievements on your journey",
                            style: .standard
                        ) {
                            LazyVGrid(columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: UltraLightDesignSystem.spaceM) {
                                ForEach(adventure.routeData.badges, id: \.self) { badge in
                                    VStack(spacing: UltraLightDesignSystem.spaceXS) {
                                        Text(badge)
                                            .font(.system(size: 32))
                                        
                                        Text("Earned")
                                            .font(.system(size: 10, weight: .medium, design: .rounded))
                                            .foregroundColor(UltraLightDesignSystem.primaryOrange)
                                    }
                                    .frame(height: 60)
                                    .frame(maxWidth: .infinity)
                                    .background(UltraLightDesignSystem.surface)
                                    .cornerRadius(UltraLightDesignSystem.radiusM)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, UltraLightDesignSystem.spaceM)
                    .padding(.top, UltraLightDesignSystem.spaceM)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundColor(UltraLightDesignSystem.primaryOrange)
                }
            }
        }
    }
}

// MARK: - Editable Place Model
struct EditablePlace: Identifiable, Equatable {
    let id = UUID()
    var name: String
    var coordinate: CLLocationCoordinate2D
    var nights: Int
    var isStartPoint: Bool
    var hotelName: String
    var pricePerNight: Int
    
    static func == (lhs: EditablePlace, rhs: EditablePlace) -> Bool {
        return lhs.id == rhs.id
    }
}

// MARK: - Editable Place Card
struct EditablePlaceCard: View {
    let place: EditablePlace
    let index: Int
    let onNightsChanged: (Int) -> Void
    let onStartPointChanged: (Bool) -> Void
    let onEdit: () -> Void
    let onDelete: () -> Void
    let onInsert: () -> Void
    
    var body: some View {
        HStack(spacing: UltraLightDesignSystem.spaceL) {
            // Left side - Place info
            VStack(alignment: .leading, spacing: UltraLightDesignSystem.spaceS) {
                HStack {
                    // Start point indicator
                    if place.isStartPoint {
                        Image(systemName: "play.circle.fill")
                            .foregroundColor(UltraLightDesignSystem.primaryOrange)
                            .font(.system(size: 16))
                    } else {
                        Image(systemName: "bed.double.fill")
                            .foregroundColor(UltraLightDesignSystem.primaryOrange)
                            .font(.system(size: 16))
                    }
                    
                    Text(place.name)
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundColor(UltraLightDesignSystem.text)
                    
                    Spacer()
                }
                
                Text(place.hotelName)
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundColor(UltraLightDesignSystem.textSecondary)
                
                HStack {
                    Text("€\(place.pricePerNight)/night")
                        .font(.system(size: 12, weight: .bold, design: .rounded))
                        .foregroundColor(UltraLightDesignSystem.primaryOrange)
                    
                    Spacer()
                }
            }
            
            // Right side - Nights display and actions
            VStack(spacing: UltraLightDesignSystem.spaceS) {
                // Nights display (read-only)
                VStack(spacing: UltraLightDesignSystem.spaceXS) {
                    Text("Nights")
                        .font(.system(size: 10, weight: .medium, design: .rounded))
                        .foregroundColor(UltraLightDesignSystem.textSecondary)
                    
                    Text("\(place.nights)")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(UltraLightDesignSystem.primaryOrange)
                        .frame(minWidth: 30)
                }
                
                // Action buttons
                HStack(spacing: UltraLightDesignSystem.spaceXS) {
                    // Start point toggle
                    Button(action: {
                        onStartPointChanged(!place.isStartPoint)
                    }) {
                        Image(systemName: place.isStartPoint ? "play.circle.fill" : "play.circle")
                            .font(.system(size: 14))
                            .foregroundColor(place.isStartPoint ? UltraLightDesignSystem.primaryOrange : UltraLightDesignSystem.textSecondary)
                    }
                    
                    // Edit button
                    Button(action: onEdit) {
                        Image(systemName: "pencil.circle")
                            .font(.system(size: 14))
                            .foregroundColor(UltraLightDesignSystem.primaryOrange)
                    }
                    
                    // Insert button
                    Button(action: onInsert) {
                        Image(systemName: "plus.circle")
                            .font(.system(size: 14))
                            .foregroundColor(UltraLightDesignSystem.primaryOrange)
                    }
                    
                    // Delete button
                    Button(action: onDelete) {
                        Image(systemName: "trash.circle")
                            .font(.system(size: 14))
                            .foregroundColor(.red)
                    }
                }
            }
        }
        .padding(UltraLightDesignSystem.spaceL)
        .background(UltraLightDesignSystem.surface)
        .cornerRadius(UltraLightDesignSystem.radiusL)
        .overlay(
            RoundedRectangle(cornerRadius: UltraLightDesignSystem.radiusL)
                .stroke(place.isStartPoint ? UltraLightDesignSystem.primaryOrange.opacity(0.3) : Color.clear, lineWidth: 1)
        )
    }
}

// MARK: - Map Annotation
struct TravelMapAnnotation: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
    let title: String
    let subtitle: String
    let icon: String
}

// MARK: - Travel Overview Card
struct UltraLightTravelOverviewCard: View {
    let adventure: Adventure
    
    @State private var region: MKCoordinateRegion
    @State private var places: [EditablePlace]
    
    init(adventure: Adventure) {
        self.adventure = adventure
        self._places = State(initialValue: adventure.routeData.places)
        
        // Calculate center and span based on places
        let latitudes = adventure.routeData.places.map { $0.coordinate.latitude }
        let longitudes = adventure.routeData.places.map { $0.coordinate.longitude }
        
        let centerLat = (latitudes.max()! + latitudes.min()!) / 2
        let centerLon = (longitudes.max()! + longitudes.min()!) / 2
        
        let latDelta = max((latitudes.max()! - latitudes.min()!) * 1.5, 5.0)
        let lonDelta = max((longitudes.max()! - longitudes.min()!) * 1.5, 5.0)
        
        self._region = State(initialValue: MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: centerLat, longitude: centerLon),
            span: MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
        ))
    }
    
    @State private var showingAddPlace = false
    @State private var showingEditPlace: EditablePlace?
    
    var mapAnnotations: [TravelMapAnnotation] {
        places.map { place in
            TravelMapAnnotation(
                coordinate: place.coordinate,
                title: place.name,
                subtitle: place.hotelName,
                icon: place.isStartPoint ? "play.circle.fill" : "bed.double.fill"
            )
        }
    }
    
    
    var body: some View {
        UltraLightWindow(
            title: "Travel Overview",
            subtitle: "Hotels & Locations",
            style: .premium
        ) {
            VStack(spacing: UltraLightDesignSystem.spaceXL) {
                // Map Preview Section
                VStack(spacing: UltraLightDesignSystem.spaceL) {
                    HStack {
                        Text("Route Map")
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                            .foregroundColor(UltraLightDesignSystem.text)
                        
                        Spacer()
                        
                        Button(action: {}) {
                            Text("View Full Map")
                                .font(.system(size: 14, weight: .medium, design: .rounded))
                                .foregroundColor(UltraLightDesignSystem.primaryOrange)
                        }
                    }
                    
                    // Interactive Apple Map
                    Map(coordinateRegion: $region, annotationItems: mapAnnotations) { annotation in
                        MapAnnotation(coordinate: annotation.coordinate) {
                            VStack(spacing: 2) {
                                ZStack {
                                    Circle()
                                        .fill(UltraLightDesignSystem.primaryOrange)
                                        .frame(width: 32, height: 32)
                                    
                                    Image(systemName: annotation.icon)
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(.white)
                                }
                                
                                VStack(spacing: 1) {
                                    Text(annotation.title)
                                        .font(.system(size: 10, weight: .bold, design: .rounded))
                                        .foregroundColor(UltraLightDesignSystem.text)
                                    
                                    Text(annotation.subtitle)
                                        .font(.system(size: 8, weight: .medium, design: .rounded))
                                        .foregroundColor(UltraLightDesignSystem.textSecondary)
                                }
                                .padding(.horizontal, 6)
                                .padding(.vertical, 3)
                                .background(UltraLightDesignSystem.surface.opacity(0.9))
                                .cornerRadius(6)
                            }
                        }
                    }
                    .frame(height: 180)
                    .cornerRadius(UltraLightDesignSystem.radiusL)
                    .overlay(
                        RoundedRectangle(cornerRadius: UltraLightDesignSystem.radiusL)
                            .stroke(UltraLightDesignSystem.primaryOrange.opacity(0.2), lineWidth: 0.5)
                    )
                }
                
                // Editable Places List
                VStack(spacing: UltraLightDesignSystem.spaceL) {
                    ForEach(Array(places.enumerated()), id: \.element.id) { index, place in
                        EditablePlaceCard(
                            place: place,
                            index: index,
                            onNightsChanged: { newNights in
                                if index < places.count {
                                    places[index].nights = newNights
                                }
                            },
                            onStartPointChanged: { isStart in
                                // Reset all start points
                                for i in places.indices {
                                    places[i].isStartPoint = false
                                }
                                // Set new start point
                                if index < places.count {
                                    places[index].isStartPoint = isStart
                                }
                            },
                            onEdit: {
                                showingEditPlace = place
                            },
                            onDelete: {
                                if index < places.count {
                                    places.remove(at: index)
                                }
                            },
                            onInsert: {
                                // Insert new place after current one
                                let newPlace = EditablePlace(
                                    name: "New Destination",
                                    coordinate: CLLocationCoordinate2D(latitude: 50.0, longitude: 10.0),
                                    nights: 2,
                                    isStartPoint: false,
                                    hotelName: "New Hotel",
                                    pricePerNight: 100
                                )
                                let insertIndex = min(index + 1, places.count)
                                places.insert(newPlace, at: insertIndex)
                            }
                        )
                    }
                    
                    // Add New Place Button
                    Button(action: {
                        showingAddPlace = true
                    }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(UltraLightDesignSystem.primaryOrange)
                                .font(.system(size: 20))
                            
                            Text("Add New Destination")
                                .font(.system(size: 16, weight: .semibold, design: .rounded))
                                .foregroundColor(UltraLightDesignSystem.primaryOrange)
                            
                            Spacer()
                        }
                        .padding(UltraLightDesignSystem.spaceL)
                        .background(
                            RoundedRectangle(cornerRadius: UltraLightDesignSystem.radiusL)
                                .fill(UltraLightDesignSystem.primaryOrange.opacity(0.1))
                                .overlay(
                                    RoundedRectangle(cornerRadius: UltraLightDesignSystem.radiusL)
                                        .stroke(UltraLightDesignSystem.primaryOrange.opacity(0.3), lineWidth: 1)
                                )
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                
                // Planned Nights Card
                HStack {
                    VStack(alignment: .leading, spacing: UltraLightDesignSystem.spaceXS) {
                        Text("Planned Nights")
                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                            .foregroundColor(UltraLightDesignSystem.text)
                        
                        Text("Total nights across all destinations")
                            .font(.system(size: 12, weight: .medium, design: .rounded))
                            .foregroundColor(UltraLightDesignSystem.textSecondary)
                    }
                    
                    Spacer()
                    
                    Text("\(totalNights)")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(UltraLightDesignSystem.primaryOrange)
                }
                .padding(UltraLightDesignSystem.spaceM)
                .background(UltraLightDesignSystem.primaryOrange.opacity(0.1))
                .cornerRadius(UltraLightDesignSystem.radiusM)
                
                // Total Cost Summary
                HStack {
                    VStack(alignment: .leading, spacing: UltraLightDesignSystem.spaceXS) {
                        Text("Total Trip Cost")
                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                            .foregroundColor(UltraLightDesignSystem.text)
                        
                        Text("Hotels + Flights + Activities")
                            .font(.system(size: 12, weight: .medium, design: .rounded))
                            .foregroundColor(UltraLightDesignSystem.textSecondary)
                    }
                    
                    Spacer()
                    
                    Text("€\(totalTripCost)")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(UltraLightDesignSystem.primaryOrange)
                }
                .padding(UltraLightDesignSystem.spaceM)
                .background(UltraLightDesignSystem.primaryOrange.opacity(0.1))
                .cornerRadius(UltraLightDesignSystem.radiusM)
            }
        }
        .sheet(isPresented: $showingAddPlace) {
            AddPlaceView(
                onSave: { newPlace in
                    places.append(newPlace)
                    showingAddPlace = false
                },
                onCancel: {
                    showingAddPlace = false
                }
            )
        }
        .sheet(item: $showingEditPlace) { place in
            EditPlaceView(
                place: place,
                onSave: { updatedPlace in
                    if let index = places.firstIndex(where: { $0.id == place.id }) {
                        places[index] = updatedPlace
                    }
                    showingEditPlace = nil
                },
                onCancel: {
                    showingEditPlace = nil
                }
            )
        }
    }
    
    // MARK: - Computed Properties
    var totalNights: Int {
        places.reduce(0) { $0 + $1.nights }
    }
    
    var totalTripCost: Int {
        adventure.routeData.totalCost
    }
}

// MARK: - Add Place View
struct AddPlaceView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var nominatimManager = NominatimManager()
    let onSave: (EditablePlace) -> Void
    let onCancel: () -> Void
    
    @State private var searchText = ""
    @State private var selectedNights = 2
    @State private var hotelName = ""
    @State private var pricePerNight = 100
    @State private var selectedPlace: NominatimPlace?
    
    var body: some View {
        NavigationView {
            ZStack {
                UltraLightDesignSystem.background
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: UltraLightDesignSystem.spaceL) {
                        // Search Section
                        UltraLightWindow(
                            title: "Search Destination",
                            style: .glass
                        ) {
                            VStack(spacing: UltraLightDesignSystem.spaceL) {
                                HStack {
                                    Image(systemName: "magnifyingglass")
                                        .foregroundColor(UltraLightDesignSystem.primaryOrange)
                                    
                                    TextField("Search places...", text: $searchText)
                                        .foregroundColor(UltraLightDesignSystem.text) // ✅ White text for better visibility
                                        .onChange(of: searchText) { _ in
                                            performSearch()
                                        }
                                    
                                    if !searchText.isEmpty {
                                        Button(action: {
                                            searchText = ""
                                            nominatimManager.searchResults = []
                                        }) {
                                            Image(systemName: "xmark.circle.fill")
                                                .foregroundColor(UltraLightDesignSystem.textSecondary)
                                        }
                                    }
                                }
                                
                                if !searchText.isEmpty {
                                    ForEach(nominatimManager.searchResults) { place in
                                        Button(action: {
                                            selectedPlace = place
                                            searchText = place.display_name
                                            nominatimManager.searchResults = [] // Clear search results after selection
                                        }) {
                                            UltraLightNominatimPlaceView(place: place)
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                }
                            }
                        }
                        
                        // Place Details
                        if selectedPlace != nil {
                            UltraLightWindow(
                                title: "Place Details",
                                style: .standard
                            ) {
                                VStack(spacing: UltraLightDesignSystem.spaceL) {
                                    // Hotel Name
                                    VStack(alignment: .leading, spacing: UltraLightDesignSystem.spaceS) {
                                        Text("Hotel Name")
                                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                                            .foregroundColor(UltraLightDesignSystem.textSecondary)
                                        
                                        TextField("Enter hotel name", text: $hotelName)
                                            .padding(UltraLightDesignSystem.spaceM)
                                            .background(UltraLightDesignSystem.surface)
                                            .cornerRadius(UltraLightDesignSystem.radiusM)
                                            .foregroundColor(UltraLightDesignSystem.text)
                                    }
                                    
                                    // Price per night
                                    VStack(alignment: .leading, spacing: UltraLightDesignSystem.spaceS) {
                                        Text("Price per Night (€)")
                                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                                            .foregroundColor(UltraLightDesignSystem.textSecondary)
                                        
                                        TextField("100", value: $pricePerNight, format: .number)
                                            .padding(UltraLightDesignSystem.spaceM)
                                            .background(UltraLightDesignSystem.surface)
                                            .cornerRadius(UltraLightDesignSystem.radiusM)
                                            .foregroundColor(UltraLightDesignSystem.text)
                                    }
                                    
                                    // Nights
                                    VStack(alignment: .leading, spacing: UltraLightDesignSystem.spaceS) {
                                        Text("Nights to Stay")
                                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                                            .foregroundColor(UltraLightDesignSystem.textSecondary)
                                        
                                        HStack {
                                            Button(action: {
                                                if selectedNights > 1 {
                                                    selectedNights -= 1
                                                }
                                            }) {
                                                Image(systemName: "minus.circle.fill")
                                                    .font(.system(size: 24))
                                                    .foregroundColor(selectedNights > 1 ? UltraLightDesignSystem.primaryOrange : UltraLightDesignSystem.textSecondary)
                                            }
                                            .disabled(selectedNights <= 1)
                                            
                                            Spacer()
                                            
                                            Text("\(selectedNights)")
                                                .font(.system(size: 20, weight: .bold, design: .rounded))
                                                .foregroundColor(UltraLightDesignSystem.text)
                                                .frame(minWidth: 40)
                                            
                                            Spacer()
                                            
                                            Button(action: {
                                                if selectedNights < 14 {
                                                    selectedNights += 1
                                                }
                                            }) {
                                                Image(systemName: "plus.circle.fill")
                                                    .font(.system(size: 24))
                                                    .foregroundColor(selectedNights < 14 ? UltraLightDesignSystem.primaryOrange : UltraLightDesignSystem.textSecondary)
                                            }
                                            .disabled(selectedNights >= 14)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding(UltraLightDesignSystem.spaceL)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        onCancel()
                    }
                    .foregroundColor(UltraLightDesignSystem.primaryOrange)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        if let place = selectedPlace {
                            let newPlace = EditablePlace(
                                name: place.display_name.components(separatedBy: ",").first ?? "Unknown",
                                coordinate: CLLocationCoordinate2D(
                                    latitude: Double(place.lat) ?? 0.0,
                                    longitude: Double(place.lon) ?? 0.0
                                ),
                                nights: selectedNights,
                                isStartPoint: false,
                                hotelName: hotelName.isEmpty ? "Hotel" : hotelName,
                                pricePerNight: pricePerNight
                            )
                            onSave(newPlace)
                        }
                    }
                    .foregroundColor(UltraLightDesignSystem.primaryOrange)
                    .disabled(selectedPlace == nil)
                }
            }
        }
    }
    
    private func performSearch() {
        guard !searchText.isEmpty else {
            nominatimManager.searchResults = []
            return
        }
        
        nominatimManager.searchPlaces(query: searchText) { _ in }
    }
}

// MARK: - Edit Place View
struct EditPlaceView: View {
    @Environment(\.dismiss) private var dismiss
    let place: EditablePlace
    let onSave: (EditablePlace) -> Void
    let onCancel: () -> Void
    
    @State private var name: String
    @State private var hotelName: String
    @State private var pricePerNight: Int
    @State private var nights: Int
    
    init(place: EditablePlace, onSave: @escaping (EditablePlace) -> Void, onCancel: @escaping () -> Void) {
        self.place = place
        self.onSave = onSave
        self.onCancel = onCancel
        self._name = State(initialValue: place.name)
        self._hotelName = State(initialValue: place.hotelName)
        self._pricePerNight = State(initialValue: place.pricePerNight)
        self._nights = State(initialValue: place.nights)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                UltraLightDesignSystem.background
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: UltraLightDesignSystem.spaceL) {
                        UltraLightWindow(
                            title: "Edit Place",
                            style: .standard
                        ) {
                            VStack(spacing: UltraLightDesignSystem.spaceL) {
                                // Place Name
                                VStack(alignment: .leading, spacing: UltraLightDesignSystem.spaceS) {
                                    Text("Place Name")
                                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                                        .foregroundColor(UltraLightDesignSystem.textSecondary)
                                    
                                    TextField("Enter place name", text: $name)
                                        .padding(UltraLightDesignSystem.spaceM)
                                        .background(UltraLightDesignSystem.surface)
                                        .cornerRadius(UltraLightDesignSystem.radiusM)
                                        .foregroundColor(UltraLightDesignSystem.text)
                                }
                                
                                // Hotel Name
                                VStack(alignment: .leading, spacing: UltraLightDesignSystem.spaceS) {
                                    Text("Hotel Name")
                                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                                        .foregroundColor(UltraLightDesignSystem.textSecondary)
                                    
                                    TextField("Enter hotel name", text: $hotelName)
                                        .padding(UltraLightDesignSystem.spaceM)
                                        .background(UltraLightDesignSystem.surface)
                                        .cornerRadius(UltraLightDesignSystem.radiusM)
                                        .foregroundColor(UltraLightDesignSystem.text)
                                }
                                
                                // Price per night
                                VStack(alignment: .leading, spacing: UltraLightDesignSystem.spaceS) {
                                    Text("Price per Night (€)")
                                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                                        .foregroundColor(UltraLightDesignSystem.textSecondary)
                                    
                                    TextField("100", value: $pricePerNight, format: .number)
                                        .padding(UltraLightDesignSystem.spaceM)
                                        .background(UltraLightDesignSystem.surface)
                                        .cornerRadius(UltraLightDesignSystem.radiusM)
                                        .foregroundColor(UltraLightDesignSystem.text)
                                }
                                
                                // Nights
                                VStack(alignment: .leading, spacing: UltraLightDesignSystem.spaceS) {
                                    Text("Nights to Stay")
                                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                                        .foregroundColor(UltraLightDesignSystem.textSecondary)
                                    
                                    HStack {
                                        Button(action: {
                                            if nights > 1 {
                                                nights -= 1
                                            }
                                        }) {
                                            Image(systemName: "minus.circle.fill")
                                                .font(.system(size: 24))
                                                .foregroundColor(nights > 1 ? UltraLightDesignSystem.primaryOrange : UltraLightDesignSystem.textSecondary)
                                        }
                                        .disabled(nights <= 1)
                                        
                                        Spacer()
                                        
                                        Text("\(nights)")
                                            .font(.system(size: 20, weight: .bold, design: .rounded))
                                            .foregroundColor(UltraLightDesignSystem.text)
                                            .frame(minWidth: 40)
                                        
                                        Spacer()
                                        
                                        Button(action: {
                                            if nights < 14 {
                                                nights += 1
                                            }
                                        }) {
                                            Image(systemName: "plus.circle.fill")
                                                .font(.system(size: 24))
                                                .foregroundColor(nights < 14 ? UltraLightDesignSystem.primaryOrange : UltraLightDesignSystem.textSecondary)
                                        }
                                        .disabled(nights >= 14)
                                    }
                                }
                            }
                        }
                    }
                    .padding(UltraLightDesignSystem.spaceL)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        onCancel()
                    }
                    .foregroundColor(UltraLightDesignSystem.primaryOrange)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        let updatedPlace = EditablePlace(
                            name: name,
                            coordinate: place.coordinate,
                            nights: nights,
                            isStartPoint: place.isStartPoint,
                            hotelName: hotelName,
                            pricePerNight: pricePerNight
                        )
                        onSave(updatedPlace)
                    }
                    .foregroundColor(UltraLightDesignSystem.primaryOrange)
                }
            }
        }
    }
}

// MARK: - Route Detail View
struct UltraLightRouteDetailView: View {
    let route: UltraLightRoute
    @Binding var isPresented: Bool
    @State private var currentStep = 0
    
    var body: some View {
        NavigationView {
            ZStack {
                // Premium Dark Background
                UltraLightDesignSystem.background
                    .ignoresSafeArea()
                
                // Background Gradient Overlay
                LinearGradient(
                    colors: [
                        UltraLightDesignSystem.primaryOrange.opacity(0.1),
                        Color.clear,
                        UltraLightDesignSystem.primaryOrange.opacity(0.1)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: UltraLightDesignSystem.spaceL) {
                        // Route Header
                        UltraLightWindow(
                            title: route.name,
                            subtitle: route.description,
                            style: .premium
                        ) {
                            VStack(spacing: UltraLightDesignSystem.spaceM) {
                                // Route Stats
                                HStack(spacing: UltraLightDesignSystem.spaceL) {
                                    StatCard(title: "Duration", value: route.duration, icon: "clock")
                                    StatCard(title: "Distance", value: route.totalDistance, icon: "map")
                                    StatCard(title: "Destinations", value: "\(route.destinations.count)", icon: "location")
                                }
                                
                                // Route Info
                                HStack(spacing: UltraLightDesignSystem.spaceL) {
                                    InfoBadge(icon: "star.fill", text: route.difficulty, color: UltraLightDesignSystem.accentGold)
                                    InfoBadge(icon: "eurosign.circle.fill", text: route.budget, color: UltraLightDesignSystem.primaryOrange)
                                    InfoBadge(icon: "calendar", text: route.season, color: UltraLightDesignSystem.primaryOrange)
                                }
                            }
                        }
                        
                        // Destinations Timeline
                        UltraLightWindow(
                            title: "Route Timeline",
                            style: .glass
                        ) {
                            VStack(spacing: UltraLightDesignSystem.spaceM) {
                                ForEach(Array(route.destinations.enumerated()), id: \.offset) { index, destination in
                                    HStack(spacing: UltraLightDesignSystem.spaceL) {
                                        // Step Number
                                        ZStack {
                                            Circle()
                                                .fill(
                                                    index <= currentStep ? 
                                                    UltraLightDesignSystem.primaryOrange : 
                                                    UltraLightDesignSystem.textTertiary.opacity(0.3)
                                                )
                                                .frame(width: 32, height: 32)
                                            
                                            Text("\(index + 1)")
                                                .font(.system(size: 14, weight: .bold, design: .rounded))
                                                .foregroundColor(index <= currentStep ? .white : UltraLightDesignSystem.textTertiary)
                                        }
                                        
                                        // Destination Info
                                        VStack(alignment: .leading, spacing: UltraLightDesignSystem.spaceXS) {
                                            Text(destination)
                                                .font(.system(size: 16, weight: .semibold, design: .rounded))
                                                .foregroundColor(UltraLightDesignSystem.text)
                                            
                                            Text("Day \(index + 1)")
                                                .font(.system(size: 14, weight: .medium, design: .rounded))
                                                .foregroundColor(UltraLightDesignSystem.textSecondary)
                                        }
                                        
                                        Spacer()
                                        
                                        // Action Button
                                        Button(action: {
                                            currentStep = index
                                        }) {
                                            Image(systemName: index == currentStep ? "checkmark.circle.fill" : "circle")
                                                .font(.system(size: 20))
                                                .foregroundColor(
                                                    index == currentStep ? 
                                                    UltraLightDesignSystem.primaryOrange : 
                                                    UltraLightDesignSystem.textTertiary
                                                )
                                        }
                                    }
                                    .padding(.vertical, UltraLightDesignSystem.spaceS)
                                    
                                    if index < route.destinations.count - 1 {
                                        Rectangle()
                                            .fill(UltraLightDesignSystem.textTertiary.opacity(0.3))
                                            .frame(width: 2, height: 20)
                                            .padding(.leading, 15)
                                    }
                                }
                            }
                        }
                        
                        // Highlights
                        if !route.highlights.isEmpty {
                            UltraLightWindow(
                                title: "Must-See Highlights",
                                style: .standard
                            ) {
                                LazyVGrid(columns: [
                                    GridItem(.flexible()),
                                    GridItem(.flexible())
                                ], spacing: UltraLightDesignSystem.spaceM) {
                                    ForEach(route.highlights, id: \.self) { highlight in
                                        HStack(spacing: UltraLightDesignSystem.spaceS) {
                                            Image(systemName: "star.fill")
                                                .font(.system(size: 12))
                                                .foregroundColor(UltraLightDesignSystem.accentGold)
                                            
                                            Text(highlight)
                                                .font(.system(size: 14, weight: .medium, design: .rounded))
                                                .foregroundColor(UltraLightDesignSystem.text)
                                                .lineLimit(2)
                                            
                                            Spacer()
                                        }
                                        .padding(UltraLightDesignSystem.spaceM)
                                        .background(UltraLightDesignSystem.surface)
                                        .cornerRadius(UltraLightDesignSystem.radiusM)
                                    }
                                }
                            }
                        }
                        
                        // Transport Modes
                        if !route.transportModes.isEmpty {
                            UltraLightWindow(
                                title: "Transportation",
                                style: .standard
                            ) {
                                HStack(spacing: UltraLightDesignSystem.spaceM) {
                                    ForEach(route.transportModes, id: \.self) { mode in
                                        HStack(spacing: UltraLightDesignSystem.spaceXS) {
                                            Image(systemName: transportIcon(for: mode))
                                                .font(.system(size: 16))
                                                .foregroundColor(UltraLightDesignSystem.primaryOrange)
                                            
                                            Text(mode)
                                                .font(.system(size: 14, weight: .medium, design: .rounded))
                                                .foregroundColor(UltraLightDesignSystem.text)
                                        }
                                        .padding(.horizontal, UltraLightDesignSystem.spaceM)
                                        .padding(.vertical, UltraLightDesignSystem.spaceS)
                                        .background(UltraLightDesignSystem.primaryOrange.opacity(0.1))
                                        .cornerRadius(UltraLightDesignSystem.radiusM)
                                    }
                                    
                                    Spacer()
                                }
                            }
                        }
                        
                        // Action Buttons
                        VStack(spacing: UltraLightDesignSystem.spaceM) {
                            Button(action: {
                                // Start Route
                            }) {
                                HStack(spacing: UltraLightDesignSystem.spaceS) {
                                    Image(systemName: "play.fill")
                                        .font(.system(size: 18, weight: .semibold))
                                    
                                    Text("Start This Route")
                                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(
                                    RoundedRectangle(cornerRadius: UltraLightDesignSystem.radiusM)
                                        .fill(
                                            LinearGradient(
                                                colors: [UltraLightDesignSystem.primaryOrange, UltraLightDesignSystem.primaryOrange.opacity(0.8)],
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            )
                                        )
                                        .shadow(
                                            color: UltraLightDesignSystem.glowOrange,
                                            radius: 10,
                                            x: 0,
                                            y: 4
                                        )
                                )
                            }
                            
                            Button(action: {
                                // Share Route
                            }) {
                                HStack(spacing: UltraLightDesignSystem.spaceS) {
                                    Image(systemName: "square.and.arrow.up")
                                        .font(.system(size: 16, weight: .medium))
                                    
                                    Text("Share Route")
                                        .font(.system(size: 16, weight: .medium, design: .rounded))
                                }
                                .foregroundColor(UltraLightDesignSystem.primaryOrange)
                                .frame(maxWidth: .infinity)
                                .frame(height: 48)
                                .background(
                                    RoundedRectangle(cornerRadius: UltraLightDesignSystem.radiusM)
                                        .fill(UltraLightDesignSystem.surface)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: UltraLightDesignSystem.radiusM)
                                                .stroke(UltraLightDesignSystem.primaryOrange.opacity(0.3), lineWidth: 1)
                                        )
                                )
                            }
                        }
                        .padding(.horizontal, UltraLightDesignSystem.spaceL)
                        .padding(.bottom, UltraLightDesignSystem.spaceXL)
                    }
                    .padding(.horizontal, UltraLightDesignSystem.spaceL)
                    .padding(.top, UltraLightDesignSystem.spaceL)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        isPresented = false
                    }
                    .foregroundColor(UltraLightDesignSystem.primaryOrange)
                }
            }
        }
    }
    
    private func transportIcon(for mode: String) -> String {
        switch mode.lowercased() {
        case "train": return "tram.fill"
        case "flight": return "airplane"
        case "bus": return "bus.fill"
        case "car": return "car.fill"
        case "ferry": return "ferry.fill"
        default: return "figure.walk"
        }
    }
}

// MARK: - Info Badge
struct InfoBadge: View {
    let icon: String
    let text: String
    let color: Color
    
    var body: some View {
        HStack(spacing: UltraLightDesignSystem.spaceXS) {
            Image(systemName: icon)
                .font(.system(size: 12))
                .foregroundColor(color)
            
            Text(text)
                .font(.system(size: 12, weight: .medium, design: .rounded))
                .foregroundColor(UltraLightDesignSystem.textSecondary)
        }
        .padding(.horizontal, UltraLightDesignSystem.spaceS)
        .padding(.vertical, UltraLightDesignSystem.spaceXS)
        .background(color.opacity(0.1))
        .cornerRadius(UltraLightDesignSystem.radiusS)
    }
}

struct UltraLightExploreView: View {
    @StateObject private var nominatimManager = NominatimManager()
    @State private var searchText = ""
    
    var body: some View {
        ScrollView {
            VStack(spacing: UltraLightDesignSystem.spaceL) {
                // Search Bar
                UltraLightWindow(style: .glass) {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(UltraLightDesignSystem.primaryOrange)
                        
                        TextField("Search destinations...", text: $searchText)
                            .foregroundColor(UltraLightDesignSystem.text)
                            .onChange(of: searchText) { _ in
                                performNominatimSearch()
                            }
                        
                        if !searchText.isEmpty {
                            Button(action: {
                                searchText = ""
                                nominatimManager.searchResults = []
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(UltraLightDesignSystem.textSecondary)
                            }
                        }
                    }
                }
                
                // Search Results
                if !searchText.isEmpty {
                    if nominatimManager.isLoading {
                        UltraLightWindow(style: .glass) {
                            HStack {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: UltraLightDesignSystem.primaryOrange))
                                Text("Searching...")
                                    .foregroundColor(UltraLightDesignSystem.textSecondary)
                                Spacer()
                            }
                        }
                    } else if nominatimManager.searchResults.isEmpty {
                        UltraLightWindow(style: .glass) {
                            VStack(spacing: UltraLightDesignSystem.spaceM) {
                                Image(systemName: "magnifyingglass")
                                    .font(.system(size: 32))
                                    .foregroundColor(UltraLightDesignSystem.textSecondary)
                                
                                Text("No places found")
                                    .font(.system(size: 16, weight: .medium, design: .rounded))
                                    .foregroundColor(UltraLightDesignSystem.text)
                                
                                Text("Try a different search term")
                                    .font(.system(size: 14, weight: .medium, design: .rounded))
                                    .foregroundColor(UltraLightDesignSystem.textSecondary)
                            }
                            .padding(.vertical, UltraLightDesignSystem.spaceL)
                        }
                    } else {
                        ForEach(nominatimManager.searchResults) { place in
                            UltraLightNominatimPlaceView(place: place)
                        }
                    }
                } else {
                    // Featured Destinations
                    UltraLightWindow(
                        title: "Featured Destinations",
                        style: .elevated
                    ) {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: UltraLightDesignSystem.spaceL) {
                                DestinationCard(
                                    name: "Santorini",
                                    country: "Greece",
                                    image: "sun.max.fill",
                                    color: UltraLightDesignSystem.primaryOrange
                                )
                                
                                DestinationCard(
                                    name: "Kyoto",
                                    country: "Japan",
                                    image: "leaf.fill",
                                    color: UltraLightDesignSystem.primaryOrange
                                )
                                
                                DestinationCard(
                                    name: "Reykjavik",
                                    country: "Iceland",
                                    image: "snowflake",
                                    color: UltraLightDesignSystem.primaryOrange
                                )
                            }
                            .padding(.horizontal, UltraLightDesignSystem.spaceL)
                        }
                    }
                }
            }
            .padding(.horizontal, UltraLightDesignSystem.spaceL)
            .padding(.top, UltraLightDesignSystem.spaceL)
        }
    }
    
    private func performNominatimSearch() {
        guard !searchText.isEmpty else {
            nominatimManager.searchResults = []
            return
        }
        
        nominatimManager.searchPlaces(query: searchText) { results in
            // Results are automatically set in the manager
        }
    }
}

struct UltraLightProfileView: View {
    @State private var showingLogin = false
    @State private var showingSignUp = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: UltraLightDesignSystem.spaceL) {
                // Profile Header
                UltraLightWindow(style: .gradient) {
                    HStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [UltraLightDesignSystem.primaryOrange, UltraLightDesignSystem.primaryGreen],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 60, height: 60)
                            .overlay(
                                Text("M")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(.white)
                            )
                        
                        VStack(alignment: .leading, spacing: UltraLightDesignSystem.spaceXS) {
                            Text("Marius")
                                .font(.system(size: 20, weight: .bold, design: .rounded))
                                .foregroundColor(UltraLightDesignSystem.text)
                            
                            Text("Travel Enthusiast")
                                .font(.system(size: 14, weight: .medium, design: .rounded))
                                .foregroundColor(UltraLightDesignSystem.textSecondary)
                        }
                        
                        Spacer()
                    }
                }
                
                // Authentication Section
                UltraLightWindow(
                    title: "Account",
                    style: .standard
                ) {
                    VStack(spacing: UltraLightDesignSystem.spaceM) {
                        // Login Button
                        Button(action: {
                            showingLogin = true
                        }) {
                            HStack {
                                Image(systemName: "person.circle.fill")
                                    .font(.system(size: 18))
                                    .foregroundColor(UltraLightDesignSystem.primaryOrange)
                                
                                Text("Sign In")
                                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                                    .foregroundColor(UltraLightDesignSystem.text)
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(UltraLightDesignSystem.textSecondary)
                            }
                            .padding(UltraLightDesignSystem.spaceM)
                            .background(UltraLightDesignSystem.surface)
                            .cornerRadius(UltraLightDesignSystem.radiusM)
                        }
                        
                        // Sign Up Button
                        Button(action: {
                            showingSignUp = true
                        }) {
                            HStack {
                                Image(systemName: "person.badge.plus.fill")
                                    .font(.system(size: 18))
                                    .foregroundColor(UltraLightDesignSystem.primaryOrange)
                                
                                Text("Create Account")
                                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                                    .foregroundColor(UltraLightDesignSystem.text)
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(UltraLightDesignSystem.textSecondary)
                            }
                            .padding(UltraLightDesignSystem.spaceM)
                            .background(UltraLightDesignSystem.surface)
                            .cornerRadius(UltraLightDesignSystem.radiusM)
                        }
                    }
                }
                
                // Settings
                UltraLightWindow(
                    title: "Settings",
                    style: .standard
                ) {
                    VStack(spacing: UltraLightDesignSystem.spaceM) {
                        UltraLightListItem(
                            icon: "bell.fill",
                            title: "Notifications",
                            subtitle: "Manage your alerts",
                            action: {}
                        )
                        
                        UltraLightListItem(
                            icon: "lock.fill",
                            title: "Privacy",
                            subtitle: "Control your data",
                            action: {}
                        )
                        
                        UltraLightListItem(
                            icon: "questionmark.circle.fill",
                            title: "Help & Support",
                            subtitle: "Get assistance",
                            action: {}
                        )
                    }
                }
            }
            .padding(.horizontal, UltraLightDesignSystem.spaceL)
            .padding(.top, UltraLightDesignSystem.spaceL)
        }
        .sheet(isPresented: $showingLogin) {
            UltraLightLoginView()
        }
        .sheet(isPresented: $showingSignUp) {
            UltraLightSignUpView()
        }
    }
}

// MARK: - Supabase Auth Manager
class SupabaseAuthManager: ObservableObject {
    private let auth: AuthClient
    private let database: PostgrestClient
    
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isSignedUp = false
    @Published var currentUser: User?
    @Published var userProfile: Profile?
    
    init() {
        // Initialize Supabase clients with your project URL and anon key
        let supabaseURL = URL(string: "YOUR_SUPABASE_URL")!
        let supabaseKey = "YOUR_SUPABASE_ANON_KEY"
        
        auth = AuthClient(url: supabaseURL, headers: ["apikey": supabaseKey], localStorage: UserDefaults.standard as! AuthLocalStorage)
        database = PostgrestClient(url: supabaseURL, headers: ["apikey": supabaseKey])
    }
    
    // MARK: - Sign Up Function
    @MainActor
    func signUpUser(email: String, password: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            // 1. Create user account with Supabase Auth
            let authResponse = try await auth.signUp(
                email: email,
                password: password
            )
            
            let user = authResponse.user
            
            print("✅ User created successfully with ID: \(user.id)")
            
            // 2. Insert user into profiles table
            let profile = Profile(
                id: user.id,
                email: email,
                createdAt: Date()
            )
            
            try await database
                .from("profiles")
                .insert(profile)
                .execute()
            
            print("✅ Profile created successfully")
            
            // 3. Success - update UI state
            isSignedUp = true
            isLoading = false
            
        } catch {
            // 4. Handle errors
            handleError(error)
        }
    }
    
    // MARK: - Login Function
    @MainActor
    func loginUser(email: String, password: String) async -> Bool {
        isLoading = true
        errorMessage = nil
        
        do {
            // 1. Sign in with Supabase Auth
            let authResponse = try await auth.signIn(
                email: email,
                password: password
            )
            
            let user = authResponse.user
            print("✅ User signed in successfully with ID: \(user.id)")
            
            // 2. Query profiles table to confirm user has a corresponding profile
            let profile: Profile = try await database
                .from("profiles")
                .select()
                .eq("id", value: user.id)
                .single()
                .execute()
                .value
            
            print("✅ Profile found for user: \(profile.email)")
            
            // 3. Success - update UI state
            currentUser = user
            userProfile = profile
            isSignedUp = true // Reuse this flag for signed in state
            isLoading = false
            
            return true
            
        } catch {
            // 4. Handle errors
            handleLoginError(error)
            return false
        }
    }
    
    // MARK: - Sign In Function (Legacy - keeping for compatibility)
    @MainActor
    func signInUser(email: String, password: String) async {
        _ = await loginUser(email: email, password: password)
    }
    
    // MARK: - Error Handling
    @MainActor
    private func handleError(_ error: Error) {
        isLoading = false
        
        if let authError = error as? AuthError {
            errorMessage = authError.localizedDescription
        } else if let postgrestError = error as? PostgrestError {
            errorMessage = "Database error: \(postgrestError.message)"
        } else {
            errorMessage = "An unexpected error occurred: \(error.localizedDescription)"
        }
        
        print("❌ Auth error: \(errorMessage ?? "Unknown error")")
    }
    
    @MainActor
    private func handleLoginError(_ error: Error) {
        isLoading = false
        
        // Handle specific Supabase auth errors
        if let authError = error as? AuthError {
            errorMessage = "Authentication error: \(authError.localizedDescription)"
        } else if let postgrestError = error as? PostgrestError {
            // Handle database/profile errors
            if postgrestError.message.contains("No rows found") {
                errorMessage = "User profile not found. Please contact support."
            } else {
                errorMessage = "Database error: \(postgrestError.message)"
            }
        } else {
            // Handle general errors with more specific messages
            let errorString = error.localizedDescription.lowercased()
            if errorString.contains("invalid") && errorString.contains("credentials") {
                errorMessage = "Invalid email or password"
            } else if errorString.contains("user not found") {
                errorMessage = "No account found with this email"
            } else if errorString.contains("wrong password") {
                errorMessage = "Incorrect password"
            } else if errorString.contains("email not confirmed") {
                errorMessage = "Please check your email and confirm your account"
            } else if errorString.contains("too many requests") {
                errorMessage = "Too many login attempts. Please try again later"
            } else {
                errorMessage = "Login failed: \(error.localizedDescription)"
            }
        }
        
        print("❌ Login error: \(errorMessage ?? "Unknown error")")
    }
    
    // MARK: - Clear Error
    func clearError() {
        errorMessage = nil
    }
}

// MARK: - Profile Model
struct Profile: Codable {
    let id: UUID
    let email: String
    let createdAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case email
        case createdAt = "created_at"
    }
}


// MARK: - Authentication Views
struct UltraLightLoginView: View {
    @StateObject private var authManager = SupabaseAuthManager()
    @State private var email = ""
    @State private var password = ""
    @State private var showingAlert = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                UltraLightDesignSystem.background
                    .ignoresSafeArea()
                
                VStack(spacing: UltraLightDesignSystem.spaceL) {
                    // Header
                    UltraLightWindow(
                        title: "Welcome Back",
                        subtitle: "Sign in to your account",
                        style: .premium
                    ) {
                        EmptyView()
                    }
                    
                    // Login Form
                    UltraLightWindow(
                        title: "Sign In",
                        style: .standard
                    ) {
                        VStack(spacing: UltraLightDesignSystem.spaceL) {
                            // Email Field
                            VStack(alignment: .leading, spacing: UltraLightDesignSystem.spaceS) {
                                Text("Email")
                                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                                    .foregroundColor(UltraLightDesignSystem.textSecondary)
                                
                                TextField("Enter your email", text: $email)
                                    .textFieldStyle(PlainTextFieldStyle())
                                    .padding(UltraLightDesignSystem.spaceM)
                                    .background(UltraLightDesignSystem.surface)
                                    .cornerRadius(UltraLightDesignSystem.radiusM)
                                    .foregroundColor(UltraLightDesignSystem.text)
                                    .keyboardType(.emailAddress)
                                    .autocapitalization(.none)
                                    .disableAutocorrection(true)
                            }
                            
                            // Password Field
                            VStack(alignment: .leading, spacing: UltraLightDesignSystem.spaceS) {
                                Text("Password")
                                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                                    .foregroundColor(UltraLightDesignSystem.textSecondary)
                                
                                SecureField("Enter your password", text: $password)
                                    .textFieldStyle(PlainTextFieldStyle())
                                    .padding(UltraLightDesignSystem.spaceM)
                                    .background(UltraLightDesignSystem.surface)
                                    .cornerRadius(UltraLightDesignSystem.radiusM)
                                    .foregroundColor(UltraLightDesignSystem.text)
                            }
                            
                            // Sign In Button
                            Button(action: {
                                Task {
                                    await signInButtonTapped()
                                }
                            }) {
                                HStack {
                                    if authManager.isLoading {
                                        ProgressView()
                                            .scaleEffect(0.8)
                                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    }
                                    Text(authManager.isLoading ? "Signing In..." : "Sign In")
                                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                                }
                                .frame(maxWidth: .infinity)
                                .padding(UltraLightDesignSystem.spaceM)
                                .background(
                                    LinearGradient(
                                        colors: [UltraLightDesignSystem.primaryOrange, UltraLightDesignSystem.primaryOrange.opacity(0.8)],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .foregroundColor(.white)
                                .cornerRadius(UltraLightDesignSystem.radiusM)
                                .shadow(color: UltraLightDesignSystem.primaryOrange.opacity(0.3), radius: 8, x: 0, y: 4)
                            }
                            .disabled(authManager.isLoading || email.isEmpty || password.isEmpty)
                            
                            // Sign Up Link
                            HStack {
                                Text("Don't have an account?")
                                    .font(.system(size: 14, weight: .medium, design: .rounded))
                                    .foregroundColor(UltraLightDesignSystem.textSecondary)
                                
                                Button("Sign Up") {
                                    // This would typically navigate to sign up
                                }
                                .font(.system(size: 14, weight: .semibold, design: .rounded))
                                .foregroundColor(UltraLightDesignSystem.primaryOrange)
                            }
                        }
                    }
                    
                    Spacer()
                }
                .padding(UltraLightDesignSystem.spaceL)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(UltraLightDesignSystem.primaryOrange)
                }
            }
            .alert("Sign In Error", isPresented: $showingAlert) {
                Button("OK") {
                    authManager.clearError()
                }
            } message: {
                Text(authManager.errorMessage ?? "Unknown error occurred")
            }
            .onChange(of: authManager.errorMessage) { errorMessage in
                showingAlert = errorMessage != nil
            }
        }
    }
    
    // MARK: - Sign In Button Action
    private func signInButtonTapped() async {
        // Validate input
        guard !email.isEmpty, !password.isEmpty else {
            authManager.errorMessage = "Please fill in all fields"
            return
        }
        
        guard isValidEmail(email) else {
            authManager.errorMessage = "Please enter a valid email address"
            return
        }
        
        // Call the sign in function
        await authManager.signInUser(email: email, password: password)
    }
    
    // MARK: - Email Validation
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}

struct UltraLightSignUpView: View {
    @StateObject private var authManager = SupabaseAuthManager()
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var showingAlert = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                UltraLightDesignSystem.background
                    .ignoresSafeArea()
                
                VStack(spacing: UltraLightDesignSystem.spaceL) {
                    // Header
                    UltraLightWindow(
                        title: "Create Account",
                        subtitle: "Join the adventure",
                        style: .premium
                    ) {
                        EmptyView()
                    }
                    
                    // Sign Up Form
                    UltraLightWindow(
                        title: "Sign Up",
                        style: .standard
                    ) {
                        VStack(spacing: UltraLightDesignSystem.spaceL) {
                            // Email Field
                            VStack(alignment: .leading, spacing: UltraLightDesignSystem.spaceS) {
                                Text("Email")
                                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                                    .foregroundColor(UltraLightDesignSystem.textSecondary)
                                
                                TextField("Enter your email", text: $email)
                                    .textFieldStyle(PlainTextFieldStyle())
                                    .padding(UltraLightDesignSystem.spaceM)
                                    .background(UltraLightDesignSystem.surface)
                                    .cornerRadius(UltraLightDesignSystem.radiusM)
                                    .foregroundColor(UltraLightDesignSystem.text)
                                    .keyboardType(.emailAddress)
                                    .autocapitalization(.none)
                                    .disableAutocorrection(true)
                            }
                            
                            // Password Field
                            VStack(alignment: .leading, spacing: UltraLightDesignSystem.spaceS) {
                                Text("Password")
                                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                                    .foregroundColor(UltraLightDesignSystem.textSecondary)
                                
                                SecureField("Enter your password", text: $password)
                                    .textFieldStyle(PlainTextFieldStyle())
                                    .padding(UltraLightDesignSystem.spaceM)
                                    .background(UltraLightDesignSystem.surface)
                                    .cornerRadius(UltraLightDesignSystem.radiusM)
                                    .foregroundColor(UltraLightDesignSystem.text)
                                    .autocorrectionDisabled()
                            }
                            
                            // Confirm Password Field
                            VStack(alignment: .leading, spacing: UltraLightDesignSystem.spaceS) {
                                Text("Confirm Password")
                                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                                    .foregroundColor(UltraLightDesignSystem.textSecondary)
                                
                                SecureField("Confirm your password", text: $confirmPassword)
                                    .textFieldStyle(PlainTextFieldStyle())
                                    .padding(UltraLightDesignSystem.spaceM)
                                    .background(UltraLightDesignSystem.surface)
                                    .cornerRadius(UltraLightDesignSystem.radiusM)
                                    .foregroundColor(UltraLightDesignSystem.text)
                                    .autocorrectionDisabled()
                            }
                            
                            // Sign Up Button
                            Button(action: {
                                Task {
                                    await signUpButtonTapped()
                                }
                            }) {
                                HStack {
                                    if authManager.isLoading {
                                        ProgressView()
                                            .scaleEffect(0.8)
                                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    }
                                    Text(authManager.isLoading ? "Creating Account..." : "Create Account")
                                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                                }
                                .frame(maxWidth: .infinity)
                                .padding(UltraLightDesignSystem.spaceM)
                                .background(
                                    LinearGradient(
                                        colors: [UltraLightDesignSystem.primaryOrange, UltraLightDesignSystem.primaryOrange.opacity(0.8)],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .foregroundColor(.white)
                                .cornerRadius(UltraLightDesignSystem.radiusM)
                                .shadow(color: UltraLightDesignSystem.primaryOrange.opacity(0.3), radius: 8, x: 0, y: 4)
                            }
                            .disabled(authManager.isLoading || email.isEmpty || password.isEmpty || confirmPassword.isEmpty)
                            
                            // Success Message
                            if authManager.isSignedUp {
                                Text("✅ Account created successfully!")
                                    .foregroundColor(.green)
                                    .font(.headline)
                            }
                            
                            // Sign In Link
                            HStack {
                                Text("Already have an account?")
                                    .font(.system(size: 14, weight: .medium, design: .rounded))
                                    .foregroundColor(UltraLightDesignSystem.textSecondary)
                                
                                Button("Sign In") {
                                    // This would typically navigate to sign in
                                }
                                .font(.system(size: 14, weight: .semibold, design: .rounded))
                                .foregroundColor(UltraLightDesignSystem.primaryOrange)
                            }
                        }
                    }
                    
                    Spacer()
                }
                .padding(UltraLightDesignSystem.spaceL)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(UltraLightDesignSystem.primaryOrange)
                }
            }
            .alert("Sign Up Error", isPresented: $showingAlert) {
                Button("OK") {
                    authManager.clearError()
                }
            } message: {
                Text(authManager.errorMessage ?? "Unknown error occurred")
            }
            .onChange(of: authManager.errorMessage) { errorMessage in
                showingAlert = errorMessage != nil
            }
        }
    }
    
    // MARK: - Sign Up Button Action
    private func signUpButtonTapped() async {
        // Validate input
        guard !email.isEmpty, !password.isEmpty, !confirmPassword.isEmpty else {
            authManager.errorMessage = "Please fill in all fields"
            return
        }
        
        guard isValidEmail(email) else {
            authManager.errorMessage = "Please enter a valid email address"
            return
        }
        
        guard password.count >= 6 else {
            authManager.errorMessage = "Password must be at least 6 characters long"
            return
        }
        
        guard password == confirmPassword else {
            authManager.errorMessage = "Passwords do not match"
            return
        }
        
        // Call the sign up function
        await authManager.signUpUser(email: email, password: password)
    }
    
    // MARK: - Email Validation
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}

// MARK: - Supporting Views
struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(spacing: UltraLightDesignSystem.spaceS) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(UltraLightDesignSystem.primaryOrange)
            
            Text(value)
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundColor(UltraLightDesignSystem.text)
            
            Text(title)
                .font(.system(size: 12, weight: .medium, design: .rounded))
                .foregroundColor(UltraLightDesignSystem.textSecondary)
        }
        .frame(maxWidth: .infinity)
    }
}

struct QuickActionCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    
    var body: some View {
        VStack(spacing: UltraLightDesignSystem.spaceL) {
            Image(systemName: icon)
                .font(.system(size: 22, weight: .medium))
                .foregroundColor(color)
            
            VStack(spacing: UltraLightDesignSystem.spaceS) {
                Text(title)
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                    .foregroundColor(UltraLightDesignSystem.text)
                
                Text(subtitle)
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundColor(UltraLightDesignSystem.textSecondary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(UltraLightDesignSystem.spaceL)
        .background(UltraLightDesignSystem.background)
        .cornerRadius(UltraLightDesignSystem.radiusM)
    }
}

struct UltraLightRouteCard: View {
    let route: UltraLightRoute
    
    var body: some View {
        HStack(spacing: UltraLightDesignSystem.spaceL) {
            VStack(alignment: .leading, spacing: UltraLightDesignSystem.spaceM) {
                HStack {
                    Text(route.name)
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(UltraLightDesignSystem.text)
                    
                    Spacer()
                    
                    Text(route.duration)
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundColor(UltraLightDesignSystem.primaryOrange)
                }
                
                HStack {
                    ForEach(route.destinations.prefix(3), id: \.self) { destination in
                        Text(destination)
                            .font(.system(size: 12, weight: .medium, design: .rounded))
                            .foregroundColor(UltraLightDesignSystem.textSecondary)
                            .padding(.horizontal, UltraLightDesignSystem.spaceS)
                            .padding(.vertical, UltraLightDesignSystem.spaceXS)
                            .background(UltraLightDesignSystem.primaryOrange.opacity(0.1))
                            .cornerRadius(UltraLightDesignSystem.radiusS)
                    }
                    
                    if route.destinations.count > 3 {
                        Text("+\(route.destinations.count - 3)")
                            .font(.system(size: 12, weight: .medium, design: .rounded))
                            .foregroundColor(UltraLightDesignSystem.textTertiary)
                            .padding(.horizontal, UltraLightDesignSystem.spaceS)
                            .padding(.vertical, UltraLightDesignSystem.spaceXS)
                            .background(UltraLightDesignSystem.textTertiary.opacity(0.1))
                            .cornerRadius(UltraLightDesignSystem.radiusS)
                    }
                    
                    Spacer()
                }
                
                // Route Info Row
                HStack(spacing: UltraLightDesignSystem.spaceL) {
                    HStack(spacing: UltraLightDesignSystem.spaceXS) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 12))
                            .foregroundColor(UltraLightDesignSystem.accentGold)
                        Text(route.difficulty)
                            .font(.system(size: 12, weight: .medium, design: .rounded))
                            .foregroundColor(UltraLightDesignSystem.textSecondary)
                    }
                    
                    HStack(spacing: UltraLightDesignSystem.spaceXS) {
                        Image(systemName: "eurosign.circle.fill")
                            .font(.system(size: 12))
                            .foregroundColor(UltraLightDesignSystem.primaryOrange)
                        Text(route.budget)
                            .font(.system(size: 12, weight: .medium, design: .rounded))
                            .foregroundColor(UltraLightDesignSystem.textSecondary)
                    }
                    
                    Spacer()
                }
            }
            
            // Chevron
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(UltraLightDesignSystem.textTertiary)
        }
    }
}

struct DestinationCard: View {
    let name: String
    let country: String
    let image: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: UltraLightDesignSystem.spaceM) {
            ZStack {
                RoundedRectangle(cornerRadius: UltraLightDesignSystem.radiusM)
                    .fill(color.opacity(0.2))
                    .frame(width: 120, height: 80)
                
                Image(systemName: image)
                    .font(.system(size: 32, weight: .medium))
                    .foregroundColor(color)
            }
            
            VStack(alignment: .leading, spacing: UltraLightDesignSystem.spaceXS) {
                Text(name)
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(UltraLightDesignSystem.text)
                
                Text(country)
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundColor(UltraLightDesignSystem.textSecondary)
            }
        }
        .frame(width: 120)
    }
}

// MARK: - Tab Components
struct TabItem {
    let icon: String
    let selectedIcon: String?
    let title: String
    let badge: String?
    
    init(icon: String, selectedIcon: String? = nil, title: String, badge: String? = nil) {
        self.icon = icon
        self.selectedIcon = selectedIcon ?? icon
        self.title = title
        self.badge = badge
    }
}

    struct UltraLightTabBar: View {
        @Binding var selectedTab: Int
        let tabs: [TabItem]

        var body: some View {
            HStack(spacing: 0) {
                ForEach(0..<tabs.count, id: \.self) { index in
                    UltraLightTabBarButton(
                        tab: tabs[index],
                        isSelected: selectedTab == index,
                        action: { selectedTab = index }
                    )
                }
            }
            .padding(.horizontal, UltraLightDesignSystem.spaceL)
            .padding(.vertical, UltraLightDesignSystem.spaceM)
            .background(
                RoundedRectangle(cornerRadius: UltraLightDesignSystem.radiusXL)
                    .fill(UltraLightDesignSystem.surfaceElevated)
                    .overlay(
                        RoundedRectangle(cornerRadius: UltraLightDesignSystem.radiusXL)
                            .stroke(
                                LinearGradient(
                                    colors: [UltraLightDesignSystem.primaryOrange.opacity(0.15), UltraLightDesignSystem.primaryGreen.opacity(0.15)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 0.3
                            )
                    )
                    .shadow(
                        color: UltraLightDesignSystem.shadowMedium,
                        radius: 12,
                        x: 0,
                        y: -4
                    )
            )
            .padding(.horizontal, UltraLightDesignSystem.spaceL)
        }
    }

struct UltraLightTabBarButton: View {
    let tab: TabItem
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: UltraLightDesignSystem.spaceXS) {
                ZStack {
                    // Clean background circle for selected state
                    if isSelected {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [UltraLightDesignSystem.primaryOrange, UltraLightDesignSystem.primaryGreen],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 32, height: 32)
                            .overlay(
                                Circle()
                                    .stroke(UltraLightDesignSystem.accentGold.opacity(0.2), lineWidth: 0.3)
                            )
                            .shadow(
                                color: isSelected ? UltraLightDesignSystem.glowOrange : .clear,
                                radius: 6,
                                x: 0,
                                y: 0
                            )
                            .scaleEffect(1.02)
                    }

                    // Clean icon
                    Image(systemName: isSelected ? (tab.selectedIcon ?? tab.icon) : tab.icon)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(isSelected ? .white : UltraLightDesignSystem.textSecondary)
                        .scaleEffect(isSelected ? 1.02 : 1.0)

                    // Clean badge
                    if let badge = tab.badge, !badge.isEmpty {
                        Text(badge)
                            .font(.system(size: 9, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, UltraLightDesignSystem.spaceXS)
                            .padding(.vertical, 2)
                            .background(
                                Capsule()
                                    .fill(UltraLightDesignSystem.accentGold)
                                    .overlay(
                                        Capsule()
                                            .stroke(UltraLightDesignSystem.primaryGreen, lineWidth: 0.5)
                                    )
                            )
                            .offset(x: 14, y: -14)
                    }
                }

                // Clean title
                Text(tab.title)
                    .font(.system(size: 11, weight: .medium, design: .rounded))
                    .foregroundColor(isSelected ? UltraLightDesignSystem.primaryOrange : UltraLightDesignSystem.textSecondary)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.spring(response: 0.5, dampingFraction: 0.7), value: isSelected)
    }
}

// MARK: - Window Components
struct UltraLightWindow<Content: View>: View {
    let content: Content
    let title: String?
    let subtitle: String?
    let style: WindowStyle
    
    enum WindowStyle {
        case standard
        case elevated
        case glass
        case minimal
        case gradient
        case premium
    }
    
    init(
        title: String? = nil,
        subtitle: String? = nil,
        style: WindowStyle = .standard,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.subtitle = subtitle
        self.style = style
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: UltraLightDesignSystem.spaceL) {
            // Header
            if let title = title {
                VStack(alignment: .leading, spacing: UltraLightDesignSystem.spaceXS) {
                    Text(title)
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(UltraLightDesignSystem.text)
                    
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(.system(size: 13, weight: .medium, design: .rounded))
                            .foregroundColor(UltraLightDesignSystem.textSecondary)
                    }
                }
            }
            
            // Content
            content
        }
        .padding(UltraLightDesignSystem.spaceL)
        .background(backgroundView)
        .cornerRadius(UltraLightDesignSystem.radiusXL)
        .shadow(
            color: shadowColor,
            radius: shadowRadius,
            x: 0,
            y: shadowOffset
        )
    }
    
    @ViewBuilder
    private var backgroundView: some View {
        switch style {
        case .standard:
            RoundedRectangle(cornerRadius: UltraLightDesignSystem.radiusL)
                .fill(UltraLightDesignSystem.background)
        case .elevated:
            RoundedRectangle(cornerRadius: UltraLightDesignSystem.radiusL)
                .fill(UltraLightDesignSystem.background)
        case .glass:
            RoundedRectangle(cornerRadius: UltraLightDesignSystem.radiusL)
                .fill(UltraLightDesignSystem.background.opacity(0.8))
                .background(.ultraThinMaterial)
        case .minimal:
            RoundedRectangle(cornerRadius: UltraLightDesignSystem.radiusL)
                .fill(Color.clear)
                .overlay(
                    RoundedRectangle(cornerRadius: UltraLightDesignSystem.radiusL)
                        .stroke(UltraLightDesignSystem.primaryOrange.opacity(0.1), lineWidth: 1)
                )
        case .gradient:
            RoundedRectangle(cornerRadius: UltraLightDesignSystem.radiusL)
                .fill(
                    LinearGradient(
                        colors: [UltraLightDesignSystem.background, UltraLightDesignSystem.background.opacity(0.8)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        case .premium:
            RoundedRectangle(cornerRadius: UltraLightDesignSystem.radiusL)
                .fill(UltraLightDesignSystem.surface)
                .overlay(
                    RoundedRectangle(cornerRadius: UltraLightDesignSystem.radiusL)
                        .stroke(
                            LinearGradient(
                                colors: [UltraLightDesignSystem.primaryOrange.opacity(0.3), UltraLightDesignSystem.primaryGreen.opacity(0.3)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
        }
    }
    
    private var shadowColor: Color {
        switch style {
        case .standard: return UltraLightDesignSystem.shadowLight
        case .elevated: return UltraLightDesignSystem.shadowMedium
        case .glass: return UltraLightDesignSystem.shadowLight
        case .minimal: return Color.clear
        case .gradient: return UltraLightDesignSystem.shadowLight
        case .premium: return UltraLightDesignSystem.shadowMedium
        }
    }
    
    private var shadowRadius: CGFloat {
        switch style {
        case .standard: return 6
        case .elevated: return 10
        case .glass: return 8
        case .minimal: return 0
        case .gradient: return 6
        case .premium: return 8
        }
    }
    
    private var shadowOffset: CGFloat {
        switch style {
        case .standard: return 2
        case .elevated: return 4
        case .glass: return 3
        case .minimal: return 0
        case .gradient: return 2
        case .premium: return 3
        }
    }
}

struct UltraLightListItem: View {
    let icon: String
    let title: String
    let subtitle: String?
    let value: String?
    let action: (() -> Void)?
    
    init(
        icon: String,
        title: String,
        subtitle: String? = nil,
        value: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
        self.value = value
        self.action = action
    }
    
    var body: some View {
        Button(action: action ?? {}) {
            HStack(spacing: UltraLightDesignSystem.spaceM) {
                // Icon
                ZStack {
                    Circle()
                        .fill(UltraLightDesignSystem.primaryOrange.opacity(0.1))
                        .frame(width: 32, height: 32)
                    
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(UltraLightDesignSystem.primaryOrange)
                }
                
                // Content
                VStack(alignment: .leading, spacing: UltraLightDesignSystem.spaceXS) {
                    Text(title)
                        .font(.system(size: 15, weight: .semibold, design: .rounded))
                        .foregroundColor(UltraLightDesignSystem.text)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .foregroundColor(UltraLightDesignSystem.textSecondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                
                // Value
                if let value = value {
                    Text(value)
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(UltraLightDesignSystem.primaryGreen)
                }
                
                // Chevron
                if action != nil {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(UltraLightDesignSystem.textTertiary)
                }
            }
            .padding(.horizontal, UltraLightDesignSystem.spaceM)
            .padding(.vertical, UltraLightDesignSystem.spaceS)
            .background(UltraLightDesignSystem.background)
            .cornerRadius(UltraLightDesignSystem.radiusM)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Data Models
struct UltraLightRoute: Identifiable {
    let id = UUID()
    let name: String
    let destinations: [String]
    let duration: String
    let description: String
    let difficulty: String
    let budget: String
    let season: String
    let highlights: [String]
    let totalDistance: String
    let transportModes: [String]
    
    init(name: String, destinations: [String], duration: String, description: String = "", difficulty: String = "Medium", budget: String = "€€", season: String = "All Year", highlights: [String] = [], totalDistance: String = "", transportModes: [String] = []) {
        self.name = name
        self.destinations = destinations
        self.duration = duration
        self.description = description
        self.difficulty = difficulty
        self.budget = budget
        self.season = season
        self.highlights = highlights
        self.totalDistance = totalDistance
        self.transportModes = transportModes
    }
}


// MARK: - Ultra Light Nominatim Place View
struct UltraLightNominatimPlaceView: View {
    let place: NominatimPlace
    
    var body: some View {
        UltraLightWindow(style: .glass) {
            HStack(spacing: UltraLightDesignSystem.spaceL) {
                // Place Icon based on type
                ZStack {
                    Circle()
                        .fill(UltraLightDesignSystem.primaryOrange.opacity(0.1))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: place.isCountry ? "flag.fill" : (place.isCity ? "building.2.fill" : "location.fill"))
                        .font(.system(size: 20))
                        .foregroundColor(UltraLightDesignSystem.primaryOrange)
                }
                
                VStack(alignment: .leading, spacing: UltraLightDesignSystem.spaceXS) {
                    Text(place.display_name)
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundColor(UltraLightDesignSystem.text) // ✅ White text for better visibility
                        .lineLimit(2)
                    
                    Text(place.isCountry ? "Country" : (place.isCity ? "City" : "Place"))
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundColor(UltraLightDesignSystem.textSecondary)
                        .lineLimit(1)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(UltraLightDesignSystem.textTertiary)
                    .font(.system(size: 12, weight: .medium))
            }
        }
    }
}