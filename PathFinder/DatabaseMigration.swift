import Foundation
import Supabase

// MARK: - Database Migration Manager
class DatabaseMigrationManager: ObservableObject {
    private let supabase: SupabaseClient
    
    @Published var migrationStatus: String = "Ready to migrate"
    @Published var isMigrating: Bool = false
    
    init() {
        // Initialize Supabase client with your existing configuration
        let supabaseURL = URL(string: "YOUR_SUPABASE_URL")!
        let supabaseKey = "YOUR_SUPABASE_ANON_KEY"
        
        self.supabase = SupabaseClient(
            supabaseURL: supabaseURL,
            supabaseKey: supabaseKey
        )
    }
    
    // MARK: - Main Migration Function
    @MainActor
    func runMigration() async {
        isMigrating = true
        migrationStatus = "Starting migration..."
        
        do {
            // Step 1: Create tables
            migrationStatus = "Creating travel_routes table..."
            try await createTravelRoutesTable()
            
            migrationStatus = "Creating travel_stops table..."
            try await createTravelStopsTable()
            
            migrationStatus = "Creating travel_bookings table..."
            try await createTravelBookingsTable()
            
            // Step 2: Insert sample data
            migrationStatus = "Inserting sample route..."
            let routeId = try await insertSampleRoute()
            
            migrationStatus = "Inserting sample stops..."
            try await insertSampleStops(routeId: routeId)
            
            migrationStatus = "Migration completed successfully! ✅"
            
        } catch {
            migrationStatus = "Migration failed: \(error.localizedDescription) ❌"
            print("Migration error: \(error)")
        }
        
        isMigrating = false
    }
    
    // MARK: - Table Creation Functions
    private func createTravelRoutesTable() async throws {
        let sql = """
        CREATE TABLE IF NOT EXISTS travel_routes (
            id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
            title TEXT NOT NULL,
            region TEXT,
            start_date DATE NOT NULL,
            end_date DATE NOT NULL,
            duration_days INTEGER,
            planned_nights INTEGER,
            flight_cost NUMERIC,
            hotel_cost NUMERIC,
            total_cost NUMERIC,
            created_at TIMESTAMPTZ DEFAULT NOW()
        );
        """
        
        let response = try await supabase.rpc("exec_sql", params: ["sql": sql])
        print("✅ travel_routes table created/verified")
    }
    
    private func createTravelStopsTable() async throws {
        let sql = """
        CREATE TABLE IF NOT EXISTS travel_stops (
            id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
            route_id UUID REFERENCES travel_routes(id) ON DELETE CASCADE,
            location TEXT NOT NULL,
            country TEXT,
            nights INTEGER,
            hotel_cost NUMERIC,
            notes TEXT
        );
        """
        
        let response = try await supabase.rpc("exec_sql", params: ["sql": sql])
        print("✅ travel_stops table created/verified")
    }
    
    private func createTravelBookingsTable() async throws {
        let sql = """
        CREATE TABLE IF NOT EXISTS travel_bookings (
            id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
            stop_id UUID REFERENCES travel_stops(id) ON DELETE CASCADE,
            type TEXT CHECK (type IN ('flight', 'hotel', 'train', 'other')),
            provider TEXT,
            cost NUMERIC,
            booking_ref TEXT
        );
        """
        
        let response = try await supabase.rpc("exec_sql", params: ["sql": sql])
        print("✅ travel_bookings table created/verified")
    }
    
    // MARK: - Data Insertion Functions
    private func insertSampleRoute() async throws -> String {
        let sql = """
        INSERT INTO travel_routes (
            title, region, start_date, end_date, duration_days, 
            planned_nights, flight_cost, hotel_cost, total_cost
        ) VALUES (
            'Asia Route 2026', 'Asia', '2026-03-01', '2026-03-21', 
            21, 20, 1200, 1800, 3000
        ) RETURNING id;
        """
        
        let response = try await supabase.rpc("exec_sql", params: ["sql": sql])
        
        // Extract the returned ID from the response
        if let data = response.data as? [[String: Any]],
           let firstRow = data.first,
           let id = firstRow["id"] as? String {
            print("✅ Sample route inserted with ID: \(id)")
            return id
        } else {
            throw DatabaseError.insertionFailed("Could not retrieve route ID")
        }
    }
    
    private func insertSampleStops(routeId: String) async throws {
        let stops = [
            ("Bangkok", "Thailand", 3, 250, "Capital city with amazing street food"),
            ("Singapore", "Singapore", 2, 300, "Modern city-state with diverse culture"),
            ("Bali", "Indonesia", 7, 600, "Tropical paradise with beautiful beaches"),
            ("Tokyo", "Japan", 4, 400, "Bustling metropolis with rich history"),
            ("Seoul", "South Korea", 4, 250, "Dynamic city blending tradition and modernity")
        ]
        
        for (location, country, nights, hotelCost, notes) in stops {
            let sql = """
            INSERT INTO travel_stops (
                route_id, location, country, nights, hotel_cost, notes
            ) VALUES (
                '\(routeId)', '\(location)', '\(country)', \(nights), \(hotelCost), '\(notes)'
            );
            """
            
            let response = try await supabase.rpc("exec_sql", params: ["sql": sql])
            print("✅ Stop inserted: \(location), \(country)")
        }
    }
    
    // MARK: - Verification Functions
    func verifyMigration() async throws {
        migrationStatus = "Verifying migration..."
        
        // Check if tables exist and have data
        let routeCountSQL = "SELECT COUNT(*) as count FROM travel_routes;"
        let stopCountSQL = "SELECT COUNT(*) as count FROM travel_stops;"
        
        let routeResponse = try await supabase.rpc("exec_sql", params: ["sql": routeCountSQL])
        let stopResponse = try await supabase.rpc("exec_sql", params: ["sql": stopCountSQL])
        
        if let routeData = routeResponse.data as? [[String: Any]],
           let routeCount = routeData.first?["count"] as? Int,
           let stopData = stopResponse.data as? [[String: Any]],
           let stopCount = stopData.first?["count"] as? Int {
            
            migrationStatus = "✅ Migration verified: \(routeCount) routes, \(stopCount) stops"
            print("Migration verification: \(routeCount) routes, \(stopCount) stops")
        }
    }
    
    // MARK: - Query Functions for Testing
    func fetchAllRoutes() async throws -> [[String: Any]] {
        let sql = "SELECT * FROM travel_routes ORDER BY created_at DESC;"
        let response = try await supabase.rpc("exec_sql", params: ["sql": sql])
        
        if let data = response.data as? [[String: Any]] {
            return data
        } else {
            throw DatabaseError.queryFailed("Could not fetch routes")
        }
    }
    
    func fetchStopsForRoute(routeId: String) async throws -> [[String: Any]] {
        let sql = "SELECT * FROM travel_stops WHERE route_id = '\(routeId)' ORDER BY nights;"
        let response = try await supabase.rpc("exec_sql", params: ["sql": sql])
        
        if let data = response.data as? [[String: Any]] {
            return data
        } else {
            throw DatabaseError.queryFailed("Could not fetch stops")
        }
    }
}

// MARK: - Database Error Types
enum DatabaseError: Error, LocalizedError {
    case insertionFailed(String)
    case queryFailed(String)
    case migrationFailed(String)
    
    var errorDescription: String? {
        switch self {
        case .insertionFailed(let message):
            return "Insertion failed: \(message)"
        case .queryFailed(let message):
            return "Query failed: \(message)"
        case .migrationFailed(let message):
            return "Migration failed: \(message)"
        }
    }
}

// MARK: - Usage Example
/*
// In your ContentView or wherever you want to run the migration:

struct MigrationView: View {
    @StateObject private var migrationManager = DatabaseMigrationManager()
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Database Migration")
                .font(.title)
                .fontWeight(.bold)
            
            Text(migrationManager.migrationStatus)
                .foregroundColor(migrationManager.isMigrating ? .orange : .green)
                .multilineTextAlignment(.center)
            
            Button(action: {
                Task {
                    await migrationManager.runMigration()
                }
            }) {
                Text(migrationManager.isMigrating ? "Migrating..." : "Run Migration")
                    .foregroundColor(.white)
                    .padding()
                    .background(migrationManager.isMigrating ? Color.gray : Color.blue)
                    .cornerRadius(10)
            }
            .disabled(migrationManager.isMigrating)
            
            Button("Verify Migration") {
                Task {
                    try await migrationManager.verifyMigration()
                }
            }
            .disabled(migrationManager.isMigrating)
        }
        .padding()
    }
}
*/

