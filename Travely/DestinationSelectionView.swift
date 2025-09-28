import SwiftUI
import CoreLocation

// MARK: - Legacy Data Models (for compatibility)
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

// MARK: - Nominatim API Models
struct NominatimPlace: Codable, Identifiable {
    let id = UUID()
    let display_name: String
    let lat: String
    let lon: String
    let type: String?
    let importance: Double?
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: Double(lat) ?? 0.0,
            longitude: Double(lon) ?? 0.0
        )
    }
    
    var isCity: Bool {
        type?.contains("city") == true || type?.contains("town") == true || type?.contains("village") == true
    }
    
    var isCountry: Bool {
        type?.contains("country") == true
    }
}

// MARK: - Nominatim Manager
class NominatimManager: ObservableObject {
    @Published var searchResults: [NominatimPlace] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let baseURL = "https://nominatim.openstreetmap.org/search"
    
    func searchPlaces(query: String, completion: @escaping ([NominatimPlace]) -> Void) {
        guard !query.isEmpty else {
            DispatchQueue.main.async {
                self.searchResults = []
                completion([])
            }
            return
        }
        
        DispatchQueue.main.async {
            self.isLoading = true
            self.errorMessage = nil
        }
        
        let urlString = "\(baseURL)?format=json&q=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&limit=10&addressdetails=1"
        
        guard let url = URL(string: urlString) else {
            DispatchQueue.main.async {
                self.isLoading = false
                self.errorMessage = "Invalid URL"
                completion([])
            }
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    self?.errorMessage = "Network error: \(error.localizedDescription)"
                    completion([])
                    return
                }
                
                guard let data = data else {
                    self?.errorMessage = "No data received"
                    completion([])
                    return
                }
                
                do {
                    let results = try JSONDecoder().decode([NominatimPlace].self, from: data)
                    self?.searchResults = results
                    completion(results)
                } catch {
                    self?.errorMessage = "JSON parsing error: \(error.localizedDescription)"
                    completion([])
                }
            }
        }.resume()
    }
}

struct DestinationSelectionView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @StateObject private var nominatimManager = NominatimManager()
    @State private var searchText = ""
    @State private var useNominatimAPI = true
    
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
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
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
                            .foregroundColor(.primary)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                    .padding(.bottom, 16)
                    
                    // Search Bar
                    VStack(spacing: 16) {
                        // Search Bar
                        HStack(spacing: 8) {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(themeManager.secondaryTextColor)
                                .font(.system(size: 16))
                            
                            TextField("Search", text: $searchText)
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
                                        NominatimPlaceView(place: place)
                                    }
                                }
                            } else {
                                // No search active - show instructions
                                VStack(spacing: 20) {
                                    Image(systemName: "magnifyingglass")
                                        .font(.system(size: 64))
                                        .foregroundColor(themeManager.secondaryTextColor)
                                    
                                    Text("Search")
                                        .font(.custom("Inter", size: 24))
                                        .foregroundColor(themeManager.textColor)
                                    
                                    Text("Enter a place to search")
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
        }
    }
}

// MARK: - Nominatim Place View
struct NominatimPlaceView: View {
    let place: NominatimPlace
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        Button(action: {
            print("Selected place: \(place.display_name) at \(place.lat), \(place.lon)")
        }) {
            HStack(spacing: 16) {
                // Place Icon based on type
                ZStack {
                    Circle()
                        .fill(Color(red: 1.0, green: 0.4, blue: 0.2).opacity(0.1))
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: place.isCountry ? "flag.fill" : (place.isCity ? "building.2.fill" : "location.fill"))
                        .font(.system(size: 24))
                        .foregroundColor(Color(red: 1.0, green: 0.4, blue: 0.2))
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(place.display_name)
                        .font(.custom("Inter", size: 16))
                        .foregroundColor(themeManager.textColor)
                        .lineLimit(2)
                    
                    Text(place.isCountry ? "Land" : (place.isCity ? "Stadt" : "Ort"))
                        .font(.custom("Inter", size: 14))
                        .foregroundColor(themeManager.secondaryTextColor)
                        .lineLimit(1)
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
}

#Preview {
    DestinationSelectionView()
        .environmentObject(ThemeManager())
}