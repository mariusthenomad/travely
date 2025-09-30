import SwiftUI

struct HomeView: View {
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient like flights
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
                    Text("Home")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
                .padding(.bottom, 16)
                
                ScrollView {
                    VStack(spacing: FlatDesignSystem.paddingXL) {
                        // Welcome Section
                        FlatCard {
                            VStack(alignment: .leading, spacing: FlatDesignSystem.paddingM) {
                                Text("Welcome back!")
                                    .font(.system(size: 28, weight: .bold))
                                    .foregroundColor(FlatDesignSystem.text)
                                
                                Text("Ready for your next adventure?")
                                    .font(.system(size: 16, weight: .regular))
                                    .foregroundColor(FlatDesignSystem.textSecondary)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding(.horizontal, 20)
                        
                        // Quick Actions Grid - Modern Design
                        VStack(alignment: .leading, spacing: FlatDesignSystem.paddingM) {
                            FlatSectionHeader("Quick Actions")
                                .padding(.horizontal, 20)
                            
                            LazyVGrid(columns: [
                                GridItem(.flexible(), spacing: FlatDesignSystem.paddingM),
                                GridItem(.flexible(), spacing: FlatDesignSystem.paddingM)
                            ], spacing: FlatDesignSystem.paddingM) {
                                NavigationLink(destination: TravelRouteView()) {
                                    ModernActionCard(
                                        title: "Routes",
                                        subtitle: "Plan your journey",
                                        icon: "airplane",
                                        gradient: [Color(red: 1.0, green: 0.4, blue: 0.2), Color(red: 1.0, green: 0.6, blue: 0.3)]
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())
                                
                                NavigationLink(destination: HotelListView()) {
                                    ModernActionCard(
                                        title: "Hotels",
                                        subtitle: "Find accommodation",
                                        icon: "bed.double.fill",
                                        gradient: [Color(red: 0.2, green: 0.6, blue: 1.0), Color(red: 0.3, green: 0.7, blue: 1.0)]
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())
                                
                                NavigationLink(destination: DestinationSelectionView()) {
                                    ModernActionCard(
                                        title: "Destinations",
                                        subtitle: "Explore places",
                                        icon: "map.fill",
                                        gradient: [Color(red: 0.2, green: 0.8, blue: 0.4), Color(red: 0.3, green: 0.9, blue: 0.5)]
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())
                                
                                NavigationLink(destination: ProfileSettingsView()) {
                                    ModernActionCard(
                                        title: "Profile",
                                        subtitle: "Manage account",
                                        icon: "person.fill",
                                        gradient: [Color(red: 0.8, green: 0.2, blue: 0.8), Color(red: 0.9, green: 0.3, blue: 0.9)]
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                            .padding(.horizontal, FlatDesignSystem.paddingM)
                        }
                        
                    }
                    .padding(.bottom, 100) // Extra space for tab bar
                }
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct ModernActionCard: View {
    @EnvironmentObject var themeManager: ThemeManager
    let title: String
    let subtitle: String
    let icon: String
    let gradient: [Color]
    
    var body: some View {
        FlatCard {
            VStack(spacing: FlatDesignSystem.paddingM) {
                ZStack {
                    LinearGradient(
                        gradient: Gradient(colors: gradient),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .frame(width: 50, height: 50)
                    .cornerRadius(FlatDesignSystem.radiusL)
                    
                    Image(systemName: icon)
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(.white)
                }
                
                VStack(spacing: FlatDesignSystem.paddingS) {
                    Text(title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(FlatDesignSystem.text)
                    
                    Text(subtitle)
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(FlatDesignSystem.textSecondary)
                        .multilineTextAlignment(.center)
                }
            }
            .frame(height: 120)
            .frame(maxWidth: .infinity)
        }
    }
}

struct ModernDestinationCard: View {
    @EnvironmentObject var themeManager: ThemeManager
    let destination: Destination
    
    var body: some View {
        FlatCard {
            VStack(alignment: .leading, spacing: 0) {
                AsyncImage(url: URL(string: destination.imageURL)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    ZStack {
                        LinearGradient(
                            gradient: Gradient(colors: [
                                FlatDesignSystem.primaryBlue.opacity(0.1),
                                FlatDesignSystem.primaryBlue.opacity(0.3)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        
                        VStack(spacing: 4) {
                            Image(systemName: "photo")
                                .font(.system(size: 20))
                                .foregroundColor(FlatDesignSystem.primaryBlue.opacity(0.6))
                            
                            Text("Loading...")
                                .font(.system(size: 10, weight: .regular))
                                .foregroundColor(FlatDesignSystem.primaryBlue.opacity(0.6))
                        }
                    }
                }
                .frame(width: 200, height: 140)
                .clipped()
                .cornerRadius(FlatDesignSystem.radiusL, corners: [.topLeft, .topRight])
                
                VStack(alignment: .leading, spacing: FlatDesignSystem.paddingS) {
                    Text(destination.name)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(FlatDesignSystem.text)
                        .lineLimit(1)
                    
                    Text(destination.country)
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(FlatDesignSystem.textSecondary)
                }
                .padding(FlatDesignSystem.paddingM)
            }
            .frame(width: 200)
        }
    }
}

struct ModernActivityCard: View {
    @EnvironmentObject var themeManager: ThemeManager
    let booking: RecentBooking
    
    var body: some View {
        FlatCard {
            HStack(spacing: 16) {
                AsyncImage(url: URL(string: booking.imageURL)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Rectangle()
                        .fill(FlatDesignSystem.border)
                }
                .frame(width: 60, height: 60)
                .cornerRadius(FlatDesignSystem.radiusM)
                .clipped()
                
                VStack(alignment: .leading, spacing: FlatDesignSystem.paddingXS) {
                    Text(booking.title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(FlatDesignSystem.text)
                        .lineLimit(1)
                    
                    Text(booking.date)
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(FlatDesignSystem.textSecondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: FlatDesignSystem.paddingXS) {
                    Text(booking.status)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(booking.statusColor)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(booking.statusColor.opacity(0.1))
                        .cornerRadius(FlatDesignSystem.radiusM)
                }
            }
        }
    }
}

struct FeaturedDestinationCard: View {
    @EnvironmentObject var themeManager: ThemeManager
    let destination: Destination
    
    var body: some View {
        FlatCard {
            VStack(alignment: .leading, spacing: FlatDesignSystem.paddingM) {
                AsyncImage(url: URL(string: destination.imageURL)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    ZStack {
                        LinearGradient(
                            gradient: Gradient(colors: [
                                FlatDesignSystem.primaryBlue.opacity(0.1),
                                FlatDesignSystem.primaryBlue.opacity(0.3)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        
                        VStack(spacing: 4) {
                            Image(systemName: "photo")
                                .font(.system(size: 24))
                                .foregroundColor(FlatDesignSystem.primaryBlue.opacity(0.6))
                            
                            Text("Loading...")
                                .font(.system(size: 10, weight: .regular))
                                .foregroundColor(FlatDesignSystem.primaryBlue.opacity(0.6))
                        }
                    }
                }
                .frame(width: 200, height: 120)
                .cornerRadius(FlatDesignSystem.radiusM)
                .clipped()
                
                VStack(alignment: .leading, spacing: FlatDesignSystem.paddingS) {
                    Text(destination.name)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(FlatDesignSystem.text)
                    
                    Text(destination.country)
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(FlatDesignSystem.textSecondary)
                }
                .padding(.horizontal, 12)
                .padding(.bottom, 8)
            }
            .frame(width: 200)
        }
    }
}

// Sample data with high-quality images
let featuredDestinations = [
    Destination(id: 1, name: "Paris", country: "France", imageURL: "https://images.unsplash.com/photo-1502602898536-47ad22581b52?w=600&h=400&fit=crop&crop=center"),
    Destination(id: 2, name: "Tokyo", country: "Japan", imageURL: "https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=600&h=400&fit=crop&crop=center"),
    Destination(id: 3, name: "New York", country: "USA", imageURL: "https://images.unsplash.com/photo-1496442226666-8d4d0e62e6e9?w=600&h=400&fit=crop&crop=center"),
    Destination(id: 4, name: "London", country: "UK", imageURL: "https://images.unsplash.com/photo-1513635269975-59663e0ac1ad?w=600&h=400&fit=crop&crop=center"),
    Destination(id: 5, name: "Bali", country: "Indonesia", imageURL: "https://images.unsplash.com/photo-1537953773345-d172ccf13cf1?w=600&h=400&fit=crop&crop=center"),
    Destination(id: 6, name: "Bangkok", country: "Thailand", imageURL: "https://images.unsplash.com/photo-1528181304800-259b08848526?w=600&h=400&fit=crop&crop=center")
]

struct Destination: Identifiable {
    let id: Int
    let name: String
    let country: String
    let imageURL: String
}

struct HotelListView: View {
    var body: some View {
        NavigationView {
            List(sampleHotels) { hotel in
                NavigationLink(destination: HotelDetailView(hotel: hotel)) {
                    HotelRowView(hotel: hotel)
                }
            }
            .navigationTitle("Hotels")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct HotelRowView: View {
    let hotel: Hotel
    
    var body: some View {
        FlatCard {
            HStack(spacing: 12) {
                AsyncImage(url: URL(string: hotel.imageURL)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Rectangle()
                        .fill(FlatDesignSystem.border)
                }
                .frame(width: 80, height: 80)
                .cornerRadius(FlatDesignSystem.radiusM)
                
                VStack(alignment: .leading, spacing: FlatDesignSystem.paddingXS) {
                    Text(hotel.name)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(FlatDesignSystem.primaryBlue)
                    
                    Text(hotel.location)
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(FlatDesignSystem.textSecondary)
                    
                    HStack {
                        ForEach(0..<hotel.rating, id: \.self) { _ in
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                                .font(.system(size: 12))
                        }
                    }
                    
                    Text("$\(hotel.pricePerNight)/night")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(FlatDesignSystem.primaryBlue)
                }
                
                Spacer()
            }
        }
    }
}

struct DestinationDetailView: View {
    let destination: Destination
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: FlatDesignSystem.paddingL) {
                AsyncImage(url: URL(string: destination.imageURL)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                }
                .frame(height: 250)
                .cornerRadius(20)
                
                VStack(alignment: .leading, spacing: FlatDesignSystem.paddingM) {
                    Text(destination.name)
                        .font(.custom("Inter", size: 28))
                        .fontWeight(.bold)
                        .foregroundColor(Color(red: 0.11, green: 0.31, blue: 0.85))
                    
                    Text(destination.country)
                        .font(.custom("Inter", size: 18))
                        .foregroundColor(.gray)
                    
                    Text("Discover the beauty and culture of \(destination.name). From historic landmarks to modern attractions, there's something for everyone.")
                        .font(.custom("Inter", size: 16))
                        .foregroundColor(.gray)
                        .lineLimit(nil)
                }
                .padding(.horizontal, FlatDesignSystem.paddingM)
                
                Button(action: {}) {
                    Text("Book Now")
                        .primaryFlatButton()
                }
                .padding(.horizontal, FlatDesignSystem.paddingM)
            }
        }
        .navigationTitle(destination.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// Sample hotel data
let sampleHotels = [
    Hotel(id: 1, name: "Grand Hotel Paris", location: "Paris, France", imageURL: "https://images.unsplash.com/photo-1566073771259-6a8506099945?w=400", rating: 5, pricePerNight: 299, amenities: ["Wi-Fi", "Pool", "Spa", "Restaurant"]),
    Hotel(id: 2, name: "Tokyo Central Hotel", location: "Tokyo, Japan", imageURL: "https://images.unsplash.com/photo-1571896349842-33c89424de2d?w=400", rating: 4, pricePerNight: 199, amenities: ["Wi-Fi", "Gym", "Restaurant"]),
    Hotel(id: 3, name: "Manhattan Plaza", location: "New York, USA", imageURL: "https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?w=400", rating: 5, pricePerNight: 399, amenities: ["Wi-Fi", "Pool", "Spa", "Gym", "Restaurant"]),
    Hotel(id: 4, name: "London Heritage", location: "London, UK", imageURL: "https://images.unsplash.com/photo-1551882547-ff40c63fe5fa?w=400", rating: 4, pricePerNight: 249, amenities: ["Wi-Fi", "Restaurant", "Bar"])
]

struct RecentBookingCard: View {
    @EnvironmentObject var themeManager: ThemeManager
    let booking: RecentBooking
    
    var body: some View {
        FlatCard {
            VStack(alignment: .leading, spacing: FlatDesignSystem.paddingM) {
                AsyncImage(url: URL(string: booking.imageURL)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Rectangle()
                        .fill(FlatDesignSystem.border)
                }
                .frame(width: 160, height: 100)
                .clipped()
                .cornerRadius(FlatDesignSystem.radiusM, corners: [.topLeft, .topRight])
                
                VStack(alignment: .leading, spacing: FlatDesignSystem.paddingS) {
                    Text(booking.title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(FlatDesignSystem.text)
                        .lineLimit(1)
                    
                    Text(booking.date)
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(FlatDesignSystem.textSecondary)
                    
                    Text(booking.status)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(booking.statusColor)
                }
                .padding(.horizontal, 12)
                .padding(.bottom, 12)
            }
            .frame(width: 160)
        }
    }
}

struct RecentBooking: Identifiable {
    let id: Int
    let title: String
    let date: String
    let status: String
    let statusColor: Color
    let imageURL: String
}

// Sample recent bookings data
let recentBookings = [
    RecentBooking(id: 1, title: "Paris Hotel", date: "Dec 15-20, 2024", status: "Confirmed", statusColor: .green, imageURL: "https://images.unsplash.com/photo-1566073771259-6a8506099945?w=400"),
    RecentBooking(id: 2, title: "Tokyo Flight", date: "Jan 10, 2025", status: "Pending", statusColor: .orange, imageURL: "https://images.unsplash.com/photo-1436491865332-7a61a109cc05?w=400"),
    RecentBooking(id: 3, title: "Nevada Resort", date: "Feb 5-12, 2025", status: "Confirmed", statusColor: .green, imageURL: "https://images.unsplash.com/photo-1571896349842-33c89424de2d?w=400")
]

struct Hotel: Identifiable {
    let id: Int
    let name: String
    let location: String
    let imageURL: String
    let rating: Int
    let pricePerNight: Int
    let amenities: [String]
}


#Preview {
    HomeView()
}