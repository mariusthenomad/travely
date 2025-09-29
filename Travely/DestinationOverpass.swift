import SwiftUI
import CoreLocation

// MARK: - Overpass API Models
struct OverpassResponse: Codable {
    let elements: [OverpassElement]
}

struct OverpassElement: Codable {
    let type: String
    let id: Int
    let lat: Double?
    let lon: Double?
    let tags: [String: String]?
    
    var name: String {
        return tags?["name"] ?? "Unnamed"
    }
    
    var amenity: String {
        return tags?["amenity"] ?? ""
    }
    
    var address: String {
        let street = tags?["addr:street"] ?? ""
        let city = tags?["addr:city"] ?? ""
        let country = tags?["addr:country"] ?? ""
        
        var components: [String] = []
        if !street.isEmpty { components.append(street) }
        if !city.isEmpty { components.append(city) }
        if !country.isEmpty { components.append(country) }
        
        return components.joined(separator: ", ")
    }
}

// MARK: - Overpass POI Model
struct OverpassPOI: Identifiable, Hashable {
    let id: String
    let name: String
    let amenity: String
    let address: String
    let coordinate: CLLocationCoordinate2D
    let tags: [String: String]
    
    init(from element: OverpassElement) {
        self.id = "\(element.type)_\(element.id)"
        self.name = element.name
        self.amenity = element.amenity
        self.address = element.address
        self.coordinate = CLLocationCoordinate2D(
            latitude: element.lat ?? 0,
            longitude: element.lon ?? 0
        )
        self.tags = element.tags ?? [:]
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: OverpassPOI, rhs: OverpassPOI) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Overpass API Manager
class OverpassManager: ObservableObject {
    @Published var searchResults: [OverpassPOI] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let baseURL = "https://overpass-api.de/api/interpreter"
    
    // MARK: - Search Methods
    func searchPOIs(query: String, amenity: String = "", center: CLLocationCoordinate2D? = nil, radius: Double = 1000) {
        guard !query.isEmpty else {
            searchResults = []
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        let overpassQuery = buildOverpassQuery(query: query, amenity: amenity, center: center, radius: radius)
        performOverpassRequest(query: overpassQuery)
    }
    
    func searchCafes(center: CLLocationCoordinate2D, radius: Double = 1000) {
        searchPOIs(query: "", amenity: "cafe", center: center, radius: radius)
    }
    
    func searchRestaurants(center: CLLocationCoordinate2D, radius: Double = 1000) {
        searchPOIs(query: "", amenity: "restaurant", center: center, radius: radius)
    }
    
    func searchHotels(center: CLLocationCoordinate2D, radius: Double = 1000) {
        searchPOIs(query: "", amenity: "hotel", center: center, radius: radius)
    }
    
    func searchAttractions(center: CLLocationCoordinate2D, radius: Double = 1000) {
        searchPOIs(query: "", amenity: "tourist", center: center, radius: radius)
    }
    
    // MARK: - Private Methods
    private func buildOverpassQuery(query: String, amenity: String, center: CLLocationCoordinate2D?, radius: Double) -> String {
        var overpassQuery = "[out:json];\n"
        
        if let center = center {
            // Search within bounding box
            let lat = center.latitude
            let lon = center.longitude
            let offset = radius / 111000 // Rough conversion from meters to degrees
            
            let south = lat - offset
            let north = lat + offset
            let west = lon - offset
            let east = lon + offset
            
            if !amenity.isEmpty {
                overpassQuery += "node[\"amenity\"=\"\(amenity)\"](\(south),\(west),\(north),\(east));\n"
            } else if !query.isEmpty {
                overpassQuery += "node[\"name\"~\"\(query)\",i](\(south),\(west),\(north),\(east));\n"
            } else {
                overpassQuery += "node(\(south),\(west),\(north),\(east));\n"
            }
        } else {
            // Global search
            if !amenity.isEmpty {
                overpassQuery += "node[\"amenity\"=\"\(amenity)\"];\n"
            } else if !query.isEmpty {
                overpassQuery += "node[\"name\"~\"\(query)\",i];\n"
            } else {
                overpassQuery += "node;\n"
            }
        }
        
        overpassQuery += "out;"
        return overpassQuery
    }
    
    private func performOverpassRequest(query: String) {
        guard let url = URL(string: baseURL) else {
            DispatchQueue.main.async {
                self.isLoading = false
                self.errorMessage = "Invalid URL"
            }
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let body = "data=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
        request.httpBody = body.data(using: .utf8)
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    self?.errorMessage = "Network error: \(error.localizedDescription)"
                    return
                }
                
                guard let data = data else {
                    self?.errorMessage = "No data received"
                    return
                }
                
                do {
                    let overpassResponse = try JSONDecoder().decode(OverpassResponse.self, from: data)
                    self?.searchResults = overpassResponse.elements.compactMap { element in
                        // Only include elements with coordinates and names
                        guard element.lat != nil, element.lon != nil, !element.name.isEmpty else {
                            return nil
                        }
                        return OverpassPOI(from: element)
                    }
                } catch {
                    self?.errorMessage = "JSON parsing error: \(error.localizedDescription)"
                }
            }
        }.resume()
    }
}

// MARK: - Overpass POI View
struct OverpassPOIView: View {
    let poi: OverpassPOI
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        Button(action: {
            // TODO: Handle POI selection
            print("Selected POI: \(poi.name)")
        }) {
            HStack(spacing: 16) {
                // POI Icon based on amenity
                ZStack {
                    Circle()
                        .fill(iconColor.opacity(0.1))
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: iconName)
                        .font(.system(size: 24))
                        .foregroundColor(iconColor)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(poi.name)
                        .font(.custom("Inter", size: 16))
                        .foregroundColor(themeManager.textColor)
                        .lineLimit(1)
                    
                    if !poi.amenity.isEmpty {
                        Text(amenityDisplayName)
                            .font(.custom("Inter", size: 14))
                            .foregroundColor(iconColor)
                            .lineLimit(1)
                    }
                    
                    if !poi.address.isEmpty {
                        Text(poi.address)
                            .font(.custom("Inter", size: 12))
                            .foregroundColor(themeManager.secondaryTextColor)
                            .lineLimit(2)
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(themeManager.secondaryTextColor)
                    .font(.system(size: 12))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var iconName: String {
        switch poi.amenity {
        case "cafe": return "cup.and.saucer.fill"
        case "restaurant": return "fork.knife"
        case "hotel": return "bed.double.fill"
        case "tourist": return "camera.fill"
        case "hospital": return "cross.fill"
        case "school": return "graduationcap.fill"
        case "bank": return "building.columns.fill"
        case "pharmacy": return "pills.fill"
        case "fuel": return "fuelpump.fill"
        case "parking": return "car.fill"
        default: return "mappin.circle.fill"
        }
    }
    
    private var iconColor: Color {
        switch poi.amenity {
        case "cafe": return Color.brown
        case "restaurant": return Color.red
        case "hotel": return Color.blue
        case "tourist": return Color.purple
        case "hospital": return Color.red
        case "school": return Color.green
        case "bank": return Color.gray
        case "pharmacy": return Color.green
        case "fuel": return Color.orange
        case "parking": return Color.gray
        default: return Color(red: 1.0, green: 0.4, blue: 0.2)
        }
    }
    
    private var amenityDisplayName: String {
        switch poi.amenity {
        case "cafe": return "Café"
        case "restaurant": return "Restaurant"
        case "hotel": return "Hotel"
        case "tourist": return "Sehenswürdigkeit"
        case "hospital": return "Krankenhaus"
        case "school": return "Schule"
        case "bank": return "Bank"
        case "pharmacy": return "Apotheke"
        case "fuel": return "Tankstelle"
        case "parking": return "Parkplatz"
        default: return poi.amenity.capitalized
        }
    }
}

// MARK: - Overpass Search View
struct OverpassSearchView: View {
    @StateObject private var overpassManager = OverpassManager()
    @EnvironmentObject var themeManager: ThemeManager
    @State private var searchText = ""
    @State private var selectedAmenity = "all"
    @State private var userLocation: CLLocationCoordinate2D?
    
    let amenities = [
        ("all", "Alle"),
        ("cafe", "Cafés"),
        ("restaurant", "Restaurants"),
        ("hotel", "Hotels"),
        ("tourist", "Sehenswürdigkeiten"),
        ("hospital", "Krankenhäuser"),
        ("school", "Schulen"),
        ("bank", "Banken"),
        ("pharmacy", "Apotheken"),
        ("fuel", "Tankstellen"),
        ("parking", "Parkplätze")
    ]
    
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
                        Text("POI Suche")
                            .font(.largeTitle)
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
                                
                                TextField("Suche nach Orten...", text: $searchText)
                                    .font(.custom("Inter", size: 16))
                                    .foregroundColor(themeManager.textColor)
                                    .onChange(of: searchText) { _ in
                                        performSearch()
                                    }
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(15)
                            
                            Button(action: { 
                                // TODO: Get user location
                                userLocation = CLLocationCoordinate2D(latitude: 48.1351, longitude: 11.5820) // Munich
                                performSearch()
                            }) {
                                Image(systemName: "location.fill")
                                    .foregroundColor(Color(red: 1.0, green: 0.4, blue: 0.2))
                                    .font(.system(size: 18))
                            }
                            .frame(width: 44, height: 44)
                            .background(Color(red: 1.0, green: 0.4, blue: 0.2).opacity(0.1))
                            .cornerRadius(22)
                        }
                        .padding(.horizontal, 20)
                        
                        // Amenity Filter
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(amenities, id: \.0) { amenity in
                                    Button(action: { 
                                        selectedAmenity = amenity.0
                                        performSearch()
                                    }) {
                                        Text(amenity.1)
                                            .font(.custom("Inter", size: 14))
                                            .foregroundColor(selectedAmenity == amenity.0 ? .white : Color(red: 1.0, green: 0.4, blue: 0.2))
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 10)
                                            .background(selectedAmenity == amenity.0 ? Color(red: 1.0, green: 0.4, blue: 0.2) : Color.clear)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 15)
                                                    .stroke(Color(red: 1.0, green: 0.4, blue: 0.2), lineWidth: 1)
                                            )
                                            .cornerRadius(15)
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                    .padding(.bottom, 20)
                    .background(themeManager.oledBackgroundColor)
                    
                    // Results
                    if overpassManager.isLoading {
                        VStack {
                            Spacer()
                            ProgressView()
                                .scaleEffect(1.2)
                            Text("Suche läuft...")
                                .font(.custom("Inter", size: 16))
                                .foregroundColor(themeManager.secondaryTextColor)
                                .padding(.top, 8)
                            Spacer()
                        }
                    } else if overpassManager.searchResults.isEmpty && !searchText.isEmpty {
                        VStack(spacing: 16) {
                            Spacer()
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 48))
                                .foregroundColor(themeManager.secondaryTextColor)
                            
                            Text("Keine Ergebnisse gefunden")
                                .font(.custom("Inter", size: 18))
                                .foregroundColor(themeManager.textColor)
                            
                            Text("Versuche einen anderen Suchbegriff")
                                .font(.custom("Inter", size: 14))
                                .foregroundColor(themeManager.secondaryTextColor)
                            Spacer()
                        }
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(overpassManager.searchResults) { poi in
                                    OverpassPOIView(poi: poi)
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 8)
                            .padding(.bottom, 100)
                        }
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    private func performSearch() {
        let amenity = selectedAmenity == "all" ? "" : selectedAmenity
        overpassManager.searchPOIs(
            query: searchText,
            amenity: amenity,
            center: userLocation,
            radius: 1000
        )
    }
}

#Preview {
    OverpassSearchView()
        .environmentObject(ThemeManager())
}





