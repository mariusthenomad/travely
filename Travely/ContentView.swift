import SwiftUI

struct ContentView: View {
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
            
            TravelRouteView()
                .tabItem {
                    Image(systemName: "map.fill")
                    Text("Routes")
                }
            
            DestinationSelectionView()
                .tabItem {
                    Image(systemName: "globe.americas.fill")
                    Text("Destinations")
                }
            
            ProfileSettingsView()
                .tabItem {
                    Image(systemName: "person.circle.fill")
                    Text("Profile")
                }
        }
        .accentColor(themeManager.primaryColor)
        .background(themeManager.oledBackgroundColor)
        .preferredColorScheme(themeManager.isDarkMode ? .dark : .light)
    }
}