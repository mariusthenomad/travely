import SwiftUI
import GoogleSignIn

@main
struct TravelyApp: App {
    @StateObject private var themeManager = ThemeManager()
    @StateObject private var supabaseManager = SupabaseManager.shared
    
    init() {
        // Configure Google Sign-In
        configureGoogleSignIn()
    }
    
    var body: some Scene {
        WindowGroup {
            Group {
                if supabaseManager.isAuthenticated {
                    ContentView()
                } else {
                    AuthenticationView()
                }
            }
            .environmentObject(themeManager)
            .environmentObject(supabaseManager)
            .preferredColorScheme(themeManager.isDarkMode ? .dark : .light)
        }
    }
    
    private func configureGoogleSignIn() {
        guard let path = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist"),
              let plist = NSDictionary(contentsOfFile: path),
              let clientId = plist["CLIENT_ID"] as? String else {
            print("Warning: GoogleService-Info.plist not found or CLIENT_ID missing")
            return
        }
        
        GIDSignIn.sharedInstance.configuration = GIDConfiguration(clientID: clientId)
    }
}