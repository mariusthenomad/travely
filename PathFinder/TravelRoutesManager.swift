import Foundation
import Supabase
import SwiftUI

// MARK: - Data Models
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

// MARK: - Travel Routes Manager
@MainActor
class TravelRoutesManager: ObservableObject {
    private let client: SupabaseClient
    
    @Published var routes: [TravelRoute] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isConnected = false
    
    init() {
        // Initialize Supabase client with your existing configuration
        let supabaseURL = URL(string: "https://mlnrhqbnphspbqcpzwez.supabase.co")!
        let supabaseKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1sbnJocWJucGhzcGJxY3B6d2V6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTg4MzIxMjcsImV4cCI6MjA3NDQwODEyN30.Kb3wbXqktjfwsAKD1jbUqWM-Jgmtnk_7W14sCwqZqyw"
        
        self.client = SupabaseClient(
            supabaseURL: supabaseURL,
            supabaseKey: supabaseKey
        )
        
        // Test connection on initialization
        Task {
            await testConnection()
        }
    }
    
    // MARK: - Connection Test
    private func testConnection() async {
        do {
            // Simple query to test connection
            let _ = try await client.database
                .from("travel_routes")
                .select("id")
                .limit(1)
                .execute()
            
            isConnected = true
            print("✅ Supabase connection established")
        } catch {
            isConnected = false
            errorMessage = "Connection failed: \(error.localizedDescription)"
            print("❌ Supabase connection failed: \(error)")
        }
    }
    
    // MARK: - 1. Create Route
    func createRoute(route: TravelRoute, stops: [TravelStop]) async throws -> (route: TravelRoute, stops: [TravelStop]) {
        guard isConnected else {
            throw SupabaseError.connectionFailed
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            print("🚀 Creating route: \(route.title)")
            
            // Insert route into travel_routes
            let routeResponse = try await client.database
                .from("travel_routes")
                .insert(route)
                .select()
                .execute()
            
            guard let createdRoute = routeResponse.data?.first as? TravelRoute,
                  let routeId = createdRoute.id else {
                throw SupabaseError.routeCreationFailed
            }
            
            print("✅ Route created with ID: \(routeId)")
            
            // Insert stops with the returned route_id
            var stopsToInsert = stops.map { stop -> TravelStop in
                var updatedStop = stop
                updatedStop.routeId = routeId
                return updatedStop
            }
            
            let stopsResponse = try await client.database
                .from("travel_stops")
                .insert(stopsToInsert)
                .select()
                .execute()
            
            guard let createdStops = stopsResponse.data as? [TravelStop] else {
                throw SupabaseError.stopsCreationFailed
            }
            
            print("✅ Created \(createdStops.count) stops for route")
            
            // Update UI automatically
            routes.append(createdRoute)
            
            print("🎉 Route '\(createdRoute.title)' successfully created and added to UI")
            
            return (route: createdRoute, stops: createdStops)
            
        } catch {
            errorMessage = "Failed to create route: \(error.localizedDescription)"
            print("❌ Error creating route: \(error)")
            throw error
        }
        
        isLoading = false
    }
    
    // MARK: - 2. Edit Route
    func editRoute(routeId: UUID, updatedRoute: TravelRoute, updatedStops: [TravelStop]) async throws -> (route: TravelRoute, stops: [TravelStop]) {
        guard isConnected else {
            throw SupabaseError.connectionFailed
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            print("🔄 Editing route: \(updatedRoute.title)")
            
            // Update route in travel_routes
            let routeResponse = try await client.database
                .from("travel_routes")
                .update(updatedRoute)
                .eq("id", value: routeId)
                .select()
                .execute()
            
            guard let editedRoute = routeResponse.data?.first as? TravelRoute else {
                throw SupabaseError.routeUpdateFailed
            }
            
            print("✅ Route updated successfully")
            
            // Delete existing stops for this route
            try await client.database
                .from("travel_stops")
                .delete()
                .eq("route_id", value: routeId)
                .execute()
            
            print("🗑️ Deleted existing stops")
            
            // Insert updated stops
            let stopsToInsert = updatedStops.map { stop -> TravelStop in
                var updatedStop = stop
                updatedStop.routeId = routeId
                return updatedStop
            }
            
            let stopsResponse = try await client.database
                .from("travel_stops")
                .insert(stopsToInsert)
                .select()
                .execute()
            
            guard let editedStops = stopsResponse.data as? [TravelStop] else {
                throw SupabaseError.stopsUpdateFailed
            }
            
            print("✅ Updated \(editedStops.count) stops")
            
            // Refresh UI automatically
            if let index = routes.firstIndex(where: { $0.id == routeId }) {
                routes[index] = editedRoute
                print("🔄 UI refreshed - route updated in list")
            }
            
            print("🎉 Route '\(editedRoute.title)' successfully updated and UI refreshed")
            
            return (route: editedRoute, stops: editedStops)
            
        } catch {
            errorMessage = "Failed to edit route: \(error.localizedDescription)"
            print("❌ Error editing route: \(error)")
            throw error
        }
        
        isLoading = false
    }
    
    // MARK: - 3. Delete Route
    func deleteRoute(routeId: UUID) async throws {
        guard isConnected else {
            throw SupabaseError.connectionFailed
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            print("🗑️ Deleting route with ID: \(routeId)")
            
            // Delete route (cascade will handle related stops and bookings)
            try await client.database
                .from("travel_routes")
                .delete()
                .eq("id", value: routeId)
                .execute()
            
            print("✅ Route deleted from database")
            
            // Update UI automatically
            let initialCount = routes.count
            routes.removeAll { $0.id == routeId }
            let finalCount = routes.count
            
            if initialCount > finalCount {
                print("🔄 UI updated - route removed from list")
            }
            
            print("🎉 Route successfully deleted and removed from UI")
            
        } catch {
            errorMessage = "Failed to delete route: \(error.localizedDescription)"
            print("❌ Error deleting route: \(error)")
            throw error
        }
        
        isLoading = false
    }
    
    // MARK: - Helper Functions
    
    func fetchAllRoutes() async throws {
        guard isConnected else {
            throw SupabaseError.connectionFailed
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let response = try await client.database
                .from("travel_routes")
                .select()
                .order("start_date", ascending: false)
                .execute()
            
            guard let fetchedRoutes = response.data as? [TravelRoute] else {
                throw SupabaseError.fetchFailed
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
    
    func fetchStopsForRoute(routeId: UUID) async throws -> [TravelStop] {
        guard isConnected else {
            throw SupabaseError.connectionFailed
        }
        
        do {
            let response = try await client.database
                .from("travel_stops")
                .select()
                .eq("route_id", value: routeId)
                .order("location", ascending: true)
                .execute()
            
            guard let stops = response.data as? [TravelStop] else {
                throw SupabaseError.fetchFailed
            }
            
            print("✅ Fetched \(stops.count) stops for route: \(routeId)")
            return stops
            
        } catch {
            errorMessage = "Failed to fetch stops: \(error.localizedDescription)"
            print("❌ Error fetching stops: \(error)")
            throw error
        }
    }
    
    func clearError() {
        errorMessage = nil
    }
}

// MARK: - Custom Errors
enum SupabaseError: LocalizedError {
    case connectionFailed
    case routeCreationFailed
    case routeUpdateFailed
    case routeDeletionFailed
    case stopsCreationFailed
    case stopsUpdateFailed
    case fetchFailed
    
    var errorDescription: String? {
        switch self {
        case .connectionFailed:
            return "Unable to connect to Supabase. Please check your internet connection."
        case .routeCreationFailed:
            return "Failed to create route. Please try again."
        case .routeUpdateFailed:
            return "Failed to update route. Please try again."
        case .routeDeletionFailed:
            return "Failed to delete route. Please try again."
        case .stopsCreationFailed:
            return "Failed to create stops. Please try again."
        case .stopsUpdateFailed:
            return "Failed to update stops. Please try again."
        case .fetchFailed:
            return "Failed to fetch data. Please try again."
        }
    }
}

// MARK: - SwiftUI Integration Examples

// Example 1: Create Route Button
struct CreateRouteButton: View {
    @ObservedObject var routesManager: TravelRoutesManager
    @State private var showingCreateSheet = false
    
    var body: some View {
        Button(action: {
            showingCreateSheet = true
        }) {
            HStack {
                Image(systemName: "plus.circle.fill")
                Text("Create Route")
            }
            .foregroundColor(.white)
            .padding()
            .background(Color.blue)
            .cornerRadius(10)
        }
        .sheet(isPresented: $showingCreateSheet) {
            CreateRouteView(routesManager: routesManager)
        }
    }
}

// Example 2: Edit Route Button
struct EditRouteButton: View {
    @ObservedObject var routesManager: TravelRoutesManager
    let route: TravelRoute
    @State private var showingEditSheet = false
    
    var body: some View {
        Button(action: {
            showingEditSheet = true
        }) {
            Image(systemName: "pencil.circle")
                .foregroundColor(.blue)
        }
        .sheet(isPresented: $showingEditSheet) {
            EditRouteView(routesManager: routesManager, route: route)
        }
    }
}

// Example 3: Delete Route Button
struct DeleteRouteButton: View {
    @ObservedObject var routesManager: TravelRoutesManager
    let route: TravelRoute
    @State private var showingDeleteAlert = false
    
    var body: some View {
        Button(action: {
            showingDeleteAlert = true
        }) {
            Image(systemName: "trash.circle")
                .foregroundColor(.red)
        }
        .alert("Delete Route", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                Task {
                    do {
                        try await routesManager.deleteRoute(routeId: route.id!)
                        print("✅ Route deleted successfully")
                    } catch {
                        print("❌ Failed to delete route: \(error)")
                    }
                }
            }
        } message: {
            Text("Are you sure you want to delete '\(route.title)'? This action cannot be undone.")
        }
    }
}

// Example 4: Main Routes View
struct TravelRoutesView: View {
    @StateObject private var routesManager = TravelRoutesManager()
    @State private var showingCreateSheet = false
    
    var body: some View {
        NavigationView {
            VStack {
                // Connection Status
                HStack {
                    Circle()
                        .fill(routesManager.isConnected ? Color.green : Color.red)
                        .frame(width: 8, height: 8)
                    Text(routesManager.isConnected ? "Connected" : "Disconnected")
                        .font(.caption)
                        .foregroundColor(routesManager.isConnected ? .green : .red)
                    Spacer()
                }
                .padding(.horizontal)
                
                // Routes List
                if routesManager.isLoading {
                    ProgressView("Loading routes...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if routesManager.routes.isEmpty {
                    VStack {
                        Image(systemName: "airplane")
                            .font(.system(size: 50))
                            .foregroundColor(.gray)
                        Text("No routes yet")
                            .font(.title2)
                            .foregroundColor(.gray)
                        Text("Create your first travel route")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List(routesManager.routes) { route in
                        RouteRowView(
                            route: route,
                            routesManager: routesManager
                        )
                    }
                }
            }
            .navigationTitle("Travel Routes")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    CreateRouteButton(routesManager: routesManager)
                }
            }
            .task {
                do {
                    try await routesManager.fetchAllRoutes()
                } catch {
                    print("Failed to load routes: \(error)")
                }
            }
            .alert("Error", isPresented: .constant(routesManager.errorMessage != nil)) {
                Button("OK") {
                    routesManager.clearError()
                }
            } message: {
                Text(routesManager.errorMessage ?? "")
            }
        }
    }
}

// Example 5: Route Row View
struct RouteRowView: View {
    let route: TravelRoute
    @ObservedObject var routesManager: TravelRoutesManager
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(route.title)
                    .font(.headline)
                Text(route.region)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text("€\(route.totalCost, specifier: "%.0f")")
                    .font(.caption)
                    .foregroundColor(.green)
            }
            
            Spacer()
            
            HStack {
                EditRouteButton(routesManager: routesManager, route: route)
                DeleteRouteButton(routesManager: routesManager, route: route)
            }
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Usage Examples in Your App

/*
// Example 1: Create Route from Button Action
func createNewRoute() {
    let newRoute = TravelRoute(
        id: nil,
        title: "European Adventure",
        region: "Europe",
        startDate: Date(),
        endDate: Calendar.current.date(byAdding: .day, value: 14, to: Date())!,
        durationDays: 14,
        plannedNights: 13,
        flightCost: 800,
        hotelCost: 1200,
        totalCost: 2000
    )
    
    let newStops = [
        TravelStop(
            id: nil,
            routeId: nil,
            location: "Paris",
            country: "France",
            nights: 3,
            hotelCost: 300,
            notes: "Visit Eiffel Tower"
        ),
        TravelStop(
            id: nil,
            routeId: nil,
            location: "Rome",
            country: "Italy",
            nights: 4,
            hotelCost: 400,
            notes: "Explore Colosseum"
        )
    ]
    
    Task {
        do {
            let (createdRoute, createdStops) = try await routesManager.createRoute(
                route: newRoute,
                stops: newStops
            )
            print("✅ Route created: \(createdRoute.title)")
            print("✅ Stops created: \(createdStops.count)")
        } catch {
            print("❌ Error: \(error.localizedDescription)")
        }
    }
}

// Example 2: Edit Route from Button Action
func editExistingRoute(routeId: UUID) {
    let updatedRoute = TravelRoute(
        id: routeId,
        title: "Updated European Adventure",
        region: "Europe",
        startDate: Date(),
        endDate: Calendar.current.date(byAdding: .day, value: 21, to: Date())!,
        durationDays: 21,
        plannedNights: 20,
        flightCost: 1000,
        hotelCost: 1500,
        totalCost: 2500
    )
    
    let updatedStops = [
        TravelStop(
            id: nil,
            routeId: routeId,
            location: "Paris",
            country: "France",
            nights: 5,
            hotelCost: 500,
            notes: "Extended stay in Paris"
        )
    ]
    
    Task {
        do {
            let (editedRoute, editedStops) = try await routesManager.editRoute(
                routeId: routeId,
                updatedRoute: updatedRoute,
                updatedStops: updatedStops
            )
            print("✅ Route updated: \(editedRoute.title)")
            print("✅ Stops updated: \(editedStops.count)")
        } catch {
            print("❌ Error: \(error.localizedDescription)")
        }
    }
}

// Example 3: Delete Route from Button Action
func deleteExistingRoute(routeId: UUID) {
    Task {
        do {
            try await routesManager.deleteRoute(routeId: routeId)
            print("✅ Route deleted successfully")
        } catch {
            print("❌ Error: \(error.localizedDescription)")
        }
    }
}
*/

