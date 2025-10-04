import SwiftUI

struct UltraLightContentView: View {
    @State private var selectedTab = 0
    @State private var showingAddLocation = false
    
    let tabs = [
        TradeRepublicTabBar.TabItem(
            icon: "house",
            selectedIcon: "house.fill",
            title: "Home"
        ),
        TradeRepublicTabBar.TabItem(
            icon: "map",
            selectedIcon: "map.fill",
            title: "Routes"
        ),
        TradeRepublicTabBar.TabItem(
            icon: "globe",
            selectedIcon: "globe",
            title: "Explore"
        ),
        TradeRepublicTabBar.TabItem(
            icon: "person",
            selectedIcon: "person.fill",
            title: "Profile"
        )
    ]
    
    var body: some View {
        ZStack {
            // Background
            UltraLightDesignSystem.background
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Main Content
                TabView(selection: $selectedTab) {
                    HomeView()
                        .tag(0)
                    
                    RoutesView()
                        .tag(1)
                    
                    ExploreView()
                        .tag(2)
                    
                    ProfileView()
                        .tag(3)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                // Trade Republic Style Tab Bar
                TradeRepublicTabBar(selectedTab: $selectedTab, tabs: tabs)
                    .padding(.bottom, 8)
            }
            
            // Floating Action Button
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    UltraLightFAB(icon: "plus") {
                        showingAddLocation = true
                    }
                    .padding(.trailing, UltraLightDesignSystem.spaceL)
                    .padding(.bottom, 100) // Above tab bar
                }
            }
        }
        .sheet(isPresented: $showingAddLocation) {
            AddLocationView()
        }
    }
}

// MARK: - Home View
struct HomeView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: UltraLightDesignSystem.spaceL) {
                // Welcome Header
                TradeRepublicWindow(
                    title: "Welcome back!",
                    subtitle: "Ready for your next adventure?",
                    style: .gradient
                ) {
                    HStack {
                        VStack(alignment: .leading, spacing: UltraLightDesignSystem.spaceS) {
                            Text("Your Travel Stats")
                                .font(.system(size: 16, weight: .semibold, design: .rounded))
                                .foregroundColor(UltraLightDesignSystem.text)
                            
                            HStack(spacing: UltraLightDesignSystem.spaceL) {
                                StatCard(title: "Countries", value: "12", icon: "globe")
                                StatCard(title: "Cities", value: "47", icon: "building.2")
                                StatCard(title: "Trips", value: "8", icon: "airplane")
                            }
                        }
                        
                        Spacer()
                    }
                }
                
                // Quick Actions
                TradeRepublicWindow(
                    title: "Quick Actions",
                    style: .standard
                ) {
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: UltraLightDesignSystem.spaceL) {
                        QuickActionCard(
                            icon: "plus.circle.fill",
                            title: "Add Route",
                            subtitle: "Plan new trip",
                            color: UltraLightDesignSystem.primaryOrange
                        )
                        
                        QuickActionCard(
                            icon: "airplane.circle.fill",
                            title: "Book Flight",
                            subtitle: "Find flights",
                            color: UltraLightDesignSystem.primaryGreen
                        )
                        
                        QuickActionCard(
                            icon: "bed.double.fill",
                            title: "Hotels",
                            subtitle: "Find stays",
                            color: UltraLightDesignSystem.primaryOrange
                        )
                        
                        QuickActionCard(
                            icon: "map.circle.fill",
                            title: "Explore",
                            subtitle: "Discover places",
                            color: UltraLightDesignSystem.primaryGreen
                        )
                    }
                }
                
                // Recent Trips
                TradeRepublicWindow(
                    title: "Recent Trips",
                    style: .elevated
                ) {
                    VStack(spacing: UltraLightDesignSystem.spaceM) {
                        TripCard(
                            destination: "Paris, France",
                            date: "Oct 15-20, 2024",
                            status: "Planned",
                            color: UltraLightDesignSystem.primaryOrange
                        )
                        
                        TripCard(
                            destination: "Tokyo, Japan",
                            date: "Sep 8-15, 2024",
                            status: "Completed",
                            color: UltraLightDesignSystem.primaryGreen
                        )
                    }
                }
            }
            .padding(.horizontal, UltraLightDesignSystem.spaceL)
            .padding(.top, UltraLightDesignSystem.spaceL)
        }
    }
}

// MARK: - Routes View
struct RoutesView: View {
    @State private var routes: [Route] = [
        Route(name: "European Adventure", destinations: ["Paris", "Rome", "Barcelona"], duration: "14 days"),
        Route(name: "Asian Discovery", destinations: ["Tokyo", "Seoul", "Bangkok"], duration: "21 days")
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: UltraLightDesignSystem.spaceL) {
                // Header
                TradeRepublicWindow(
                    title: "Your Routes",
                    subtitle: "Plan and manage your trips",
                    style: .minimal
                ) {
                    EmptyView()
                }
                
                // Routes List
                ForEach(routes) { route in
                    TradeRepublicWindow(style: .standard) {
                        RouteCard(route: route)
                    }
                }
            }
            .padding(.horizontal, UltraLightDesignSystem.spaceL)
            .padding(.top, UltraLightDesignSystem.spaceL)
        }
    }
}

// MARK: - Explore View
struct ExploreView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: UltraLightDesignSystem.spaceL) {
                // Search
                TradeRepublicWindow(style: .glass) {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(UltraLightDesignSystem.textSecondary)
                        
                        Text("Search destinations...")
                            .foregroundColor(UltraLightDesignSystem.textSecondary)
                        
                        Spacer()
                    }
                }
                
                // Featured Destinations
                TradeRepublicWindow(
                    title: "Featured Destinations",
                    style: .elevated
                ) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: UltraLightDesignSystem.spaceL) {
                            DestinationCard(
                                name: "Santorini",
                                country: "Greece",
                                image: "sun.max.fill",
                                color: UltraLightDesignSystem.primaryOrange
                            )
                            
                            DestinationCard(
                                name: "Kyoto",
                                country: "Japan",
                                image: "leaf.fill",
                                color: UltraLightDesignSystem.primaryGreen
                            )
                            
                            DestinationCard(
                                name: "Reykjavik",
                                country: "Iceland",
                                image: "snowflake",
                                color: UltraLightDesignSystem.primaryOrange
                            )
                        }
                        .padding(.horizontal, UltraLightDesignSystem.spaceL)
                    }
                }
            }
            .padding(.horizontal, UltraLightDesignSystem.spaceL)
            .padding(.top, UltraLightDesignSystem.spaceL)
        }
    }
}

// MARK: - Profile View
struct ProfileView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: UltraLightDesignSystem.spaceL) {
                // Profile Header
                TradeRepublicWindow(style: .gradient) {
                    HStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [UltraLightDesignSystem.primaryOrange, UltraLightDesignSystem.primaryGreen],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 60, height: 60)
                            .overlay(
                                Text("M")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(.white)
                            )
                        
                        VStack(alignment: .leading, spacing: UltraLightDesignSystem.spaceXS) {
                            Text("Marius")
                                .font(.system(size: 20, weight: .bold, design: .rounded))
                                .foregroundColor(UltraLightDesignSystem.text)
                            
                            Text("Travel Enthusiast")
                                .font(.system(size: 14, weight: .medium, design: .rounded))
                                .foregroundColor(UltraLightDesignSystem.textSecondary)
                        }
                        
                        Spacer()
                    }
                }
                
                // Settings
                TradeRepublicWindow(
                    title: "Settings",
                    style: .standard
                ) {
                    VStack(spacing: UltraLightDesignSystem.spaceM) {
                        TradeRepublicListItem(
                            icon: "bell.fill",
                            title: "Notifications",
                            subtitle: "Manage your alerts",
                            action: {}
                        )
                        
                        TradeRepublicListItem(
                            icon: "lock.fill",
                            title: "Privacy",
                            subtitle: "Control your data",
                            action: {}
                        )
                        
                        TradeRepublicListItem(
                            icon: "questionmark.circle.fill",
                            title: "Help & Support",
                            subtitle: "Get assistance",
                            action: {}
                        )
                    }
                }
            }
            .padding(.horizontal, UltraLightDesignSystem.spaceL)
            .padding(.top, UltraLightDesignSystem.spaceL)
        }
    }
}

// MARK: - Supporting Views
struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(spacing: UltraLightDesignSystem.spaceXS) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(UltraLightDesignSystem.primaryOrange)
            
            Text(value)
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundColor(UltraLightDesignSystem.text)
            
            Text(title)
                .font(.system(size: 12, weight: .medium, design: .rounded))
                .foregroundColor(UltraLightDesignSystem.textSecondary)
        }
        .frame(maxWidth: .infinity)
    }
}

struct QuickActionCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    
    var body: some View {
        VStack(spacing: UltraLightDesignSystem.spaceM) {
            Image(systemName: icon)
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(color)
            
            VStack(spacing: UltraLightDesignSystem.spaceXS) {
                Text(title)
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundColor(UltraLightDesignSystem.text)
                
                Text(subtitle)
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundColor(UltraLightDesignSystem.textSecondary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(UltraLightDesignSystem.spaceL)
        .background(UltraLightDesignSystem.ultraLightSurface)
        .cornerRadius(UltraLightDesignSystem.radiusM)
    }
}

struct TripCard: View {
    let destination: String
    let date: String
    let status: String
    let color: Color
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: UltraLightDesignSystem.spaceXS) {
                Text(destination)
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundColor(UltraLightDesignSystem.text)
                
                Text(date)
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundColor(UltraLightDesignSystem.textSecondary)
            }
            
            Spacer()
            
            Text(status)
                .font(.system(size: 12, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .padding(.horizontal, UltraLightDesignSystem.spaceM)
                .padding(.vertical, UltraLightDesignSystem.spaceS)
                .background(
                    Capsule()
                        .fill(color)
                )
        }
        .padding(UltraLightDesignSystem.spaceM)
        .background(UltraLightDesignSystem.ultraLightSurface)
        .cornerRadius(UltraLightDesignSystem.radiusS)
    }
}

struct RouteCard: View {
    let route: Route
    
    var body: some View {
        VStack(alignment: .leading, spacing: UltraLightDesignSystem.spaceM) {
            HStack {
                Text(route.name)
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(UltraLightDesignSystem.text)
                
                Spacer()
                
                Text(route.duration)
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundColor(UltraLightDesignSystem.primaryGreen)
            }
            
            HStack {
                ForEach(route.destinations, id: \.self) { destination in
                    Text(destination)
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundColor(UltraLightDesignSystem.textSecondary)
                        .padding(.horizontal, UltraLightDesignSystem.spaceM)
                        .padding(.vertical, UltraLightDesignSystem.spaceS)
                        .background(UltraLightDesignSystem.ultraLightOrange)
                        .cornerRadius(UltraLightDesignSystem.radiusS)
                }
                
                Spacer()
            }
        }
    }
}

struct DestinationCard: View {
    let name: String
    let country: String
    let image: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: UltraLightDesignSystem.spaceM) {
            ZStack {
                RoundedRectangle(cornerRadius: UltraLightDesignSystem.radiusM)
                    .fill(color.opacity(0.2))
                    .frame(width: 120, height: 80)
                
                Image(systemName: image)
                    .font(.system(size: 32, weight: .medium))
                    .foregroundColor(color)
            }
            
            VStack(alignment: .leading, spacing: UltraLightDesignSystem.spaceXS) {
                Text(name)
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(UltraLightDesignSystem.text)
                
                Text(country)
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundColor(UltraLightDesignSystem.textSecondary)
            }
        }
        .frame(width: 120)
    }
}

struct AddLocationView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Add Location")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(UltraLightDesignSystem.text)
                    .padding()
                
                Spacer()
                
                Text("Location search coming soon...")
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundColor(UltraLightDesignSystem.textSecondary)
                
                Spacer()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(UltraLightDesignSystem.primaryOrange)
                }
            }
        }
    }
}

// MARK: - Data Models
struct Route: Identifiable {
    let id = UUID()
    let name: String
    let destinations: [String]
    let duration: String
}

#Preview {
    UltraLightContentView()
}

