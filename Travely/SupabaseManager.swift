import Foundation
import Supabase

class SupabaseManager: ObservableObject {
    static let shared = SupabaseManager()
    
    let supabase: SupabaseClient
    
    private init() {
        let supabaseURL = URL(string: "https://mlnrhqbnphspbqcpzwez.supabase.co")!
        let supabaseKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1sbnJocWJucGhzcGJxY3B6d2V6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTg4MzIxMjcsImV4cCI6MjA3NDQwODEyN30.Kb3wbXqktjfwsAKD1jbUqWM-Jgmtnk_7W14sCwqZqyw"
        
        self.supabase = SupabaseClient(
            supabaseURL: supabaseURL,
            supabaseKey: supabaseKey
        )
    }
    
    // MARK: - Authentication
    @Published var isAuthenticated = false
    @Published var currentUser: User?
    
    func signUp(email: String, password: String) async throws {
        let response = try await supabase.auth.signUp(
            email: email,
            password: password
        )
        await MainActor.run {
            self.currentUser = response.user
            self.isAuthenticated = response.user != nil
        }
    }
    
    func signIn(email: String, password: String) async throws {
        let response = try await supabase.auth.signIn(
            email: email,
            password: password
        )
        await MainActor.run {
            self.currentUser = response.user
            self.isAuthenticated = response.user != nil
        }
    }
    
    func signOut() async throws {
        try await supabase.auth.signOut()
        await MainActor.run {
            self.currentUser = nil
            self.isAuthenticated = false
        }
    }
    
    // MARK: - Travel Routes
    func fetchTravelRoutes() async throws -> [TravelRoute] {
        let response: [TravelRouteDB] = try await supabase.database
            .from("travel_routes")
            .select()
            .execute()
            .value
        
        return response.map { $0.toTravelRoute() }
    }
    
    func saveTravelRoute(_ route: TravelRoute) async throws {
        let routeDB = TravelRouteDB(from: route)
        try await supabase.database
            .from("travel_routes")
            .insert(routeDB)
            .execute()
    }
    
    // MARK: - User Profile
    func fetchUserProfile() async throws -> UserProfile? {
        guard let user = currentUser else { return nil }
        
        let response: [UserProfileDB] = try await supabase.database
            .from("user_profiles")
            .select()
            .eq("user_id", value: user.id.uuidString)
            .execute()
            .value
        
        return response.first?.toUserProfile()
    }
    
    func saveUserProfile(_ profile: UserProfile) async throws {
        guard let user = currentUser else { return }
        
        let profileDB = UserProfileDB(from: profile, userId: user.id.uuidString)
        try await supabase.database
            .from("user_profiles")
            .upsert(profileDB)
            .execute()
    }
}

// MARK: - Database Models
struct TravelRouteDB: Codable {
    let id: UUID
    let title: String
    let description: String
    let duration: String
    let totalPrice: Int
    let imageURL: String
    let stops: String // JSON string
    let priceBreakdown: String // JSON string
    let createdAt: Date
    let userId: String?
    
    init(from route: TravelRoute) {
        self.id = UUID()
        self.title = route.title
        self.description = route.description
        self.duration = route.duration
        self.totalPrice = route.totalPrice
        self.imageURL = route.imageURL
        self.stops = (try? JSONEncoder().encode(route.stops).base64EncodedString()) ?? ""
        self.priceBreakdown = (try? JSONEncoder().encode(route.priceBreakdown).base64EncodedString()) ?? ""
        self.createdAt = Date()
        self.userId = nil
    }
    
    func toTravelRoute() -> TravelRoute {
        let stopsData = Data(base64Encoded: stops) ?? Data()
        let priceData = Data(base64Encoded: priceBreakdown) ?? Data()
        
        let decodedStops = (try? JSONDecoder().decode([RouteStop].self, from: stopsData)) ?? []
        let decodedPrices = (try? JSONDecoder().decode([PriceItem].self, from: priceData)) ?? []
        
        return TravelRoute(
            id: Int(id.hashValue),
            title: title,
            description: description,
            duration: duration,
            totalPrice: totalPrice,
            imageURL: imageURL,
            stops: decodedStops,
            priceBreakdown: decodedPrices
        )
    }
}

struct UserProfileDB: Codable {
    let id: UUID
    let userId: String
    let name: String
    let email: String
    let profileImageURL: String?
    let preferences: String // JSON string
    let createdAt: Date
    let updatedAt: Date
    
    init(from profile: UserProfile, userId: String) {
        self.id = UUID()
        self.userId = userId
        self.name = profile.name
        self.email = profile.email
        self.profileImageURL = profile.profileImageURL
        self.preferences = (try? JSONEncoder().encode(profile.preferences).base64EncodedString()) ?? ""
        self.createdAt = Date()
        self.updatedAt = Date()
    }
    
    func toUserProfile() -> UserProfile {
        let preferencesData = Data(base64Encoded: preferences) ?? Data()
        let decodedPreferences = (try? JSONDecoder().decode([String: Any].self, from: preferencesData)) ?? [:]
        
        return UserProfile(
            name: name,
            email: email,
            profileImageURL: profileImageURL,
            preferences: decodedPreferences
        )
    }
}

struct UserProfile {
    let name: String
    let email: String
    let profileImageURL: String?
    let preferences: [String: Any]
}
