import Foundation
import Supabase
import SwiftUI

// MARK: - Models
struct TravelRoute: Codable, Identifiable {
    var id: UUID?
    var title: String
    var region: String
    var startDate: Date
    var endDate: Date
    var durationDays: Int
    var plannedNights: Int
    var flightCost: Double
    var hotelCost: Double
    var totalCost: Double
}

struct TravelStop: Codable, Identifiable {
    var id: UUID?
    var routeId: UUID?
    var location: String
    var country: String
    var nights: Int
    var hotelCost: Double
    var notes: String?
}

// MARK: - Travel Routes Supabase Manager
class TravelRoutesSupabaseManager: ObservableObject {
    private let client: SupabaseClient
    
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var routes: [TravelRoute] = []
    
    init() {
        // Initialize Supabase client with your existing configuration
        let supabaseURL = URL(string: "https://mlnrhqbnphspbqcpzwez.supabase.co")!
        let supabaseKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1sbnJocWJucGhzcGJxY3B6d2V6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTg4MzIxMjcsImV4cCI6MjA3NDQwODEyN30.Kb3wbXqktjfwsAKD1jbUqWM-Jgmtnk_7W14sCwqZqyw"
        
        self.client = SupabaseClient(
            supabaseURL: supabaseURL,
            supabaseKey: supabaseKey
        )
    }
    
    // MARK: - 1. Create Route
    @MainActor
    func createRoute(route: TravelRoute, stops: [TravelStop]) async throws -> (route: TravelRoute, stops: [TravelStop]) {
        isLoading = true
        errorMessage = nil
        
        do {
            // Insert route
            let response = try await client.database
                .from("travel_routes")
                .insert(route)
                .select()
                .execute()
            
            guard let createdRoute = response.data?.first as? TravelRoute, let routeId = createdRoute.id else {
                throw NSError(domain: "SupabaseError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Route creation failed"])
            }
            
            // Insert stops
            var stopsToInsert = stops.map { stop -> TravelStop in
                var s = stop
                s.routeId = routeId
                return s
            }
            
            let stopsResponse = try await client.database
                .from("travel_stops")
                .insert(stopsToInsert)
                .select()
                .execute()
            
            guard let createdStops = stopsResponse.data as? [TravelStop] else {
                throw NSError(domain: "SupabaseError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Stops creation failed"])
            }
            
            // Update UI immediately
            routes.append(createdRoute)
            
            print("✅ Created route: \(createdRoute.title) with \(createdStops.count) stops")
            
            return (route: createdRoute, stops: createdStops)
            
        } catch {
            errorMessage = "Failed to create route: \(error.localizedDescription)"
            print("❌ Error creating route: \(error)")
            throw error
        }
        
        isLoading = false
    }
    
    // MARK: - 2. Edit Route
    @MainActor
    func editRoute(routeId: UUID, updatedRoute: TravelRoute, updatedStops: [TravelStop]) async throws -> (route: TravelRoute, stops: [TravelStop]) {
        isLoading = true
        errorMessage = nil
        
        do {
            // Update route
            let routeResponse = try await client.database
                .from("travel_routes")
                .update(updatedRoute)
                .eq("id", value: routeId)
                .select()
                .execute()
            
            guard let editedRoute = routeResponse.data?.first as? TravelRoute else {
                throw NSError(domain: "SupabaseError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Route update failed"])
            }
            
            // Delete existing stops and re-insert new ones
            try await client.database
                .from("travel_stops")
                .delete()
                .eq("route_id", value: routeId)
                .execute()
            
            let stopsToInsert = updatedStops.map { stop -> TravelStop in
                var s = stop
                s.routeId = routeId
                return s
            }
            
            let stopsResponse = try await client.database
                .from("travel_stops")
                .insert(stopsToInsert)
                .select()
                .execute()
            
            guard let editedStops = stopsResponse.data as? [TravelStop] else {
                throw NSError(domain: "SupabaseError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Stops update failed"])
            }
            
            // Update UI immediately
            if let index = routes.firstIndex(where: { $0.id == routeId }) {
                routes[index] = editedRoute
            }
            
            print("✅ Updated route: \(editedRoute.title) with \(editedStops.count) stops")
            
            return (route: editedRoute, stops: editedStops)
            
        } catch {
            errorMessage = "Failed to edit route: \(error.localizedDescription)"
            print("❌ Error editing route: \(error)")
            throw error
        }
        
        isLoading = false
    }
    
    // MARK: - 3. Delete Route
    @MainActor
    func deleteRoute(routeId: UUID) async throws {
        isLoading = true
        errorMessage = nil
        
        do {
            try await client.database
                .from("travel_routes")
                .delete()
                .eq("id", value: routeId)
                .execute()
            
            // Stops and bookings are removed automatically via ON DELETE CASCADE
            // Update UI immediately
            routes.removeAll { $0.id == routeId }
            
            print("✅ Deleted route with ID: \(routeId)")
            
        } catch {
            errorMessage = "Failed to delete route: \(error.localizedDescription)"
            print("❌ Error deleting route: \(error)")
            throw error
        }
        
        isLoading = false
    }
    
    // MARK: - Additional Helper Functions
    
    @MainActor
    func fetchAllRoutes() async throws {
        isLoading = true
        errorMessage = nil
        
        do {
            let response = try await client.database
                .from("travel_routes")
                .select()
                .execute()
            
            guard let fetchedRoutes = response.data as? [TravelRoute] else {
                throw NSError(domain: "SupabaseError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch routes"])
            }
            
            routes = fetchedRoutes
            
            print("✅ Fetched \(routes.count) routes from Supabase")
            
        } catch {
            errorMessage = "Failed to fetch routes: \(error.localizedDescription)"
            print("❌ Error fetching routes: \(error)")
            throw error
        }
        
        isLoading = false
    }
    
    @MainActor
    func fetchStopsForRoute(routeId: UUID) async throws -> [TravelStop] {
        do {
            let response = try await client.database
                .from("travel_stops")
                .select()
                .eq("route_id", value: routeId)
                .execute()
            
            guard let stops = response.data as? [TravelStop] else {
                throw NSError(domain: "SupabaseError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch stops"])
            }
            
            print("✅ Fetched \(stops.count) stops for route: \(routeId)")
            
            return stops
            
        } catch {
            errorMessage = "Failed to fetch stops: \(error.localizedDescription)"
            print("❌ Error fetching stops: \(error)")
            throw error
        }
    }
}

// MARK: - Example usage with SwiftUI
@MainActor
func addRouteExample() async {
    let route = TravelRoute(
        id: nil, // Will be set by Supabase
        title: "Asia Route 2026",
        region: "Asia",
        startDate: Date(),
        endDate: Calendar.current.date(byAdding: .day, value: 21, to: Date())!,
        durationDays: 21,
        plannedNights: 20,
        flightCost: 1200,
        hotelCost: 1800,
        totalCost: 3000
    )
    
    let stops = [
        TravelStop(
            id: nil,
            routeId: nil, // Will be set after route creation
            location: "Bangkok",
            country: "Thailand",
            nights: 3,
            hotelCost: 250,
            notes: "Arrival & temples"
        ),
        TravelStop(
            id: nil,
            routeId: nil,
            location: "Singapore",
            country: "Singapore",
            nights: 2,
            hotelCost: 300,
            notes: "City tour"
        ),
        TravelStop(
            id: nil,
            routeId: nil,
            location: "Bali",
            country: "Indonesia",
            nights: 7,
            hotelCost: 600,
            notes: "Beach & relax"
        )
    ]
    
    let routesManager = TravelRoutesSupabaseManager()
    
    do {
        let (createdRoute, createdStops) = try await routesManager.createRoute(route: route, stops: stops)
        print("Route created: \(createdRoute.title)")
        print("Stops created: \(createdStops.map { $0.location })")
        // Update your SwiftUI UI here
    } catch {
        print("Error: \(error.localizedDescription)")
    }
}

// MARK: - SwiftUI Integration Example
/*
struct TravelRoutesView: View {
    @StateObject private var routesManager = TravelRoutesSupabaseManager()
    @State private var showingCreateRoute = false
    
    var body: some View {
        NavigationView {
            List(routesManager.routes) { route in
                VStack(alignment: .leading) {
                    Text(route.title)
                        .font(.headline)
                    Text(route.region)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("€\(route.totalCost, specifier: "%.0f")")
                        .font(.caption)
                        .foregroundColor(.green)
                }
            }
            .navigationTitle("Travel Routes")
            .toolbar {
                Button("Add Route") {
                    showingCreateRoute = true
                }
            }
            .sheet(isPresented: $showingCreateRoute) {
                CreateRouteView(routesManager: routesManager)
            }
            .task {
                try? await routesManager.fetchAllRoutes()
            }
        }
    }
}
*/
