import SwiftUI
import CoreLocation

struct ContentView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @State private var showingAddLocation = false
    @State private var selectedTab = 0
    
    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                HomeView()
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("Home")
                    }
                    .tag(0)
                
                TravelRouteView()
                    .tabItem {
                        Image(systemName: "map.fill")
                        Text("Routes")
                    }
                    .tag(1)
                
                DestinationSelectionView()
                    .tabItem {
                        Image(systemName: "globe.americas.fill")
                        Text("Destinations")
                    }
                    .tag(2)
                
                ProfileSettingsView()
                    .tabItem {
                        Image(systemName: "person.circle.fill")
                        Text("Profile")
                    }
                    .tag(3)
            }
            .accentColor(themeManager.primaryColor)
            .background(themeManager.oledBackgroundColor)
            .preferredColorScheme(themeManager.isDarkMode ? .dark : .light)
            
            // Floating Add Location Button (only show in Routes tab)
            if selectedTab == 1 {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            showingAddLocation = true
                        }) {
                            Image(systemName: "plus")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                                .frame(width: 60, height: 60)
                                .background(Color(red: 1.0, green: 0.4, blue: 0.2)) // Orange
                                .clipShape(Circle())
                                .shadow(color: Color.black.opacity(0.3), radius: 8, x: 0, y: 4)
                        }
                        .padding(.bottom, 60) // Above tab bar
                        Spacer()
                    }
                }
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
                // Background gradient
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.white,
                        Color(red: 1.0, green: 0.95, blue: 0.9)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header
                    HStack {
                        Text("Add Location")
                            .font(.largeTitle)
                            .foregroundColor(.primary)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                    .padding(.bottom, 16)
                    
                    // Date and Nights Selection
                    VStack(spacing: 16) {
                        // Date Picker
                        VStack(spacing: 12) {
                            HStack {
                                Text("Start Date:")
                                    .font(.custom("Inter", size: 16))
                                    .foregroundColor(themeManager.secondaryTextColor)
                                
                                Spacer()
                            }
                            
                            DatePicker("", selection: $selectedDate, displayedComponents: .date)
                                .datePickerStyle(CompactDatePickerStyle())
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(12)
                        }
                        
                        // Nights Selection
                        VStack(spacing: 12) {
                            HStack {
                                Text("Nights to stay:")
                                    .font(.custom("Inter", size: 16))
                                    .foregroundColor(themeManager.secondaryTextColor)
                                
                                Spacer()
                                
                                Text("\(selectedNights) nights")
                                    .font(.custom("Inter", size: 14))
                                    .foregroundColor(Color(red: 1.0, green: 0.4, blue: 0.2))
                            }
                            
                            HStack {
                                Button(action: {
                                    if selectedNights > 1 {
                                        selectedNights -= 1
                                    }
                                }) {
                                    Image(systemName: "minus.circle.fill")
                                        .font(.system(size: 24))
                                        .foregroundColor(selectedNights > 1 ? Color(red: 1.0, green: 0.4, blue: 0.2) : Color.gray)
                                }
                                .disabled(selectedNights <= 1)
                                
                                Spacer()
                                
                                Text("\(selectedNights)")
                                    .font(.custom("Inter", size: 20))
                                    .foregroundColor(themeManager.textColor)
                                    .frame(minWidth: 40)
                                
                                Spacer()
                                
                                Button(action: {
                                    if selectedNights < 14 {
                                        selectedNights += 1
                                    }
                                }) {
                                    Image(systemName: "plus.circle.fill")
                                        .font(.system(size: 24))
                                        .foregroundColor(selectedNights < 14 ? Color(red: 1.0, green: 0.4, blue: 0.2) : Color.gray)
                                }
                                .disabled(selectedNights >= 14)
                            }
                            .padding(.horizontal, 20)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(12)
                        
                        // End Date Display
                        VStack(spacing: 8) {
                            HStack {
                                Text("End Date:")
                                    .font(.custom("Inter", size: 16))
                                    .foregroundColor(themeManager.secondaryTextColor)
                                
                                Spacer()
                            }
                            
                            HStack {
                                Image(systemName: "calendar")
                                    .foregroundColor(Color(red: 1.0, green: 0.4, blue: 0.2))
                                    .font(.system(size: 16))
                                
                                Text(endDateString)
                                    .font(.custom("Inter", size: 16))
                                    .foregroundColor(themeManager.textColor)
                                
                                Spacer()
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(Color.white)
                            .cornerRadius(12)
                            .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                    
                    // Search Bar
                    VStack(spacing: 16) {
                        HStack(spacing: 12) {
                            HStack(spacing: 8) {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(themeManager.secondaryTextColor)
                                    .font(.system(size: 16))
                                
                                TextField("Search destinations...", text: $searchText)
                                    .font(.custom("Inter", size: 16))
                                    .foregroundColor(themeManager.textColor)
                                    .onChange(of: searchText) { _ in
                                        performNominatimSearch()
                                    }
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(15)
                            
                            // Search Status Indicator
                            VStack(spacing: 2) {
                                Image(systemName: "location.fill")
                                    .font(.system(size: 16))
                                Text("OSM")
                                    .font(.system(size: 8))
                            }
                            .foregroundColor(.white)
                            .frame(width: 50, height: 50)
                            .background(Color(red: 1.0, green: 0.4, blue: 0.2))
                            .cornerRadius(25)
                        }
                        .padding(.horizontal, 20)
                        
                        // Search Mode Indicator
                        HStack {
                            Image(systemName: "location.fill")
                                .foregroundColor(Color(red: 1.0, green: 0.4, blue: 0.2))
                                .font(.system(size: 14))
                            
                            Text("OpenStreetMap Suche aktiv")
                                .font(.custom("Inter", size: 14))
                                .foregroundColor(Color(red: 1.0, green: 0.4, blue: 0.2))
                            
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 8)
                        .background(Color(red: 1.0, green: 0.4, blue: 0.2).opacity(0.1))
                        .cornerRadius(8)
                        .padding(.horizontal, 20)
                    }
                    .padding(.bottom, 20)
                    .background(themeManager.oledBackgroundColor)
                    
                    // Main Content - API Results Only
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            if !searchText.isEmpty {
                                // Nominatim API Results
                                if nominatimManager.isLoading {
                                    HStack {
                                        Spacer()
                                        ProgressView()
                                            .scaleEffect(1.2)
                                        Spacer()
                                    }
                                    .padding(.top, 50)
                                } else if nominatimManager.searchResults.isEmpty && !searchText.isEmpty {
                                    VStack(spacing: 16) {
                                        Image(systemName: "magnifyingglass")
                                            .font(.system(size: 48))
                                            .foregroundColor(themeManager.secondaryTextColor)
                                        
                                        Text("Keine Orte gefunden")
                                            .font(.custom("Inter", size: 18))
                                            .foregroundColor(themeManager.textColor)
                                        
                                        Text("Versuche einen anderen Suchbegriff")
                                            .font(.custom("Inter", size: 14))
                                            .foregroundColor(themeManager.secondaryTextColor)
                                    }
                                    .padding(.top, 50)
                                } else {
                                    ForEach(nominatimManager.searchResults) { place in
                                        Button(action: {
                                            onSave(place.display_name, selectedDate, selectedNights)
                                        }) {
                                            NominatimPlaceView(place: place)
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                }
                            } else {
                                VStack(spacing: 16) {
                                    Image(systemName: "location.fill")
                                        .font(.system(size: 48))
                                        .foregroundColor(Color(red: 1.0, green: 0.4, blue: 0.2))
                                    
                                    Text("OpenStreetMap Nominatim Suche")
                                        .font(.custom("Inter", size: 24))
                                        .foregroundColor(themeManager.textColor)
                                    
                                    Text("Gib einen Ort ein um zu suchen")
                                        .font(.custom("Inter", size: 16))
                                        .foregroundColor(themeManager.secondaryTextColor)
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal, 40)
                                    
                                    // Error message display
                                    if let errorMessage = nominatimManager.errorMessage {
                                        Text("Fehler: \(errorMessage)")
                                            .font(.custom("Inter", size: 14))
                                            .foregroundColor(.red)
                                            .multilineTextAlignment(.center)
                                            .padding(.horizontal, 40)
                                    }
                                }
                                .padding(.top, 100)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 8)
                        .padding(.bottom, 100)
                    }
                }
            }
            .navigationBarHidden(true)
            .navigationBarItems(
                leading: Button("Cancel") {
                    onCancel()
                },
                trailing: Button("Done") {
                    onCancel()
                }
            )
        }
    }
}
