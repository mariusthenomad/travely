import SwiftUI

struct DestinationSelectionView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @State private var searchText = ""
    @State private var selectedCategory = "All"
    @State private var showingFilterSheet = false
    @State private var showingCountriesList = false
    @State private var showingCitiesList = false
    
    let categories = ["All", "Europe", "Asia", "Americas", "Africa", "Oceania"]
    
    var filteredCountries: [Country] {
        let filtered = popularCountries.filter { country in
            if selectedCategory == "All" {
                return true
            } else {
                // Map countries to regions
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
                // Map cities to regions based on their country
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
        case "France", "Italy", "Spain", "UK":
            return "Europe"
        case "Japan", "Thailand":
            return "Asia"
        case "USA", "Australia":
            return "Americas"
        default:
            return "All"
        }
    }
    
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient like flights
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.white,
                        Color(red: 1.0, green: 0.95, blue: 0.9) // Light peach/pink
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                // Custom Header
                HStack {
                    Text("Destinations")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
                .padding(.bottom, 16)
                
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
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(15)
                        
                        Button(action: { showingFilterSheet = true }) {
                            Image(systemName: "slider.horizontal.3")
                                .foregroundColor(themeManager.primaryColor)
                                .font(.system(size: 18))
                        }
                        .frame(width: 44, height: 44)
                        .background(Color(red: 1.0, green: 0.4, blue: 0.2).opacity(0.1)) // Orange
                        .cornerRadius(22)
                    }
                    .padding(.horizontal, 20)
                    
                    // Category Filter
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(categories, id: \.self) { category in
                                Button(action: { selectedCategory = category }) {
                                    Text(category)
                                        .font(.custom("Inter", size: 14))
                                        .fontWeight(.medium)
                                        .foregroundColor(selectedCategory == category ? .white : Color(red: 1.0, green: 0.4, blue: 0.2)) // Orange
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 10)
                                        .background(selectedCategory == category ? Color(red: 1.0, green: 0.4, blue: 0.2) : Color.clear) // Orange
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 15)
                                                .stroke(Color(red: 1.0, green: 0.4, blue: 0.2), lineWidth: 1) // Orange
                                        )
                                        .cornerRadius(15)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                }
                .padding(.top, 8)
                .padding(.bottom, 20)
                .background(themeManager.oledBackgroundColor)
                
                // Main Content
                ScrollView {
                    VStack(spacing: 24) {
                        // All Countries Section
                        VStack(alignment: .leading, spacing: 16) {
                            Button(action: { showingCountriesList = true }) {
                                HStack {
                                    Text("All Countries")
                                        .font(.custom("Inter", size: 20))
                                        .fontWeight(.semibold)
                                        .foregroundColor(themeManager.textColor)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(themeManager.secondaryTextColor)
                                        .font(.system(size: 14))
                                }
                                .padding(.horizontal, 20)
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(Array(filteredCountries.prefix(8))) { country in
                                        CountryCard(country: country)
                                    }
                                }
                                .padding(.horizontal, 20)
                            }
                        }
                        
                        // All Cities Section
                        VStack(alignment: .leading, spacing: 16) {
                            Button(action: { showingCitiesList = true }) {
                                HStack {
                                    Text("All Cities")
                                        .font(.custom("Inter", size: 20))
                                        .fontWeight(.semibold)
                                        .foregroundColor(themeManager.textColor)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(themeManager.secondaryTextColor)
                                        .font(.system(size: 14))
                                }
                                .padding(.horizontal, 20)
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(Array(filteredCities.prefix(8))) { city in
                                        CityCard(city: city)
                                    }
                                }
                                .padding(.horizontal, 20)
                            }
                        }
                    }
                    .padding(.top, 8)
                    .padding(.bottom, 100) // Extra space for tab bar
                }
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showingFilterSheet) {
                FilterSheet(selectedCategory: $selectedCategory, categories: categories)
            }
            .sheet(isPresented: $showingCountriesList) {
                CountriesListView(filteredCountries: filteredCountries)
            }
            .sheet(isPresented: $showingCitiesList) {
                CitiesListView(filteredCities: filteredCities)
            }
        }
    }
}

struct CountryCard: View {
    @EnvironmentObject var themeManager: ThemeManager
    let country: Country
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            AsyncImage(url: URL(string: country.imageURL)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                ZStack {
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 1.0, green: 0.4, blue: 0.2).opacity(0.1),
                            Color(red: 1.0, green: 0.4, blue: 0.2).opacity(0.3)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    
                    VStack(spacing: 4) {
                        Image(systemName: "photo")
                            .font(.system(size: 20))
                            .foregroundColor(Color(red: 1.0, green: 0.4, blue: 0.2).opacity(0.6))
                        
                        Text("Loading...")
                            .font(.custom("Inter", size: 10))
                            .foregroundColor(Color(red: 1.0, green: 0.4, blue: 0.2).opacity(0.6))
                    }
                }
            }
            .frame(width: 200, height: 120)
            .cornerRadius(12)
            .clipped()
            
            VStack(alignment: .leading, spacing: 6) {
                Text(country.name)
                    .font(.custom("Inter", size: 16))
                    .fontWeight(.semibold)
                    .foregroundColor(themeManager.textColor)
                    .lineLimit(1)
                
                Text("\(country.cityCount) Cities")
                    .font(.custom("Inter", size: 14))
                    .foregroundColor(themeManager.secondaryTextColor)
            }
            .padding(.horizontal, 12)
            .padding(.bottom, 8)
        }
        .frame(width: 200)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
}

struct CityCard: View {
    @EnvironmentObject var themeManager: ThemeManager
    let city: City
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            AsyncImage(url: URL(string: city.imageURL)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                ZStack {
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 1.0, green: 0.4, blue: 0.2).opacity(0.1),
                            Color(red: 1.0, green: 0.4, blue: 0.2).opacity(0.3)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    
                    VStack(spacing: 4) {
                        Image(systemName: "photo")
                            .font(.system(size: 20))
                            .foregroundColor(Color(red: 1.0, green: 0.4, blue: 0.2).opacity(0.6))
                        
                        Text("Loading...")
                            .font(.custom("Inter", size: 10))
                            .foregroundColor(Color(red: 1.0, green: 0.4, blue: 0.2).opacity(0.6))
                    }
                }
            }
            .frame(width: 200, height: 120)
            .cornerRadius(12)
            .clipped()
            
            VStack(alignment: .leading, spacing: 6) {
                Text(city.name)
                    .font(.custom("Inter", size: 16))
                    .fontWeight(.semibold)
                    .foregroundColor(themeManager.textColor)
                    .lineLimit(1)
                
                Text(city.country)
                    .font(.custom("Inter", size: 14))
                    .foregroundColor(themeManager.secondaryTextColor)
            }
            .padding(.horizontal, 12)
            .padding(.bottom, 8)
        }
        .frame(width: 200)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
}

struct FilterSheet: View {
    @Binding var selectedCategory: String
    let categories: [String]
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Filter by Region")
                    .font(.custom("Inter", size: 20))
                    .fontWeight(.semibold)
                    .foregroundColor(Color(red: 0.11, green: 0.31, blue: 0.85))
                    .padding(.top, 20)
                
                LazyVStack(spacing: 12) {
                    ForEach(categories, id: \.self) { category in
                        Button(action: {
                            selectedCategory = category
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            HStack {
                                Text(category)
                                    .font(.custom("Inter", size: 16))
                                    .foregroundColor(Color(red: 0.11, green: 0.31, blue: 0.85))
                                
                                Spacer()
                                
                                if selectedCategory == category {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(Color(red: 0.11, green: 0.31, blue: 0.85))
                                        .font(.system(size: 16))
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 16)
                            .background(Color.gray.opacity(0.05))
                            .cornerRadius(12)
                        }
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

// Popular Countries Data
let popularCountries = [
    Country(id: 1, name: "Afghanistan", flag: "🇦🇫", imageURL: "https://images.unsplash.com/photo-1502602898536-47ad22581b52?w=400&h=300&fit=crop&crop=center", cityCount: 5),
    Country(id: 2, name: "Albania", flag: "🇦🇱", imageURL: "https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=400&h=300&fit=crop&crop=center", cityCount: 3),
    Country(id: 3, name: "Algeria", flag: "🇩🇿", imageURL: "https://images.unsplash.com/photo-1496442226666-8d4d0e62e6e9?w=400&h=300&fit=crop&crop=center", cityCount: 4),
    Country(id: 4, name: "Andorra", flag: "🇦🇩", imageURL: "https://images.unsplash.com/photo-1552832230-c0197dd311b5?w=400&h=300&fit=crop&crop=center", cityCount: 1),
    Country(id: 5, name: "Angola", flag: "🇦🇴", imageURL: "https://images.unsplash.com/photo-1539037116277-4db20889f2d4?w=400&h=300&fit=crop&crop=center", cityCount: 2),
    Country(id: 6, name: "Antigua and Barbuda", flag: "🇦🇬", imageURL: "https://images.unsplash.com/photo-1563492065-1a120d5d8b96?w=400&h=300&fit=crop&crop=center", cityCount: 1),
    Country(id: 7, name: "Argentina", flag: "🇦🇷", imageURL: "https://images.unsplash.com/photo-1502602898536-47ad22581b52?w=400&h=300&fit=crop&crop=center", cityCount: 8),
    Country(id: 8, name: "Armenia", flag: "🇦🇲", imageURL: "https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=400&h=300&fit=crop&crop=center", cityCount: 2),
    Country(id: 9, name: "Australia", flag: "🇦🇺", imageURL: "https://images.unsplash.com/photo-1496442226666-8d4d0e62e6e9?w=400&h=300&fit=crop&crop=center", cityCount: 12),
    Country(id: 10, name: "Austria", flag: "🇦🇹", imageURL: "https://images.unsplash.com/photo-1552832230-c0197dd311b5?w=400&h=300&fit=crop&crop=center", cityCount: 4),
    Country(id: 11, name: "Azerbaijan", flag: "🇦🇿", imageURL: "https://images.unsplash.com/photo-1539037116277-4db20889f2d4?w=400&h=300&fit=crop&crop=center", cityCount: 3),
    Country(id: 12, name: "Bahamas", flag: "🇧🇸", imageURL: "https://images.unsplash.com/photo-1563492065-1a120d5d8b96?w=400&h=300&fit=crop&crop=center", cityCount: 2),
    Country(id: 13, name: "Bahrain", flag: "🇧🇭", imageURL: "https://images.unsplash.com/photo-1502602898536-47ad22581b52?w=400&h=300&fit=crop&crop=center", cityCount: 1),
    Country(id: 14, name: "Bangladesh", flag: "🇧🇩", imageURL: "https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=400&h=300&fit=crop&crop=center", cityCount: 6),
    Country(id: 15, name: "Barbados", flag: "🇧🇧", imageURL: "https://images.unsplash.com/photo-1496442226666-8d4d0e62e6e9?w=400&h=300&fit=crop&crop=center", cityCount: 1),
    Country(id: 16, name: "Belarus", flag: "🇧🇾", imageURL: "https://images.unsplash.com/photo-1552832230-c0197dd311b5?w=400&h=300&fit=crop&crop=center", cityCount: 3),
    Country(id: 17, name: "Belgium", flag: "🇧🇪", imageURL: "https://images.unsplash.com/photo-1539037116277-4db20889f2d4?w=400&h=300&fit=crop&crop=center", cityCount: 4),
    Country(id: 18, name: "Belize", flag: "🇧🇿", imageURL: "https://images.unsplash.com/photo-1563492065-1a120d5d8b96?w=400&h=300&fit=crop&crop=center", cityCount: 2),
    Country(id: 19, name: "Benin", flag: "🇧🇯", imageURL: "https://images.unsplash.com/photo-1502602898536-47ad22581b52?w=400&h=300&fit=crop&crop=center", cityCount: 2),
    Country(id: 20, name: "Bhutan", flag: "🇧🇹", imageURL: "https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=400&h=300&fit=crop&crop=center", cityCount: 1),
    Country(id: 21, name: "Bolivia", flag: "🇧🇴", imageURL: "https://images.unsplash.com/photo-1496442226666-8d4d0e62e6e9?w=400&h=300&fit=crop&crop=center", cityCount: 3),
    Country(id: 22, name: "Bosnia and Herzegovina", flag: "🇧🇦", imageURL: "https://images.unsplash.com/photo-1552832230-c0197dd311b5?w=400&h=300&fit=crop&crop=center", cityCount: 2),
    Country(id: 23, name: "Botswana", flag: "🇧🇼", imageURL: "https://images.unsplash.com/photo-1539037116277-4db20889f2d4?w=400&h=300&fit=crop&crop=center", cityCount: 2),
    Country(id: 24, name: "Brazil", flag: "🇧🇷", imageURL: "https://images.unsplash.com/photo-1563492065-1a120d5d8b96?w=400&h=300&fit=crop&crop=center", cityCount: 15),
    Country(id: 25, name: "Brunei", flag: "🇧🇳", imageURL: "https://images.unsplash.com/photo-1502602898536-47ad22581b52?w=400&h=300&fit=crop&crop=center", cityCount: 1),
    Country(id: 26, name: "Bulgaria", flag: "🇧🇬", imageURL: "https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=400&h=300&fit=crop&crop=center", cityCount: 3),
    Country(id: 27, name: "Burkina Faso", flag: "🇧🇫", imageURL: "https://images.unsplash.com/photo-1496442226666-8d4d0e62e6e9?w=400&h=300&fit=crop&crop=center", cityCount: 2),
    Country(id: 28, name: "Burundi", flag: "🇧🇮", imageURL: "https://images.unsplash.com/photo-1552832230-c0197dd311b5?w=400&h=300&fit=crop&crop=center", cityCount: 1),
    Country(id: 29, name: "Cabo Verde", flag: "🇨🇻", imageURL: "https://images.unsplash.com/photo-1539037116277-4db20889f2d4?w=400&h=300&fit=crop&crop=center", cityCount: 2),
    Country(id: 30, name: "Cambodia", flag: "🇰🇭", imageURL: "https://images.unsplash.com/photo-1563492065-1a120d5d8b96?w=400&h=300&fit=crop&crop=center", cityCount: 3),
    Country(id: 31, name: "Cameroon", flag: "🇨🇲", imageURL: "https://images.unsplash.com/photo-1502602898536-47ad22581b52?w=400&h=300&fit=crop&crop=center", cityCount: 3),
    Country(id: 32, name: "Canada", flag: "🇨🇦", imageURL: "https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=400&h=300&fit=crop&crop=center", cityCount: 12),
    Country(id: 33, name: "Central African Republic", flag: "🇨🇫", imageURL: "https://images.unsplash.com/photo-1496442226666-8d4d0e62e6e9?w=400&h=300&fit=crop&crop=center", cityCount: 1),
    Country(id: 34, name: "Chad", flag: "🇹🇩", imageURL: "https://images.unsplash.com/photo-1552832230-c0197dd311b5?w=400&h=300&fit=crop&crop=center", cityCount: 2),
    Country(id: 35, name: "Chile", flag: "🇨🇱", imageURL: "https://images.unsplash.com/photo-1539037116277-4db20889f2d4?w=400&h=300&fit=crop&crop=center", cityCount: 4),
    Country(id: 36, name: "China", flag: "🇨🇳", imageURL: "https://images.unsplash.com/photo-1563492065-1a120d5d8b96?w=400&h=300&fit=crop&crop=center", cityCount: 25),
    Country(id: 37, name: "Colombia", flag: "🇨🇴", imageURL: "https://images.unsplash.com/photo-1502602898536-47ad22581b52?w=400&h=300&fit=crop&crop=center", cityCount: 6),
    Country(id: 38, name: "Comoros", flag: "🇰🇲", imageURL: "https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=400&h=300&fit=crop&crop=center", cityCount: 1),
    Country(id: 39, name: "Congo (Republic)", flag: "🇨🇬", imageURL: "https://images.unsplash.com/photo-1496442226666-8d4d0e62e6e9?w=400&h=300&fit=crop&crop=center", cityCount: 2),
    Country(id: 40, name: "Congo (Democratic Republic)", flag: "🇨🇩", imageURL: "https://images.unsplash.com/photo-1552832230-c0197dd311b5?w=400&h=300&fit=crop&crop=center", cityCount: 3),
    Country(id: 41, name: "Costa Rica", flag: "🇨🇷", imageURL: "https://images.unsplash.com/photo-1539037116277-4db20889f2d4?w=400&h=300&fit=crop&crop=center", cityCount: 3),
    Country(id: 42, name: "Croatia", flag: "🇭🇷", imageURL: "https://images.unsplash.com/photo-1563492065-1a120d5d8b96?w=400&h=300&fit=crop&crop=center", cityCount: 4),
    Country(id: 43, name: "Cuba", flag: "🇨🇺", imageURL: "https://images.unsplash.com/photo-1502602898536-47ad22581b52?w=400&h=300&fit=crop&crop=center", cityCount: 3),
    Country(id: 44, name: "Cyprus", flag: "🇨🇾", imageURL: "https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=400&h=300&fit=crop&crop=center", cityCount: 2),
    Country(id: 45, name: "Czechia", flag: "🇨🇿", imageURL: "https://images.unsplash.com/photo-1496442226666-8d4d0e62e6e9?w=400&h=300&fit=crop&crop=center", cityCount: 4),
    Country(id: 46, name: "Denmark", flag: "🇩🇰", imageURL: "https://images.unsplash.com/photo-1552832230-c0197dd311b5?w=400&h=300&fit=crop&crop=center", cityCount: 3),
    Country(id: 47, name: "Djibouti", flag: "🇩🇯", imageURL: "https://images.unsplash.com/photo-1539037116277-4db20889f2d4?w=400&h=300&fit=crop&crop=center", cityCount: 1),
    Country(id: 48, name: "Dominica", flag: "🇩🇲", imageURL: "https://images.unsplash.com/photo-1563492065-1a120d5d8b96?w=400&h=300&fit=crop&crop=center", cityCount: 1),
    Country(id: 49, name: "Dominican Republic", flag: "🇩🇴", imageURL: "https://images.unsplash.com/photo-1502602898536-47ad22581b52?w=400&h=300&fit=crop&crop=center", cityCount: 3),
    Country(id: 50, name: "Ecuador", flag: "🇪🇨", imageURL: "https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=400&h=300&fit=crop&crop=center", cityCount: 3),
    Country(id: 51, name: "Egypt", flag: "🇪🇬", imageURL: "https://images.unsplash.com/photo-1502602898536-47ad22581b52?w=400&h=300&fit=crop&crop=center", cityCount: 8),
    Country(id: 52, name: "El Salvador", flag: "🇸🇻", imageURL: "https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=400&h=300&fit=crop&crop=center", cityCount: 2),
    Country(id: 53, name: "Equatorial Guinea", flag: "🇬🇶", imageURL: "https://images.unsplash.com/photo-1496442226666-8d4d0e62e6e9?w=400&h=300&fit=crop&crop=center", cityCount: 1),
    Country(id: 54, name: "Eritrea", flag: "🇪🇷", imageURL: "https://images.unsplash.com/photo-1552832230-c0197dd311b5?w=400&h=300&fit=crop&crop=center", cityCount: 2),
    Country(id: 55, name: "Estonia", flag: "🇪🇪", imageURL: "https://images.unsplash.com/photo-1539037116277-4db20889f2d4?w=400&h=300&fit=crop&crop=center", cityCount: 2),
    Country(id: 56, name: "Eswatini", flag: "🇸🇿", imageURL: "https://images.unsplash.com/photo-1563492065-1a120d5d8b96?w=400&h=300&fit=crop&crop=center", cityCount: 1),
    Country(id: 57, name: "Ethiopia", flag: "🇪🇹", imageURL: "https://images.unsplash.com/photo-1502602898536-47ad22581b52?w=400&h=300&fit=crop&crop=center", cityCount: 4),
    Country(id: 58, name: "Fiji", flag: "🇫🇯", imageURL: "https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=400&h=300&fit=crop&crop=center", cityCount: 2),
    Country(id: 59, name: "Finland", flag: "🇫🇮", imageURL: "https://images.unsplash.com/photo-1496442226666-8d4d0e62e6e9?w=400&h=300&fit=crop&crop=center", cityCount: 3),
    Country(id: 60, name: "France", flag: "🇫🇷", imageURL: "https://images.unsplash.com/photo-1552832230-c0197dd311b5?w=400&h=300&fit=crop&crop=center", cityCount: 15),
    Country(id: 61, name: "Gabon", flag: "🇬🇦", imageURL: "https://images.unsplash.com/photo-1539037116277-4db20889f2d4?w=400&h=300&fit=crop&crop=center", cityCount: 2),
    Country(id: 62, name: "Gambia", flag: "🇬🇲", imageURL: "https://images.unsplash.com/photo-1563492065-1a120d5d8b96?w=400&h=300&fit=crop&crop=center", cityCount: 1),
    Country(id: 63, name: "Georgia", flag: "🇬🇪", imageURL: "https://images.unsplash.com/photo-1502602898536-47ad22581b52?w=400&h=300&fit=crop&crop=center", cityCount: 3),
    Country(id: 64, name: "Germany", flag: "🇩🇪", imageURL: "https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=400&h=300&fit=crop&crop=center", cityCount: 12),
    Country(id: 65, name: "Ghana", flag: "🇬🇭", imageURL: "https://images.unsplash.com/photo-1496442226666-8d4d0e62e6e9?w=400&h=300&fit=crop&crop=center", cityCount: 4),
    Country(id: 66, name: "Greece", flag: "🇬🇷", imageURL: "https://images.unsplash.com/photo-1552832230-c0197dd311b5?w=400&h=300&fit=crop&crop=center", cityCount: 6),
    Country(id: 67, name: "Grenada", flag: "🇬🇩", imageURL: "https://images.unsplash.com/photo-1539037116277-4db20889f2d4?w=400&h=300&fit=crop&crop=center", cityCount: 1),
    Country(id: 68, name: "Guatemala", flag: "🇬🇹", imageURL: "https://images.unsplash.com/photo-1563492065-1a120d5d8b96?w=400&h=300&fit=crop&crop=center", cityCount: 3),
    Country(id: 69, name: "Guinea", flag: "🇬🇳", imageURL: "https://images.unsplash.com/photo-1502602898536-47ad22581b52?w=400&h=300&fit=crop&crop=center", cityCount: 2),
    Country(id: 70, name: "Guinea-Bissau", flag: "🇬🇼", imageURL: "https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=400&h=300&fit=crop&crop=center", cityCount: 1),
    Country(id: 71, name: "Guyana", flag: "🇬🇾", imageURL: "https://images.unsplash.com/photo-1496442226666-8d4d0e62e6e9?w=400&h=300&fit=crop&crop=center", cityCount: 1),
    Country(id: 72, name: "Haiti", flag: "🇭🇹", imageURL: "https://images.unsplash.com/photo-1552832230-c0197dd311b5?w=400&h=300&fit=crop&crop=center", cityCount: 2),
    Country(id: 73, name: "Honduras", flag: "🇭🇳", imageURL: "https://images.unsplash.com/photo-1539037116277-4db20889f2d4?w=400&h=300&fit=crop&crop=center", cityCount: 2),
    Country(id: 74, name: "Hungary", flag: "🇭🇺", imageURL: "https://images.unsplash.com/photo-1563492065-1a120d5d8b96?w=400&h=300&fit=crop&crop=center", cityCount: 3),
    Country(id: 75, name: "Iceland", flag: "🇮🇸", imageURL: "https://images.unsplash.com/photo-1502602898536-47ad22581b52?w=400&h=300&fit=crop&crop=center", cityCount: 2),
    Country(id: 76, name: "India", flag: "🇮🇳", imageURL: "https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=400&h=300&fit=crop&crop=center", cityCount: 20),
    Country(id: 77, name: "Indonesia", flag: "🇮🇩", imageURL: "https://images.unsplash.com/photo-1496442226666-8d4d0e62e6e9?w=400&h=300&fit=crop&crop=center", cityCount: 12),
    Country(id: 78, name: "Iran", flag: "🇮🇷", imageURL: "https://images.unsplash.com/photo-1552832230-c0197dd311b5?w=400&h=300&fit=crop&crop=center", cityCount: 8),
    Country(id: 79, name: "Iraq", flag: "🇮🇶", imageURL: "https://images.unsplash.com/photo-1539037116277-4db20889f2d4?w=400&h=300&fit=crop&crop=center", cityCount: 4),
    Country(id: 80, name: "Ireland", flag: "🇮🇪", imageURL: "https://images.unsplash.com/photo-1563492065-1a120d5d8b96?w=400&h=300&fit=crop&crop=center", cityCount: 3),
    Country(id: 81, name: "Israel", flag: "🇮🇱", imageURL: "https://images.unsplash.com/photo-1502602898536-47ad22581b52?w=400&h=300&fit=crop&crop=center", cityCount: 4),
    Country(id: 82, name: "Italy", flag: "🇮🇹", imageURL: "https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=400&h=300&fit=crop&crop=center", cityCount: 12),
    Country(id: 83, name: "Jamaica", flag: "🇯🇲", imageURL: "https://images.unsplash.com/photo-1496442226666-8d4d0e62e6e9?w=400&h=300&fit=crop&crop=center", cityCount: 2),
    Country(id: 84, name: "Japan", flag: "🇯🇵", imageURL: "https://images.unsplash.com/photo-1552832230-c0197dd311b5?w=400&h=300&fit=crop&crop=center", cityCount: 8),
    Country(id: 85, name: "Jordan", flag: "🇯🇴", imageURL: "https://images.unsplash.com/photo-1539037116277-4db20889f2d4?w=400&h=300&fit=crop&crop=center", cityCount: 2),
    Country(id: 86, name: "Kazakhstan", flag: "🇰🇿", imageURL: "https://images.unsplash.com/photo-1563492065-1a120d5d8b96?w=400&h=300&fit=crop&crop=center", cityCount: 4),
    Country(id: 87, name: "Kenya", flag: "🇰🇪", imageURL: "https://images.unsplash.com/photo-1502602898536-47ad22581b52?w=400&h=300&fit=crop&crop=center", cityCount: 4),
    Country(id: 88, name: "Kiribati", flag: "🇰🇮", imageURL: "https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=400&h=300&fit=crop&crop=center", cityCount: 1),
    Country(id: 89, name: "Kuwait", flag: "🇰🇼", imageURL: "https://images.unsplash.com/photo-1496442226666-8d4d0e62e6e9?w=400&h=300&fit=crop&crop=center", cityCount: 2),
    Country(id: 90, name: "Kyrgyzstan", flag: "🇰🇬", imageURL: "https://images.unsplash.com/photo-1552832230-c0197dd311b5?w=400&h=300&fit=crop&crop=center", cityCount: 2),
    Country(id: 91, name: "Laos", flag: "🇱🇦", imageURL: "https://images.unsplash.com/photo-1539037116277-4db20889f2d4?w=400&h=300&fit=crop&crop=center", cityCount: 2),
    Country(id: 92, name: "Latvia", flag: "🇱🇻", imageURL: "https://images.unsplash.com/photo-1563492065-1a120d5d8b96?w=400&h=300&fit=crop&crop=center", cityCount: 2),
    Country(id: 93, name: "Lebanon", flag: "🇱🇧", imageURL: "https://images.unsplash.com/photo-1502602898536-47ad22581b52?w=400&h=300&fit=crop&crop=center", cityCount: 2),
    Country(id: 94, name: "Lesotho", flag: "🇱🇸", imageURL: "https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=400&h=300&fit=crop&crop=center", cityCount: 1),
    Country(id: 95, name: "Liberia", flag: "🇱🇷", imageURL: "https://images.unsplash.com/photo-1496442226666-8d4d0e62e6e9?w=400&h=300&fit=crop&crop=center", cityCount: 2),
    Country(id: 96, name: "Libya", flag: "🇱🇾", imageURL: "https://images.unsplash.com/photo-1552832230-c0197dd311b5?w=400&h=300&fit=crop&crop=center", cityCount: 3),
    Country(id: 97, name: "Liechtenstein", flag: "🇱🇮", imageURL: "https://images.unsplash.com/photo-1539037116277-4db20889f2d4?w=400&h=300&fit=crop&crop=center", cityCount: 1),
    Country(id: 98, name: "Lithuania", flag: "🇱🇹", imageURL: "https://images.unsplash.com/photo-1563492065-1a120d5d8b96?w=400&h=300&fit=crop&crop=center", cityCount: 2),
    Country(id: 99, name: "Luxembourg", flag: "🇱🇺", imageURL: "https://images.unsplash.com/photo-1502602898536-47ad22581b52?w=400&h=300&fit=crop&crop=center", cityCount: 1),
    Country(id: 100, name: "Madagascar", flag: "🇲🇬", imageURL: "https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=400&h=300&fit=crop&crop=center", cityCount: 3),
    Country(id: 101, name: "Malawi", flag: "🇲🇼", imageURL: "https://images.unsplash.com/photo-1502602898536-47ad22581b52?w=400&h=300&fit=crop&crop=center", cityCount: 2),
    Country(id: 102, name: "Malaysia", flag: "🇲🇾", imageURL: "https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=400&h=300&fit=crop&crop=center", cityCount: 6),
    Country(id: 103, name: "Maldives", flag: "🇲🇻", imageURL: "https://images.unsplash.com/photo-1496442226666-8d4d0e62e6e9?w=400&h=300&fit=crop&crop=center", cityCount: 1),
    Country(id: 104, name: "Mali", flag: "🇲🇱", imageURL: "https://images.unsplash.com/photo-1552832230-c0197dd311b5?w=400&h=300&fit=crop&crop=center", cityCount: 2),
    Country(id: 105, name: "Malta", flag: "🇲🇹", imageURL: "https://images.unsplash.com/photo-1539037116277-4db20889f2d4?w=400&h=300&fit=crop&crop=center", cityCount: 1),
    Country(id: 106, name: "Marshall Islands", flag: "🇲🇭", imageURL: "https://images.unsplash.com/photo-1563492065-1a120d5d8b96?w=400&h=300&fit=crop&crop=center", cityCount: 1),
    Country(id: 107, name: "Mauritania", flag: "🇲🇷", imageURL: "https://images.unsplash.com/photo-1502602898536-47ad22581b52?w=400&h=300&fit=crop&crop=center", cityCount: 2),
    Country(id: 108, name: "Mauritius", flag: "🇲🇺", imageURL: "https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=400&h=300&fit=crop&crop=center", cityCount: 2),
    Country(id: 109, name: "Mexico", flag: "🇲🇽", imageURL: "https://images.unsplash.com/photo-1496442226666-8d4d0e62e6e9?w=400&h=300&fit=crop&crop=center", cityCount: 12),
    Country(id: 110, name: "Micronesia", flag: "🇫🇲", imageURL: "https://images.unsplash.com/photo-1552832230-c0197dd311b5?w=400&h=300&fit=crop&crop=center", cityCount: 1),
    Country(id: 111, name: "Moldova", flag: "🇲🇩", imageURL: "https://images.unsplash.com/photo-1539037116277-4db20889f2d4?w=400&h=300&fit=crop&crop=center", cityCount: 2),
    Country(id: 112, name: "Monaco", flag: "🇲🇨", imageURL: "https://images.unsplash.com/photo-1563492065-1a120d5d8b96?w=400&h=300&fit=crop&crop=center", cityCount: 1),
    Country(id: 113, name: "Mongolia", flag: "🇲🇳", imageURL: "https://images.unsplash.com/photo-1502602898536-47ad22581b52?w=400&h=300&fit=crop&crop=center", cityCount: 2),
    Country(id: 114, name: "Montenegro", flag: "🇲🇪", imageURL: "https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=400&h=300&fit=crop&crop=center", cityCount: 2),
    Country(id: 115, name: "Morocco", flag: "🇲🇦", imageURL: "https://images.unsplash.com/photo-1496442226666-8d4d0e62e6e9?w=400&h=300&fit=crop&crop=center", cityCount: 6),
    Country(id: 116, name: "Mozambique", flag: "🇲🇿", imageURL: "https://images.unsplash.com/photo-1552832230-c0197dd311b5?w=400&h=300&fit=crop&crop=center", cityCount: 3),
    Country(id: 117, name: "Myanmar", flag: "🇲🇲", imageURL: "https://images.unsplash.com/photo-1539037116277-4db20889f2d4?w=400&h=300&fit=crop&crop=center", cityCount: 4),
    Country(id: 118, name: "Namibia", flag: "🇳🇦", imageURL: "https://images.unsplash.com/photo-1563492065-1a120d5d8b96?w=400&h=300&fit=crop&crop=center", cityCount: 2),
    Country(id: 119, name: "Nauru", flag: "🇳🇷", imageURL: "https://images.unsplash.com/photo-1502602898536-47ad22581b52?w=400&h=300&fit=crop&crop=center", cityCount: 1),
    Country(id: 120, name: "Nepal", flag: "🇳🇵", imageURL: "https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=400&h=300&fit=crop&crop=center", cityCount: 3),
    Country(id: 121, name: "Netherlands", flag: "🇳🇱", imageURL: "https://images.unsplash.com/photo-1496442226666-8d4d0e62e6e9?w=400&h=300&fit=crop&crop=center", cityCount: 6),
    Country(id: 122, name: "New Zealand", flag: "🇳🇿", imageURL: "https://images.unsplash.com/photo-1552832230-c0197dd311b5?w=400&h=300&fit=crop&crop=center", cityCount: 4),
    Country(id: 123, name: "Nicaragua", flag: "🇳🇮", imageURL: "https://images.unsplash.com/photo-1539037116277-4db20889f2d4?w=400&h=300&fit=crop&crop=center", cityCount: 2),
    Country(id: 124, name: "Niger", flag: "🇳🇪", imageURL: "https://images.unsplash.com/photo-1563492065-1a120d5d8b96?w=400&h=300&fit=crop&crop=center", cityCount: 2),
    Country(id: 125, name: "Nigeria", flag: "🇳🇬", imageURL: "https://images.unsplash.com/photo-1502602898536-47ad22581b52?w=400&h=300&fit=crop&crop=center", cityCount: 8),
    Country(id: 126, name: "North Korea", flag: "🇰🇵", imageURL: "https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=400&h=300&fit=crop&crop=center", cityCount: 2),
    Country(id: 127, name: "North Macedonia", flag: "🇲🇰", imageURL: "https://images.unsplash.com/photo-1496442226666-8d4d0e62e6e9?w=400&h=300&fit=crop&crop=center", cityCount: 2),
    Country(id: 128, name: "Norway", flag: "🇳🇴", imageURL: "https://images.unsplash.com/photo-1552832230-c0197dd311b5?w=400&h=300&fit=crop&crop=center", cityCount: 4),
    Country(id: 129, name: "Oman", flag: "🇴🇲", imageURL: "https://images.unsplash.com/photo-1539037116277-4db20889f2d4?w=400&h=300&fit=crop&crop=center", cityCount: 3),
    Country(id: 130, name: "Pakistan", flag: "🇵🇰", imageURL: "https://images.unsplash.com/photo-1563492065-1a120d5d8b96?w=400&h=300&fit=crop&crop=center", cityCount: 8),
    Country(id: 131, name: "Palau", flag: "🇵🇼", imageURL: "https://images.unsplash.com/photo-1502602898536-47ad22581b52?w=400&h=300&fit=crop&crop=center", cityCount: 1),
    Country(id: 132, name: "Palestine", flag: "🇵🇸", imageURL: "https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=400&h=300&fit=crop&crop=center", cityCount: 2),
    Country(id: 133, name: "Panama", flag: "🇵🇦", imageURL: "https://images.unsplash.com/photo-1496442226666-8d4d0e62e6e9?w=400&h=300&fit=crop&crop=center", cityCount: 2),
    Country(id: 134, name: "Papua New Guinea", flag: "🇵🇬", imageURL: "https://images.unsplash.com/photo-1552832230-c0197dd311b5?w=400&h=300&fit=crop&crop=center", cityCount: 2),
    Country(id: 135, name: "Paraguay", flag: "🇵🇾", imageURL: "https://images.unsplash.com/photo-1539037116277-4db20889f2d4?w=400&h=300&fit=crop&crop=center", cityCount: 2),
    Country(id: 136, name: "Peru", flag: "🇵🇪", imageURL: "https://images.unsplash.com/photo-1563492065-1a120d5d8b96?w=400&h=300&fit=crop&crop=center", cityCount: 4),
    Country(id: 137, name: "Philippines", flag: "🇵🇭", imageURL: "https://images.unsplash.com/photo-1502602898536-47ad22581b52?w=400&h=300&fit=crop&crop=center", cityCount: 8),
    Country(id: 138, name: "Poland", flag: "🇵🇱", imageURL: "https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=400&h=300&fit=crop&crop=center", cityCount: 6),
    Country(id: 139, name: "Portugal", flag: "🇵🇹", imageURL: "https://images.unsplash.com/photo-1496442226666-8d4d0e62e6e9?w=400&h=300&fit=crop&crop=center", cityCount: 4),
    Country(id: 140, name: "Qatar", flag: "🇶🇦", imageURL: "https://images.unsplash.com/photo-1552832230-c0197dd311b5?w=400&h=300&fit=crop&crop=center", cityCount: 2),
    Country(id: 141, name: "Romania", flag: "🇷🇴", imageURL: "https://images.unsplash.com/photo-1539037116277-4db20889f2d4?w=400&h=300&fit=crop&crop=center", cityCount: 4),
    Country(id: 142, name: "Russia", flag: "🇷🇺", imageURL: "https://images.unsplash.com/photo-1563492065-1a120d5d8b96?w=400&h=300&fit=crop&crop=center", cityCount: 15),
    Country(id: 143, name: "Rwanda", flag: "🇷🇼", imageURL: "https://images.unsplash.com/photo-1502602898536-47ad22581b52?w=400&h=300&fit=crop&crop=center", cityCount: 2),
    Country(id: 144, name: "Saint Kitts and Nevis", flag: "🇰🇳", imageURL: "https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=400&h=300&fit=crop&crop=center", cityCount: 1),
    Country(id: 145, name: "Saint Lucia", flag: "🇱🇨", imageURL: "https://images.unsplash.com/photo-1496442226666-8d4d0e62e6e9?w=400&h=300&fit=crop&crop=center", cityCount: 1),
    Country(id: 146, name: "Saint Vincent and the Grenadines", flag: "🇻🇨", imageURL: "https://images.unsplash.com/photo-1552832230-c0197dd311b5?w=400&h=300&fit=crop&crop=center", cityCount: 1),
    Country(id: 147, name: "Samoa", flag: "🇼🇸", imageURL: "https://images.unsplash.com/photo-1539037116277-4db20889f2d4?w=400&h=300&fit=crop&crop=center", cityCount: 1),
    Country(id: 148, name: "San Marino", flag: "🇸🇲", imageURL: "https://images.unsplash.com/photo-1563492065-1a120d5d8b96?w=400&h=300&fit=crop&crop=center", cityCount: 1),
    Country(id: 149, name: "São Tomé and Príncipe", flag: "🇸🇹", imageURL: "https://images.unsplash.com/photo-1502602898536-47ad22581b52?w=400&h=300&fit=crop&crop=center", cityCount: 1),
    Country(id: 150, name: "Saudi Arabia", flag: "🇸🇦", imageURL: "https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=400&h=300&fit=crop&crop=center", cityCount: 6),
    Country(id: 151, name: "Senegal", flag: "🇸🇳", imageURL: "https://images.unsplash.com/photo-1502602898536-47ad22581b52?w=400&h=300&fit=crop&crop=center", cityCount: 3),
    Country(id: 152, name: "Serbia", flag: "🇷🇸", imageURL: "https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=400&h=300&fit=crop&crop=center", cityCount: 3),
    Country(id: 153, name: "Seychelles", flag: "🇸🇨", imageURL: "https://images.unsplash.com/photo-1496442226666-8d4d0e62e6e9?w=400&h=300&fit=crop&crop=center", cityCount: 1),
    Country(id: 154, name: "Sierra Leone", flag: "🇸🇱", imageURL: "https://images.unsplash.com/photo-1552832230-c0197dd311b5?w=400&h=300&fit=crop&crop=center", cityCount: 2),
    Country(id: 155, name: "Singapore", flag: "🇸🇬", imageURL: "https://images.unsplash.com/photo-1539037116277-4db20889f2d4?w=400&h=300&fit=crop&crop=center", cityCount: 1),
    Country(id: 156, name: "Slovakia", flag: "🇸🇰", imageURL: "https://images.unsplash.com/photo-1563492065-1a120d5d8b96?w=400&h=300&fit=crop&crop=center", cityCount: 2),
    Country(id: 157, name: "Slovenia", flag: "🇸🇮", imageURL: "https://images.unsplash.com/photo-1502602898536-47ad22581b52?w=400&h=300&fit=crop&crop=center", cityCount: 2),
    Country(id: 158, name: "Solomon Islands", flag: "🇸🇧", imageURL: "https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=400&h=300&fit=crop&crop=center", cityCount: 1),
    Country(id: 159, name: "Somalia", flag: "🇸🇴", imageURL: "https://images.unsplash.com/photo-1496442226666-8d4d0e62e6e9?w=400&h=300&fit=crop&crop=center", cityCount: 2),
    Country(id: 160, name: "South Africa", flag: "🇿🇦", imageURL: "https://images.unsplash.com/photo-1552832230-c0197dd311b5?w=400&h=300&fit=crop&crop=center", cityCount: 8),
    Country(id: 161, name: "South Sudan", flag: "🇸🇸", imageURL: "https://images.unsplash.com/photo-1539037116277-4db20889f2d4?w=400&h=300&fit=crop&crop=center", cityCount: 2),
    Country(id: 162, name: "Spain", flag: "🇪🇸", imageURL: "https://images.unsplash.com/photo-1563492065-1a120d5d8b96?w=400&h=300&fit=crop&crop=center", cityCount: 10),
    Country(id: 163, name: "Sri Lanka", flag: "🇱🇰", imageURL: "https://images.unsplash.com/photo-1502602898536-47ad22581b52?w=400&h=300&fit=crop&crop=center", cityCount: 4),
    Country(id: 164, name: "Sudan", flag: "🇸🇩", imageURL: "https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=400&h=300&fit=crop&crop=center", cityCount: 3),
    Country(id: 165, name: "Suriname", flag: "🇸🇷", imageURL: "https://images.unsplash.com/photo-1496442226666-8d4d0e62e6e9?w=400&h=300&fit=crop&crop=center", cityCount: 1),
    Country(id: 166, name: "Sweden", flag: "🇸🇪", imageURL: "https://images.unsplash.com/photo-1552832230-c0197dd311b5?w=400&h=300&fit=crop&crop=center", cityCount: 4),
    Country(id: 167, name: "Switzerland", flag: "🇨🇭", imageURL: "https://images.unsplash.com/photo-1539037116277-4db20889f2d4?w=400&h=300&fit=crop&crop=center", cityCount: 4),
    Country(id: 168, name: "Syria", flag: "🇸🇾", imageURL: "https://images.unsplash.com/photo-1563492065-1a120d5d8b96?w=400&h=300&fit=crop&crop=center", cityCount: 3),
    Country(id: 169, name: "Tajikistan", flag: "🇹🇯", imageURL: "https://images.unsplash.com/photo-1502602898536-47ad22581b52?w=400&h=300&fit=crop&crop=center", cityCount: 2),
    Country(id: 170, name: "Tanzania", flag: "🇹🇿", imageURL: "https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=400&h=300&fit=crop&crop=center", cityCount: 4),
    Country(id: 171, name: "Thailand", flag: "🇹🇭", imageURL: "https://images.unsplash.com/photo-1496442226666-8d4d0e62e6e9?w=400&h=300&fit=crop&crop=center", cityCount: 6),
    Country(id: 172, name: "Timor-Leste", flag: "🇹🇱", imageURL: "https://images.unsplash.com/photo-1552832230-c0197dd311b5?w=400&h=300&fit=crop&crop=center", cityCount: 1),
    Country(id: 173, name: "Togo", flag: "🇹🇬", imageURL: "https://images.unsplash.com/photo-1539037116277-4db20889f2d4?w=400&h=300&fit=crop&crop=center", cityCount: 2),
    Country(id: 174, name: "Tonga", flag: "🇹🇴", imageURL: "https://images.unsplash.com/photo-1563492065-1a120d5d8b96?w=400&h=300&fit=crop&crop=center", cityCount: 1),
    Country(id: 175, name: "Trinidad and Tobago", flag: "🇹🇹", imageURL: "https://images.unsplash.com/photo-1502602898536-47ad22581b52?w=400&h=300&fit=crop&crop=center", cityCount: 2),
    Country(id: 176, name: "Tunisia", flag: "🇹🇳", imageURL: "https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=400&h=300&fit=crop&crop=center", cityCount: 3),
    Country(id: 177, name: "Turkey", flag: "🇹🇷", imageURL: "https://images.unsplash.com/photo-1496442226666-8d4d0e62e6e9?w=400&h=300&fit=crop&crop=center", cityCount: 8),
    Country(id: 178, name: "Turkmenistan", flag: "🇹🇲", imageURL: "https://images.unsplash.com/photo-1552832230-c0197dd311b5?w=400&h=300&fit=crop&crop=center", cityCount: 2),
    Country(id: 179, name: "Tuvalu", flag: "🇹🇻", imageURL: "https://images.unsplash.com/photo-1539037116277-4db20889f2d4?w=400&h=300&fit=crop&crop=center", cityCount: 1),
    Country(id: 180, name: "Uganda", flag: "🇺🇬", imageURL: "https://images.unsplash.com/photo-1563492065-1a120d5d8b96?w=400&h=300&fit=crop&crop=center", cityCount: 3),
    Country(id: 181, name: "Ukraine", flag: "🇺🇦", imageURL: "https://images.unsplash.com/photo-1502602898536-47ad22581b52?w=400&h=300&fit=crop&crop=center", cityCount: 6),
    Country(id: 182, name: "United Arab Emirates", flag: "🇦🇪", imageURL: "https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=400&h=300&fit=crop&crop=center", cityCount: 4),
    Country(id: 183, name: "United Kingdom", flag: "🇬🇧", imageURL: "https://images.unsplash.com/photo-1496442226666-8d4d0e62e6e9?w=400&h=300&fit=crop&crop=center", cityCount: 8),
    Country(id: 184, name: "United States", flag: "🇺🇸", imageURL: "https://images.unsplash.com/photo-1552832230-c0197dd311b5?w=400&h=300&fit=crop&crop=center", cityCount: 25),
    Country(id: 185, name: "Uruguay", flag: "🇺🇾", imageURL: "https://images.unsplash.com/photo-1539037116277-4db20889f2d4?w=400&h=300&fit=crop&crop=center", cityCount: 2),
    Country(id: 186, name: "Uzbekistan", flag: "🇺🇿", imageURL: "https://images.unsplash.com/photo-1563492065-1a120d5d8b96?w=400&h=300&fit=crop&crop=center", cityCount: 3),
    Country(id: 187, name: "Vanuatu", flag: "🇻🇺", imageURL: "https://images.unsplash.com/photo-1502602898536-47ad22581b52?w=400&h=300&fit=crop&crop=center", cityCount: 1),
    Country(id: 188, name: "Vatican City", flag: "🇻🇦", imageURL: "https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=400&h=300&fit=crop&crop=center", cityCount: 1),
    Country(id: 189, name: "Venezuela", flag: "🇻🇪", imageURL: "https://images.unsplash.com/photo-1496442226666-8d4d0e62e6e9?w=400&h=300&fit=crop&crop=center", cityCount: 4),
    Country(id: 190, name: "Vietnam", flag: "🇻🇳", imageURL: "https://images.unsplash.com/photo-1552832230-c0197dd311b5?w=400&h=300&fit=crop&crop=center", cityCount: 6),
    Country(id: 191, name: "Yemen", flag: "🇾🇪", imageURL: "https://images.unsplash.com/photo-1539037116277-4db20889f2d4?w=400&h=300&fit=crop&crop=center", cityCount: 3),
    Country(id: 192, name: "Zambia", flag: "🇿🇲", imageURL: "https://images.unsplash.com/photo-1563492065-1a120d5d8b96?w=400&h=300&fit=crop&crop=center", cityCount: 2),
    Country(id: 193, name: "Zimbabwe", flag: "🇿🇼", imageURL: "https://images.unsplash.com/photo-1502602898536-47ad22581b52?w=400&h=300&fit=crop&crop=center", cityCount: 2)
]

// Popular Cities Data
let popularCities = [
    // Afghanistan 🇦🇫
    City(id: 1, name: "Kabul", country: "Afghanistan", imageURL: "https://images.unsplash.com/photo-1502602898536-47ad22581b52?w=400&h=300&fit=crop&crop=center"),
    City(id: 2, name: "Kandahar", country: "Afghanistan", imageURL: "https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=400&h=300&fit=crop&crop=center"),
    City(id: 3, name: "Herat", country: "Afghanistan", imageURL: "https://images.unsplash.com/photo-1496442226666-8d4d0e62e6e9?w=400&h=300&fit=crop&crop=center"),
    City(id: 4, name: "Mazar-i-Sharif", country: "Afghanistan", imageURL: "https://images.unsplash.com/photo-1552832230-c0197dd311b5?w=400&h=300&fit=crop&crop=center"),
    
    // Albania 🇦🇱
    City(id: 5, name: "Tirana", country: "Albania", imageURL: "https://images.unsplash.com/photo-1539037116277-4db20889f2d4?w=400&h=300&fit=crop&crop=center"),
    City(id: 6, name: "Durrës", country: "Albania", imageURL: "https://images.unsplash.com/photo-1563492065-1a120d5d8b96?w=400&h=300&fit=crop&crop=center"),
    City(id: 7, name: "Shkodër", country: "Albania", imageURL: "https://images.unsplash.com/photo-1502602898536-47ad22581b52?w=400&h=300&fit=crop&crop=center"),
    City(id: 8, name: "Vlorë", country: "Albania", imageURL: "https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=400&h=300&fit=crop&crop=center"),
    
    // Algeria 🇩🇿
    City(id: 9, name: "Algiers", country: "Algeria", imageURL: "https://images.unsplash.com/photo-1496442226666-8d4d0e62e6e9?w=400&h=300&fit=crop&crop=center"),
    City(id: 10, name: "Oran", country: "Algeria", imageURL: "https://images.unsplash.com/photo-1552832230-c0197dd311b5?w=400&h=300&fit=crop&crop=center"),
    City(id: 11, name: "Constantine", country: "Algeria", imageURL: "https://images.unsplash.com/photo-1539037116277-4db20889f2d4?w=400&h=300&fit=crop&crop=center"),
    City(id: 12, name: "Annaba", country: "Algeria", imageURL: "https://images.unsplash.com/photo-1563492065-1a120d5d8b96?w=400&h=300&fit=crop&crop=center"),
    City(id: 13, name: "Blida", country: "Algeria", imageURL: "https://images.unsplash.com/photo-1502602898536-47ad22581b52?w=400&h=300&fit=crop&crop=center"),
    
    // Andorra 🇦🇩
    City(id: 14, name: "Andorra la Vella", country: "Andorra", imageURL: "https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=400&h=300&fit=crop&crop=center"),
    City(id: 15, name: "Escaldes-Engordany", country: "Andorra", imageURL: "https://images.unsplash.com/photo-1496442226666-8d4d0e62e6e9?w=400&h=300&fit=crop&crop=center"),
    City(id: 16, name: "Encamp", country: "Andorra", imageURL: "https://images.unsplash.com/photo-1552832230-c0197dd311b5?w=400&h=300&fit=crop&crop=center"),
    
    // Angola 🇦🇴
    City(id: 17, name: "Luanda", country: "Angola", imageURL: "https://images.unsplash.com/photo-1539037116277-4db20889f2d4?w=400&h=300&fit=crop&crop=center"),
    City(id: 18, name: "Huambo", country: "Angola", imageURL: "https://images.unsplash.com/photo-1563492065-1a120d5d8b96?w=400&h=300&fit=crop&crop=center"),
    City(id: 19, name: "Benguela", country: "Angola", imageURL: "https://images.unsplash.com/photo-1502602898536-47ad22581b52?w=400&h=300&fit=crop&crop=center"),
    City(id: 20, name: "Lubango", country: "Angola", imageURL: "https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=400&h=300&fit=crop&crop=center"),
    
    // Antigua and Barbuda 🇦🇬
    City(id: 21, name: "St. John's", country: "Antigua and Barbuda", imageURL: "https://images.unsplash.com/photo-1496442226666-8d4d0e62e6e9?w=400&h=300&fit=crop&crop=center"),
    City(id: 22, name: "All Saints", country: "Antigua and Barbuda", imageURL: "https://images.unsplash.com/photo-1552832230-c0197dd311b5?w=400&h=300&fit=crop&crop=center"),
    City(id: 23, name: "Liberta", country: "Antigua and Barbuda", imageURL: "https://images.unsplash.com/photo-1539037116277-4db20889f2d4?w=400&h=300&fit=crop&crop=center"),
    
    // Argentina 🇦🇷
    City(id: 24, name: "Buenos Aires", country: "Argentina", imageURL: "https://images.unsplash.com/photo-1563492065-1a120d5d8b96?w=400&h=300&fit=crop&crop=center"),
    City(id: 25, name: "Córdoba", country: "Argentina", imageURL: "https://images.unsplash.com/photo-1502602898536-47ad22581b52?w=400&h=300&fit=crop&crop=center"),
    City(id: 26, name: "Rosario", country: "Argentina", imageURL: "https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=400&h=300&fit=crop&crop=center"),
    City(id: 27, name: "Mendoza", country: "Argentina", imageURL: "https://images.unsplash.com/photo-1496442226666-8d4d0e62e6e9?w=400&h=300&fit=crop&crop=center"),
    City(id: 28, name: "La Plata", country: "Argentina", imageURL: "https://images.unsplash.com/photo-1552832230-c0197dd311b5?w=400&h=300&fit=crop&crop=center"),
    
    // Armenia 🇦🇲
    City(id: 29, name: "Yerevan", country: "Armenia", imageURL: "https://images.unsplash.com/photo-1539037116277-4db20889f2d4?w=400&h=300&fit=crop&crop=center"),
    City(id: 30, name: "Gyumri", country: "Armenia", imageURL: "https://images.unsplash.com/photo-1563492065-1a120d5d8b96?w=400&h=300&fit=crop&crop=center"),
    City(id: 31, name: "Vanadzor", country: "Armenia", imageURL: "https://images.unsplash.com/photo-1502602898536-47ad22581b52?w=400&h=300&fit=crop&crop=center"),
    
    // Australia 🇦🇺
    City(id: 32, name: "Canberra", country: "Australia", imageURL: "https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=400&h=300&fit=crop&crop=center"),
    City(id: 33, name: "Sydney", country: "Australia", imageURL: "https://images.unsplash.com/photo-1496442226666-8d4d0e62e6e9?w=400&h=300&fit=crop&crop=center"),
    City(id: 34, name: "Melbourne", country: "Australia", imageURL: "https://images.unsplash.com/photo-1552832230-c0197dd311b5?w=400&h=300&fit=crop&crop=center"),
    City(id: 35, name: "Brisbane", country: "Australia", imageURL: "https://images.unsplash.com/photo-1539037116277-4db20889f2d4?w=400&h=300&fit=crop&crop=center"),
    City(id: 36, name: "Perth", country: "Australia", imageURL: "https://images.unsplash.com/photo-1563492065-1a120d5d8b96?w=400&h=300&fit=crop&crop=center"),
    City(id: 37, name: "Adelaide", country: "Australia", imageURL: "https://images.unsplash.com/photo-1502602898536-47ad22581b52?w=400&h=300&fit=crop&crop=center"),
    
    // Austria 🇦🇹
    City(id: 38, name: "Vienna", country: "Austria", imageURL: "https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=400&h=300&fit=crop&crop=center"),
    City(id: 39, name: "Graz", country: "Austria", imageURL: "https://images.unsplash.com/photo-1496442226666-8d4d0e62e6e9?w=400&h=300&fit=crop&crop=center"),
    City(id: 40, name: "Linz", country: "Austria", imageURL: "https://images.unsplash.com/photo-1552832230-c0197dd311b5?w=400&h=300&fit=crop&crop=center"),
    City(id: 41, name: "Salzburg", country: "Austria", imageURL: "https://images.unsplash.com/photo-1539037116277-4db20889f2d4?w=400&h=300&fit=crop&crop=center"),
    City(id: 42, name: "Innsbruck", country: "Austria", imageURL: "https://images.unsplash.com/photo-1563492065-1a120d5d8b96?w=400&h=300&fit=crop&crop=center"),
    
    // Azerbaijan 🇦🇿
    City(id: 43, name: "Baku", country: "Azerbaijan", imageURL: "https://images.unsplash.com/photo-1502602898536-47ad22581b52?w=400&h=300&fit=crop&crop=center"),
    City(id: 44, name: "Ganja", country: "Azerbaijan", imageURL: "https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=400&h=300&fit=crop&crop=center"),
    City(id: 45, name: "Sumqayit", country: "Azerbaijan", imageURL: "https://images.unsplash.com/photo-1496442226666-8d4d0e62e6e9?w=400&h=300&fit=crop&crop=center"),
    City(id: 46, name: "Mingachevir", country: "Azerbaijan", imageURL: "https://images.unsplash.com/photo-1552832230-c0197dd311b5?w=400&h=300&fit=crop&crop=center"),
    
    // Bahamas 🇧🇸
    City(id: 47, name: "Nassau", country: "Bahamas", imageURL: "https://images.unsplash.com/photo-1539037116277-4db20889f2d4?w=400&h=300&fit=crop&crop=center"),
    City(id: 48, name: "Freeport", country: "Bahamas", imageURL: "https://images.unsplash.com/photo-1563492065-1a120d5d8b96?w=400&h=300&fit=crop&crop=center"),
    City(id: 49, name: "Marsh Harbour", country: "Bahamas", imageURL: "https://images.unsplash.com/photo-1502602898536-47ad22581b52?w=400&h=300&fit=crop&crop=center"),
    
    // Bahrain 🇧🇭
    City(id: 50, name: "Manama", country: "Bahrain", imageURL: "https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=400&h=300&fit=crop&crop=center"),
    City(id: 51, name: "Riffa", country: "Bahrain", imageURL: "https://images.unsplash.com/photo-1496442226666-8d4d0e62e6e9?w=400&h=300&fit=crop&crop=center"),
    City(id: 52, name: "Muharraq", country: "Bahrain", imageURL: "https://images.unsplash.com/photo-1552832230-c0197dd311b5?w=400&h=300&fit=crop&crop=center"),
    
    // Bangladesh 🇧🇩
    City(id: 53, name: "Dhaka", country: "Bangladesh", imageURL: "https://images.unsplash.com/photo-1539037116277-4db20889f2d4?w=400&h=300&fit=crop&crop=center"),
    City(id: 54, name: "Chittagong", country: "Bangladesh", imageURL: "https://images.unsplash.com/photo-1563492065-1a120d5d8b96?w=400&h=300&fit=crop&crop=center"),
    City(id: 55, name: "Khulna", country: "Bangladesh", imageURL: "https://images.unsplash.com/photo-1502602898536-47ad22581b52?w=400&h=300&fit=crop&crop=center"),
    City(id: 56, name: "Rajshahi", country: "Bangladesh", imageURL: "https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=400&h=300&fit=crop&crop=center"),
    City(id: 57, name: "Sylhet", country: "Bangladesh", imageURL: "https://images.unsplash.com/photo-1496442226666-8d4d0e62e6e9?w=400&h=300&fit=crop&crop=center"),
    
    // Barbados 🇧🇧
    City(id: 58, name: "Bridgetown", country: "Barbados", imageURL: "https://images.unsplash.com/photo-1552832230-c0197dd311b5?w=400&h=300&fit=crop&crop=center"),
    City(id: 59, name: "Speightstown", country: "Barbados", imageURL: "https://images.unsplash.com/photo-1539037116277-4db20889f2d4?w=400&h=300&fit=crop&crop=center"),
    City(id: 60, name: "Oistins", country: "Barbados", imageURL: "https://images.unsplash.com/photo-1563492065-1a120d5d8b96?w=400&h=300&fit=crop&crop=center"),
    
    // Belarus 🇧🇾
    City(id: 61, name: "Minsk", country: "Belarus", imageURL: "https://images.unsplash.com/photo-1502602898536-47ad22581b52?w=400&h=300&fit=crop&crop=center"),
    City(id: 62, name: "Gomel", country: "Belarus", imageURL: "https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=400&h=300&fit=crop&crop=center"),
    City(id: 63, name: "Mogilev", country: "Belarus", imageURL: "https://images.unsplash.com/photo-1496442226666-8d4d0e62e6e9?w=400&h=300&fit=crop&crop=center"),
    City(id: 64, name: "Vitebsk", country: "Belarus", imageURL: "https://images.unsplash.com/photo-1552832230-c0197dd311b5?w=400&h=300&fit=crop&crop=center"),
    City(id: 65, name: "Brest", country: "Belarus", imageURL: "https://images.unsplash.com/photo-1539037116277-4db20889f2d4?w=400&h=300&fit=crop&crop=center"),
    City(id: 66, name: "Grodno", country: "Belarus", imageURL: "https://images.unsplash.com/photo-1563492065-1a120d5d8b96?w=400&h=300&fit=crop&crop=center"),
    
    // Belgium 🇧🇪
    City(id: 67, name: "Brussels", country: "Belgium", imageURL: "https://images.unsplash.com/photo-1502602898536-47ad22581b52?w=400&h=300&fit=crop&crop=center"),
    City(id: 68, name: "Antwerp", country: "Belgium", imageURL: "https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=400&h=300&fit=crop&crop=center"),
    City(id: 69, name: "Ghent", country: "Belgium", imageURL: "https://images.unsplash.com/photo-1496442226666-8d4d0e62e6e9?w=400&h=300&fit=crop&crop=center"),
    City(id: 70, name: "Bruges", country: "Belgium", imageURL: "https://images.unsplash.com/photo-1552832230-c0197dd311b5?w=400&h=300&fit=crop&crop=center"),
    City(id: 71, name: "Liège", country: "Belgium", imageURL: "https://images.unsplash.com/photo-1539037116277-4db20889f2d4?w=400&h=300&fit=crop&crop=center"),
    
    // Belize 🇧🇿
    City(id: 72, name: "Belmopan", country: "Belize", imageURL: "https://images.unsplash.com/photo-1563492065-1a120d5d8b96?w=400&h=300&fit=crop&crop=center"),
    City(id: 73, name: "Belize City", country: "Belize", imageURL: "https://images.unsplash.com/photo-1502602898536-47ad22581b52?w=400&h=300&fit=crop&crop=center"),
    City(id: 74, name: "San Ignacio", country: "Belize", imageURL: "https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=400&h=300&fit=crop&crop=center"),
    City(id: 75, name: "Orange Walk Town", country: "Belize", imageURL: "https://images.unsplash.com/photo-1496442226666-8d4d0e62e6e9?w=400&h=300&fit=crop&crop=center"),
    
    // Benin 🇧🇯
    City(id: 76, name: "Porto-Novo", country: "Benin", imageURL: "https://images.unsplash.com/photo-1552832230-c0197dd311b5?w=400&h=300&fit=crop&crop=center"),
    City(id: 77, name: "Cotonou", country: "Benin", imageURL: "https://images.unsplash.com/photo-1539037116277-4db20889f2d4?w=400&h=300&fit=crop&crop=center"),
    City(id: 78, name: "Parakou", country: "Benin", imageURL: "https://images.unsplash.com/photo-1563492065-1a120d5d8b96?w=400&h=300&fit=crop&crop=center"),
    City(id: 79, name: "Abomey", country: "Benin", imageURL: "https://images.unsplash.com/photo-1502602898536-47ad22581b52?w=400&h=300&fit=crop&crop=center"),
    
    // Bhutan 🇧🇹
    City(id: 80, name: "Thimphu", country: "Bhutan", imageURL: "https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=400&h=300&fit=crop&crop=center"),
    City(id: 81, name: "Phuntsholing", country: "Bhutan", imageURL: "https://images.unsplash.com/photo-1496442226666-8d4d0e62e6e9?w=400&h=300&fit=crop&crop=center"),
    City(id: 82, name: "Paro", country: "Bhutan", imageURL: "https://images.unsplash.com/photo-1552832230-c0197dd311b5?w=400&h=300&fit=crop&crop=center"),
    
    // Bolivia 🇧🇴
    City(id: 83, name: "Sucre", country: "Bolivia", imageURL: "https://images.unsplash.com/photo-1539037116277-4db20889f2d4?w=400&h=300&fit=crop&crop=center"),
    City(id: 84, name: "La Paz", country: "Bolivia", imageURL: "https://images.unsplash.com/photo-1563492065-1a120d5d8b96?w=400&h=300&fit=crop&crop=center"),
    City(id: 85, name: "Santa Cruz de la Sierra", country: "Bolivia", imageURL: "https://images.unsplash.com/photo-1502602898536-47ad22581b52?w=400&h=300&fit=crop&crop=center"),
    City(id: 86, name: "Cochabamba", country: "Bolivia", imageURL: "https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=400&h=300&fit=crop&crop=center"),
    City(id: 87, name: "El Alto", country: "Bolivia", imageURL: "https://images.unsplash.com/photo-1496442226666-8d4d0e62e6e9?w=400&h=300&fit=crop&crop=center"),
    
    // Bosnia and Herzegovina 🇧🇦
    City(id: 88, name: "Sarajevo", country: "Bosnia and Herzegovina", imageURL: "https://images.unsplash.com/photo-1552832230-c0197dd311b5?w=400&h=300&fit=crop&crop=center"),
    City(id: 89, name: "Banja Luka", country: "Bosnia and Herzegovina", imageURL: "https://images.unsplash.com/photo-1539037116277-4db20889f2d4?w=400&h=300&fit=crop&crop=center"),
    City(id: 90, name: "Mostar", country: "Bosnia and Herzegovina", imageURL: "https://images.unsplash.com/photo-1563492065-1a120d5d8b96?w=400&h=300&fit=crop&crop=center"),
    City(id: 91, name: "Tuzla", country: "Bosnia and Herzegovina", imageURL: "https://images.unsplash.com/photo-1502602898536-47ad22581b52?w=400&h=300&fit=crop&crop=center"),
    
    // Botswana 🇧🇼
    City(id: 92, name: "Gaborone", country: "Botswana", imageURL: "https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=400&h=300&fit=crop&crop=center"),
    City(id: 93, name: "Francistown", country: "Botswana", imageURL: "https://images.unsplash.com/photo-1496442226666-8d4d0e62e6e9?w=400&h=300&fit=crop&crop=center"),
    City(id: 94, name: "Maun", country: "Botswana", imageURL: "https://images.unsplash.com/photo-1552832230-c0197dd311b5?w=400&h=300&fit=crop&crop=center"),
    
    // Brazil 🇧🇷
    City(id: 95, name: "Brasília", country: "Brazil", imageURL: "https://images.unsplash.com/photo-1539037116277-4db20889f2d4?w=400&h=300&fit=crop&crop=center"),
    City(id: 96, name: "São Paulo", country: "Brazil", imageURL: "https://images.unsplash.com/photo-1563492065-1a120d5d8b96?w=400&h=300&fit=crop&crop=center"),
    City(id: 97, name: "Rio de Janeiro", country: "Brazil", imageURL: "https://images.unsplash.com/photo-1502602898536-47ad22581b52?w=400&h=300&fit=crop&crop=center"),
    City(id: 98, name: "Salvador", country: "Brazil", imageURL: "https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=400&h=300&fit=crop&crop=center"),
    City(id: 99, name: "Fortaleza", country: "Brazil", imageURL: "https://images.unsplash.com/photo-1496442226666-8d4d0e62e6e9?w=400&h=300&fit=crop&crop=center"),
    City(id: 100, name: "Belo Horizonte", country: "Brazil", imageURL: "https://images.unsplash.com/photo-1552832230-c0197dd311b5?w=400&h=300&fit=crop&crop=center"),
    City(id: 101, name: "Manaus", country: "Brazil", imageURL: "https://images.unsplash.com/photo-1539037116277-4db20889f2d4?w=400&h=300&fit=crop&crop=center"),
    City(id: 102, name: "Curitiba", country: "Brazil", imageURL: "https://images.unsplash.com/photo-1563492065-1a120d5d8b96?w=400&h=300&fit=crop&crop=center"),
    
    // Brunei 🇧🇳
    City(id: 103, name: "Bandar Seri Begawan", country: "Brunei", imageURL: "https://images.unsplash.com/photo-1502602898536-47ad22581b52?w=400&h=300&fit=crop&crop=center"),
    City(id: 104, name: "Kuala Belait", country: "Brunei", imageURL: "https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=400&h=300&fit=crop&crop=center"),
    City(id: 105, name: "Seria", country: "Brunei", imageURL: "https://images.unsplash.com/photo-1496442226666-8d4d0e62e6e9?w=400&h=300&fit=crop&crop=center"),
    
    // Bulgaria 🇧🇬
    City(id: 106, name: "Sofia", country: "Bulgaria", imageURL: "https://images.unsplash.com/photo-1552832230-c0197dd311b5?w=400&h=300&fit=crop&crop=center"),
    City(id: 107, name: "Plovdiv", country: "Bulgaria", imageURL: "https://images.unsplash.com/photo-1539037116277-4db20889f2d4?w=400&h=300&fit=crop&crop=center"),
    City(id: 108, name: "Varna", country: "Bulgaria", imageURL: "https://images.unsplash.com/photo-1563492065-1a120d5d8b96?w=400&h=300&fit=crop&crop=center"),
    City(id: 109, name: "Burgas", country: "Bulgaria", imageURL: "https://images.unsplash.com/photo-1502602898536-47ad22581b52?w=400&h=300&fit=crop&crop=center"),
    City(id: 110, name: "Ruse", country: "Bulgaria", imageURL: "https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=400&h=300&fit=crop&crop=center"),
    
    // Burkina Faso 🇧🇫
    City(id: 111, name: "Ouagadougou", country: "Burkina Faso", imageURL: "https://images.unsplash.com/photo-1496442226666-8d4d0e62e6e9?w=400&h=300&fit=crop&crop=center"),
    City(id: 112, name: "Bobo-Dioulasso", country: "Burkina Faso", imageURL: "https://images.unsplash.com/photo-1552832230-c0197dd311b5?w=400&h=300&fit=crop&crop=center"),
    City(id: 113, name: "Koudougou", country: "Burkina Faso", imageURL: "https://images.unsplash.com/photo-1539037116277-4db20889f2d4?w=400&h=300&fit=crop&crop=center"),
    
    // Burundi 🇧🇮
    City(id: 114, name: "Gitega", country: "Burundi", imageURL: "https://images.unsplash.com/photo-1563492065-1a120d5d8b96?w=400&h=300&fit=crop&crop=center"),
    City(id: 115, name: "Bujumbura", country: "Burundi", imageURL: "https://images.unsplash.com/photo-1502602898536-47ad22581b52?w=400&h=300&fit=crop&crop=center"),
    City(id: 116, name: "Ngozi", country: "Burundi", imageURL: "https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=400&h=300&fit=crop&crop=center"),
    
    // Cabo Verde 🇨🇻
    City(id: 117, name: "Praia", country: "Cabo Verde", imageURL: "https://images.unsplash.com/photo-1496442226666-8d4d0e62e6e9?w=400&h=300&fit=crop&crop=center"),
    City(id: 118, name: "Mindelo", country: "Cabo Verde", imageURL: "https://images.unsplash.com/photo-1552832230-c0197dd311b5?w=400&h=300&fit=crop&crop=center"),
    City(id: 119, name: "Santa Maria", country: "Cabo Verde", imageURL: "https://images.unsplash.com/photo-1539037116277-4db20889f2d4?w=400&h=300&fit=crop&crop=center"),
    
    // Cambodia 🇰🇭
    City(id: 120, name: "Phnom Penh", country: "Cambodia", imageURL: "https://images.unsplash.com/photo-1563492065-1a120d5d8b96?w=400&h=300&fit=crop&crop=center"),
    City(id: 121, name: "Siem Reap", country: "Cambodia", imageURL: "https://images.unsplash.com/photo-1502602898536-47ad22581b52?w=400&h=300&fit=crop&crop=center"),
    City(id: 122, name: "Battambang", country: "Cambodia", imageURL: "https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=400&h=300&fit=crop&crop=center"),
    City(id: 123, name: "Sihanoukville", country: "Cambodia", imageURL: "https://images.unsplash.com/photo-1496442226666-8d4d0e62e6e9?w=400&h=300&fit=crop&crop=center"),
    
    // Cameroon 🇨🇲
    City(id: 124, name: "Yaoundé", country: "Cameroon", imageURL: "https://images.unsplash.com/photo-1552832230-c0197dd311b5?w=400&h=300&fit=crop&crop=center"),
    City(id: 125, name: "Douala", country: "Cameroon", imageURL: "https://images.unsplash.com/photo-1539037116277-4db20889f2d4?w=400&h=300&fit=crop&crop=center"),
    City(id: 126, name: "Garoua", country: "Cameroon", imageURL: "https://images.unsplash.com/photo-1563492065-1a120d5d8b96?w=400&h=300&fit=crop&crop=center"),
    City(id: 127, name: "Bamenda", country: "Cameroon", imageURL: "https://images.unsplash.com/photo-1502602898536-47ad22581b52?w=400&h=300&fit=crop&crop=center"),
    
    // Canada 🇨🇦
    City(id: 128, name: "Ottawa", country: "Canada", imageURL: "https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=400&h=300&fit=crop&crop=center"),
    City(id: 129, name: "Toronto", country: "Canada", imageURL: "https://images.unsplash.com/photo-1496442226666-8d4d0e62e6e9?w=400&h=300&fit=crop&crop=center"),
    City(id: 130, name: "Montreal", country: "Canada", imageURL: "https://images.unsplash.com/photo-1552832230-c0197dd311b5?w=400&h=300&fit=crop&crop=center"),
    City(id: 131, name: "Vancouver", country: "Canada", imageURL: "https://images.unsplash.com/photo-1539037116277-4db20889f2d4?w=400&h=300&fit=crop&crop=center"),
    City(id: 132, name: "Calgary", country: "Canada", imageURL: "https://images.unsplash.com/photo-1563492065-1a120d5d8b96?w=400&h=300&fit=crop&crop=center"),
    City(id: 133, name: "Edmonton", country: "Canada", imageURL: "https://images.unsplash.com/photo-1502602898536-47ad22581b52?w=400&h=300&fit=crop&crop=center"),
    City(id: 134, name: "Quebec City", country: "Canada", imageURL: "https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=400&h=300&fit=crop&crop=center"),
    
    // Central African Republic 🇨🇫
    City(id: 135, name: "Bangui", country: "Central African Republic", imageURL: "https://images.unsplash.com/photo-1496442226666-8d4d0e62e6e9?w=400&h=300&fit=crop&crop=center"),
    City(id: 136, name: "Bimbo", country: "Central African Republic", imageURL: "https://images.unsplash.com/photo-1552832230-c0197dd311b5?w=400&h=300&fit=crop&crop=center"),
    City(id: 137, name: "Berbérati", country: "Central African Republic", imageURL: "https://images.unsplash.com/photo-1539037116277-4db20889f2d4?w=400&h=300&fit=crop&crop=center"),
    
    // Chad 🇹🇩
    City(id: 138, name: "N'Djamena", country: "Chad", imageURL: "https://images.unsplash.com/photo-1563492065-1a120d5d8b96?w=400&h=300&fit=crop&crop=center"),
    City(id: 139, name: "Moundou", country: "Chad", imageURL: "https://images.unsplash.com/photo-1502602898536-47ad22581b52?w=400&h=300&fit=crop&crop=center"),
    City(id: 140, name: "Sarh", country: "Chad", imageURL: "https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=400&h=300&fit=crop&crop=center"),
    
    // Chile 🇨🇱
    City(id: 141, name: "Santiago", country: "Chile", imageURL: "https://images.unsplash.com/photo-1496442226666-8d4d0e62e6e9?w=400&h=300&fit=crop&crop=center"),
    City(id: 142, name: "Valparaíso", country: "Chile", imageURL: "https://images.unsplash.com/photo-1552832230-c0197dd311b5?w=400&h=300&fit=crop&crop=center"),
    City(id: 143, name: "Concepción", country: "Chile", imageURL: "https://images.unsplash.com/photo-1539037116277-4db20889f2d4?w=400&h=300&fit=crop&crop=center"),
    City(id: 144, name: "La Serena", country: "Chile", imageURL: "https://images.unsplash.com/photo-1563492065-1a120d5d8b96?w=400&h=300&fit=crop&crop=center"),
    City(id: 145, name: "Antofagasta", country: "Chile", imageURL: "https://images.unsplash.com/photo-1502602898536-47ad22581b52?w=400&h=300&fit=crop&crop=center"),
    
    // China 🇨🇳
    City(id: 146, name: "Beijing", country: "China", imageURL: "https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=400&h=300&fit=crop&crop=center"),
    City(id: 147, name: "Shanghai", country: "China", imageURL: "https://images.unsplash.com/photo-1496442226666-8d4d0e62e6e9?w=400&h=300&fit=crop&crop=center"),
    City(id: 148, name: "Guangzhou", country: "China", imageURL: "https://images.unsplash.com/photo-1552832230-c0197dd311b5?w=400&h=300&fit=crop&crop=center"),
    City(id: 149, name: "Shenzhen", country: "China", imageURL: "https://images.unsplash.com/photo-1539037116277-4db20889f2d4?w=400&h=300&fit=crop&crop=center"),
    City(id: 150, name: "Chengdu", country: "China", imageURL: "https://images.unsplash.com/photo-1563492065-1a120d5d8b96?w=400&h=300&fit=crop&crop=center"),
    City(id: 151, name: "Xi'an", country: "China", imageURL: "https://images.unsplash.com/photo-1502602898536-47ad22581b52?w=400&h=300&fit=crop&crop=center"),
    City(id: 152, name: "Wuhan", country: "China", imageURL: "https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=400&h=300&fit=crop&crop=center"),
    City(id: 153, name: "Chongqing", country: "China", imageURL: "https://images.unsplash.com/photo-1496442226666-8d4d0e62e6e9?w=400&h=300&fit=crop&crop=center")
]

struct Country: Identifiable {
    let id: Int
    let name: String
    let flag: String
    let imageURL: String
    let cityCount: Int
}

struct City: Identifiable {
    let id: Int
    let name: String
    let country: String
    let imageURL: String
}

struct CountriesListView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.presentationMode) var presentationMode
    let filteredCountries: [Country]
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.white,
                        Color(red: 1.0, green: 0.95, blue: 0.9)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(filteredCountries) { country in
                            CountryListItem(country: country)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 100)
                }
            }
            .navigationTitle("Countries")
            .navigationBarTitleDisplayMode(.large)
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

struct CitiesListView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.presentationMode) var presentationMode
    let filteredCities: [City]
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.white,
                        Color(red: 1.0, green: 0.95, blue: 0.9)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(filteredCities) { city in
                            CityListItem(city: city)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 100)
                }
            }
            .navigationTitle("Cities")
            .navigationBarTitleDisplayMode(.large)
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

struct CountryListItem: View {
    @EnvironmentObject var themeManager: ThemeManager
    let country: Country
    
    var body: some View {
        HStack(spacing: 16) {
            AsyncImage(url: URL(string: country.imageURL)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                ZStack {
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 1.0, green: 0.4, blue: 0.2).opacity(0.1),
                            Color(red: 1.0, green: 0.4, blue: 0.2).opacity(0.3)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    
                    VStack(spacing: 4) {
                        Image(systemName: "photo")
                            .font(.system(size: 20))
                            .foregroundColor(Color(red: 1.0, green: 0.4, blue: 0.2).opacity(0.6))
                        
                        Text("Loading...")
                            .font(.custom("Inter", size: 10))
                            .foregroundColor(Color(red: 1.0, green: 0.4, blue: 0.2).opacity(0.6))
                    }
                }
            }
            .frame(width: 100, height: 100)
            .cornerRadius(12)
            .clipped()
            
            VStack(alignment: .leading, spacing: 8) {
                Text(country.name)
                    .font(.custom("Inter", size: 18))
                    .fontWeight(.semibold)
                    .foregroundColor(themeManager.textColor)
                
                Text("\(country.cityCount) Cities")
                    .font(.custom("Inter", size: 14))
                    .foregroundColor(themeManager.secondaryTextColor)
                
                Text("Explore beautiful destinations")
                    .font(.custom("Inter", size: 14))
                    .foregroundColor(themeManager.secondaryTextColor)
                    .lineLimit(2)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(themeManager.secondaryTextColor)
                .font(.system(size: 14))
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 3)
    }
}

struct CityListItem: View {
    @EnvironmentObject var themeManager: ThemeManager
    let city: City
    
    var body: some View {
        HStack(spacing: 16) {
            AsyncImage(url: URL(string: city.imageURL)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                ZStack {
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 1.0, green: 0.4, blue: 0.2).opacity(0.1),
                            Color(red: 1.0, green: 0.4, blue: 0.2).opacity(0.3)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    
                    VStack(spacing: 4) {
                        Image(systemName: "photo")
                            .font(.system(size: 20))
                            .foregroundColor(Color(red: 1.0, green: 0.4, blue: 0.2).opacity(0.6))
                        
                        Text("Loading...")
                            .font(.custom("Inter", size: 10))
                            .foregroundColor(Color(red: 1.0, green: 0.4, blue: 0.2).opacity(0.6))
                    }
                }
            }
            .frame(width: 100, height: 100)
            .cornerRadius(12)
            .clipped()
            
            VStack(alignment: .leading, spacing: 8) {
                Text(city.name)
                    .font(.custom("Inter", size: 18))
                    .fontWeight(.semibold)
                    .foregroundColor(themeManager.textColor)
                
                Text(city.country)
                    .font(.custom("Inter", size: 14))
                    .foregroundColor(themeManager.secondaryTextColor)
                
                Text("Discover amazing places")
                    .font(.custom("Inter", size: 14))
                    .foregroundColor(themeManager.secondaryTextColor)
                    .lineLimit(2)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(themeManager.secondaryTextColor)
                .font(.system(size: 14))
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 3)
    }
}

struct DestinationExtended: Identifiable {
    let id: Int
    let name: String
    let country: String
    let region: String
    let imageURL: String
    let startingPrice: Int
    let rating: Double
}

struct DestinationDetailViewExtended: View {
    let destination: DestinationExtended
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                AsyncImage(url: URL(string: destination.imageURL)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                }
                .frame(height: 250)
                .cornerRadius(20)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text(destination.name)
                        .font(.custom("Inter", size: 28))
                        .fontWeight(.bold)
                        .foregroundColor(Color(red: 0.11, green: 0.31, blue: 0.85))
                    
                    Text(destination.country)
                        .font(.custom("Inter", size: 18))
                        .foregroundColor(.gray)
                    
                    HStack {
                        Text("From $\(destination.startingPrice)")
                            .font(.custom("Inter", size: 20))
                            .fontWeight(.bold)
                            .foregroundColor(Color(red: 0.11, green: 0.31, blue: 0.85))
                        
                        Spacer()
                        
                        HStack(spacing: 2) {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                                .font(.system(size: 16))
                            
                            Text(String(format: "%.1f", destination.rating))
                                .font(.custom("Inter", size: 16))
                                .fontWeight(.semibold)
                                .foregroundColor(Color(red: 0.11, green: 0.31, blue: 0.85))
                        }
                    }
                    
                    Text("Discover the beauty and culture of \(destination.name). From historic landmarks to modern attractions, there's something for everyone.")
                        .font(.custom("Inter", size: 16))
                        .foregroundColor(.gray)
                        .lineLimit(nil)
                }
                .padding(.horizontal, 20)
                
                Button(action: {}) {
                    Text("Book Now")
                        .font(.custom("Inter", size: 18))
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color(red: 1.0, green: 0.4, blue: 0.2)) // Orange
                        .cornerRadius(15)
                }
                .padding(.horizontal, 20)
            }
        }
        .navigationTitle(destination.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}


#Preview {
    DestinationSelectionView()
        .environmentObject(ThemeManager())
}