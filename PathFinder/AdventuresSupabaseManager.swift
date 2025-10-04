import Foundation
import Supabase

// MARK: - Adventures Supabase Manager
class AdventuresSupabaseManager: ObservableObject {
    private let supabase: SupabaseClient
    
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var adventures: [Adventure] = []
    
    init() {
        // Initialize Supabase client with your existing configuration
        let supabaseURL = URL(string: "https://mlnrhqbnphspbqcpzwez.supabase.co")!
        let supabaseKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1sbnJocWJucGhzcGJxY3B6d2V6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTg4MzIxMjcsImV4cCI6MjA3NDQwODEyN30.Kb3wbXqktjfwsAKD1jbUqWM-Jgmtnk_7W14sCwqZqyw"
        
        self.supabase = SupabaseClient(
            supabaseURL: supabaseURL,
            supabaseKey: supabaseKey
        )
    }
    
    // MARK: - Fetch Adventures from Supabase
    @MainActor
    func fetchAdventures() async {
        isLoading = true
        errorMessage = nil
        
        do {
            // Fetch adventures
            let adventuresResponse: [SupabaseAdventure] = try await supabase.database
                .from("adventures")
                .select()
                .execute()
                .value
            
            // Convert to local Adventure objects
            var localAdventures: [Adventure] = []
            
            for supabaseAdventure in adventuresResponse {
                let adventure = try await convertToLocalAdventure(supabaseAdventure)
                localAdventures.append(adventure)
            }
            
            self.adventures = localAdventures
            print("✅ Fetched \(localAdventures.count) adventures from Supabase")
            
        } catch {
            errorMessage = "Failed to fetch adventures: \(error.localizedDescription)"
            print("❌ Error fetching adventures: \(error)")
        }
        
        isLoading = false
    }
    
    // MARK: - Save Adventure to Supabase
    @MainActor
    func saveAdventure(_ adventure: Adventure) async throws {
        isLoading = true
        errorMessage = nil
        
        do {
            // Convert to Supabase format
            let supabaseAdventure = SupabaseAdventure(
                id: adventure.id,
                name: adventure.name,
                description: adventure.description,
                duration: adventure.duration,
                difficulty: adventure.difficulty,
                budget: adventure.budget,
                image: adventure.image,
                color_hex: adventure.color.toHex(),
                destinations: adventure.destinations,
                highlights: adventure.highlights,
                total_cost: adventure.routeData.totalCost,
                total_nights: adventure.routeData.totalNights
            )
            
            // Insert or update adventure
            try await supabase.database
                .from("adventures")
                .upsert(supabaseAdventure)
                .execute()
            
            // Save flights
            try await saveAdventureFlights(adventure.id, flights: adventure.routeData.flights)
            
            // Save places
            try await saveAdventurePlaces(adventure.id, places: adventure.routeData.places)
            
            // Save badges
            try await saveAdventureBadges(adventure.id, badges: adventure.routeData.badges)
            
            print("✅ Saved adventure: \(adventure.name)")
            
        } catch {
            errorMessage = "Failed to save adventure: \(error.localizedDescription)"
            throw error
        }
        
        isLoading = false
    }
    
    // MARK: - Delete Adventure from Supabase
    @MainActor
    func deleteAdventure(_ adventureId: String) async throws {
        isLoading = true
        errorMessage = nil
        
        do {
            // Delete adventure (cascade will handle related records)
            try await supabase.database
                .from("adventures")
                .delete()
                .eq("id", value: adventureId)
                .execute()
            
            print("✅ Deleted adventure: \(adventureId)")
            
        } catch {
            errorMessage = "Failed to delete adventure: \(error.localizedDescription)"
            throw error
        }
        
        isLoading = false
    }
    
    // MARK: - Helper Functions
    private func convertToLocalAdventure(_ supabaseAdventure: SupabaseAdventure) async throws -> Adventure {
        // Fetch related data
        let flights = try await fetchAdventureFlights(adventureId: supabaseAdventure.id)
        let places = try await fetchAdventurePlaces(adventureId: supabaseAdventure.id)
        let badges = try await fetchAdventureBadges(adventureId: supabaseAdventure.id)
        
        // Convert flights
        let flightInfos = flights.map { flight in
            FlightInfo(
                route: flight.route,
                date: flight.date,
                duration: flight.duration,
                price: flight.price
            )
        }
        
        // Convert places
        let editablePlaces = places.map { place in
            EditablePlace(
                name: place.name,
                coordinate: CLLocationCoordinate2D(
                    latitude: place.latitude ?? 0,
                    longitude: place.longitude ?? 0
                ),
                nights: place.nights ?? 0,
                isStartPoint: place.is_start_point ?? false,
                hotelName: place.hotel_name ?? "",
                pricePerNight: place.price_per_night ?? 0
            )
        }
        
        // Create route data
        let routeData = AdventureRouteData(
            flights: flightInfos,
            places: editablePlaces,
            badges: badges.map { $0.badge_emoji },
            totalCost: supabaseAdventure.total_cost ?? 0,
            totalNights: supabaseAdventure.total_nights ?? 0
        )
        
        // Create adventure
        return Adventure(
            id: supabaseAdventure.id,
            name: supabaseAdventure.name,
            description: supabaseAdventure.description ?? "",
            duration: supabaseAdventure.duration ?? "",
            difficulty: supabaseAdventure.difficulty ?? "Easy",
            budget: supabaseAdventure.budget ?? "€€",
            image: supabaseAdventure.image ?? "airplane.departure",
            color: Color(hex: supabaseAdventure.color_hex ?? "#FF6B35"),
            destinations: supabaseAdventure.destinations ?? [],
            highlights: supabaseAdventure.highlights ?? [],
            routeData: routeData
        )
    }
    
    private func saveAdventureFlights(_ adventureId: String, flights: [FlightInfo]) async throws {
        // Delete existing flights
        try await supabase.database
            .from("adventure_flights")
            .delete()
            .eq("adventure_id", value: adventureId)
            .execute()
        
        // Insert new flights
        let supabaseFlights = flights.map { flight in
            SupabaseFlight(
                adventure_id: adventureId,
                route: flight.route,
                date: flight.date,
                duration: flight.duration,
                price: flight.price
            )
        }
        
        try await supabase.database
            .from("adventure_flights")
            .insert(supabaseFlights)
            .execute()
    }
    
    private func saveAdventurePlaces(_ adventureId: String, places: [EditablePlace]) async throws {
        // Delete existing places
        try await supabase.database
            .from("adventure_places")
            .delete()
            .eq("adventure_id", value: adventureId)
            .execute()
        
        // Insert new places
        let supabasePlaces = places.map { place in
            SupabasePlace(
                adventure_id: adventureId,
                name: place.name,
                latitude: place.coordinate.latitude,
                longitude: place.coordinate.longitude,
                nights: place.nights,
                is_start_point: place.isStartPoint,
                hotel_name: place.hotelName,
                price_per_night: place.pricePerNight
            )
        }
        
        try await supabase.database
            .from("adventure_places")
            .insert(supabasePlaces)
            .execute()
    }
    
    private func saveAdventureBadges(_ adventureId: String, badges: [String]) async throws {
        // Delete existing badges
        try await supabase.database
            .from("adventure_badges")
            .delete()
            .eq("adventure_id", value: adventureId)
            .execute()
        
        // Insert new badges
        let supabaseBadges = badges.map { badge in
            SupabaseBadge(adventure_id: adventureId, badge_emoji: badge)
        }
        
        try await supabase.database
            .from("adventure_badges")
            .insert(supabaseBadges)
            .execute()
    }
    
    private func fetchAdventureFlights(adventureId: String) async throws -> [SupabaseFlight] {
        return try await supabase.database
            .from("adventure_flights")
            .select()
            .eq("adventure_id", value: adventureId)
            .execute()
            .value
    }
    
    private func fetchAdventurePlaces(adventureId: String) async throws -> [SupabasePlace] {
        return try await supabase.database
            .from("adventure_places")
            .select()
            .eq("adventure_id", value: adventureId)
            .execute()
            .value
    }
    
    private func fetchAdventureBadges(adventureId: String) async throws -> [SupabaseBadge] {
        return try await supabase.database
            .from("adventure_badges")
            .select()
            .eq("adventure_id", value: adventureId)
            .execute()
            .value
    }
}

// MARK: - Supabase Data Models
struct SupabaseAdventure: Codable {
    let id: String
    let name: String
    let description: String?
    let duration: String?
    let difficulty: String?
    let budget: String?
    let image: String?
    let color_hex: String?
    let destinations: [String]?
    let highlights: [String]?
    let total_cost: Int?
    let total_nights: Int?
    let created_at: String?
    let updated_at: String?
}

struct SupabaseFlight: Codable {
    let id: String?
    let adventure_id: String
    let route: String
    let date: String
    let duration: String
    let price: String
    let created_at: String?
}

struct SupabasePlace: Codable {
    let id: String?
    let adventure_id: String
    let name: String
    let latitude: Double?
    let longitude: Double?
    let nights: Int?
    let is_start_point: Bool?
    let hotel_name: String?
    let price_per_night: Int?
    let created_at: String?
}

struct SupabaseBadge: Codable {
    let id: String?
    let adventure_id: String
    let badge_emoji: String
    let created_at: String?
}

// MARK: - Color Extension for Hex Conversion
extension Color {
    func toHex() -> String {
        // Simple conversion - you might want to implement a more robust version
        return "#FF6B35" // Default orange color
    }
    
    init(hex: String) {
        // Simple hex to Color conversion
        self = Color.orange // Default to orange for now
    }
}

// MARK: - Usage Example
/*
// In your ContentView or Adventure management view:

struct AdventuresSyncView: View {
    @StateObject private var supabaseManager = AdventuresSupabaseManager()
    @State private var showingSync = false
    
    var body: some View {
        Button("Sync with Supabase") {
            showingSync = true
        }
        .sheet(isPresented: $showingSync) {
            VStack {
                if supabaseManager.isLoading {
                    ProgressView("Syncing...")
                } else {
                    Text("Adventures synced: \(supabaseManager.adventures.count)")
                }
                
                Button("Fetch from Supabase") {
                    Task {
                        await supabaseManager.fetchAdventures()
                    }
                }
                
                Button("Save Current Adventures") {
                    Task {
                        for adventure in adventures {
                            try await supabaseManager.saveAdventure(adventure)
                        }
                    }
                }
            }
        }
    }
}
*/
