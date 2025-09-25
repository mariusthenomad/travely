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
                    VStack(spacing: 32) {
                        // Welcome Section
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Welcome back!")
                                .font(.custom("Inter", size: 28))
                                .fontWeight(.bold)
                                .foregroundColor(themeManager.textColor)
                            
                            Text("Ready for your next adventure?")
                                .font(.custom("Inter", size: 16))
                                .foregroundColor(themeManager.secondaryTextColor)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)
                        
                        // Quick Actions Grid - Modern Design
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Quick Actions")
                                .font(.custom("Inter", size: 20))
                                .fontWeight(.semibold)
                                .foregroundColor(themeManager.textColor)
                                .padding(.horizontal, 20)
                            
                            LazyVGrid(columns: [
                                GridItem(.flexible(), spacing: 12),
                                GridItem(.flexible(), spacing: 12)
                            ], spacing: 16) {
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
                            .padding(.horizontal, 20)
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
        VStack(spacing: 16) {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: gradient),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .frame(width: 50, height: 50)
                .cornerRadius(25)
                
                Image(systemName: icon)
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(.white)
            }
            
            VStack(spacing: 6) {
                Text(title)
                    .font(.custom("Inter", size: 16))
                    .fontWeight(.semibold)
                    .foregroundColor(themeManager.textColor)
                
                Text(subtitle)
                    .font(.custom("Inter", size: 12))
                    .foregroundColor(themeManager.secondaryTextColor)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(height: 140)
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 6)
    }
}

struct ModernDestinationCard: View {
    @EnvironmentObject var themeManager: ThemeManager
    let destination: Destination
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            AsyncImage(url: URL(string: destination.imageURL)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                ZStack {
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 1.0, green: 0.4, blue: 0.2).opacity(0.1),
                            Color(red: 1.0, green: 0.4, blue: 0.2).opacity(0.3)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    
                    VStack(spacing: 4) {
                        Image(systemName: "photo")
                            .font(.system(size: 20))
                            .foregroundColor(Color(red: 1.0, green: 0.4, blue: 0.2).opacity(0.6))
                        
                        Text("Loading...")
                            .font(.custom("Inter", size: 10))
                            .foregroundColor(Color(red: 1.0, green: 0.4, blue: 0.2).opacity(0.6))
                    }
                }
            }
            .frame(width: 200, height: 140)
            .clipped()
            .cornerRadius(16, corners: [.topLeft, .topRight])
            
            VStack(alignment: .leading, spacing: 8) {
                Text(destination.name)
                    .font(.custom("Inter", size: 16))
                    .fontWeight(.semibold)
                    .foregroundColor(themeManager.textColor)
                    .lineLimit(1)
                
                Text(destination.country)
                    .font(.custom("Inter", size: 14))
                    .foregroundColor(themeManager.secondaryTextColor)
            }
            .padding(16)
        }
        .frame(width: 200)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 6)
    }
}

struct ModernActivityCard: View {
    @EnvironmentObject var themeManager: ThemeManager
    let booking: RecentBooking
    
    var body: some View {
        HStack(spacing: 16) {
            AsyncImage(url: URL(string: booking.imageURL)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
            }
            .frame(width: 60, height: 60)
            .cornerRadius(12)
            .clipped()
            
            VStack(alignment: .leading, spacing: 4) {
                Text(booking.title)
                    .font(.custom("Inter", size: 16))
                    .fontWeight(.semibold)
                    .foregroundColor(themeManager.textColor)
                    .lineLimit(1)
                
                Text(booking.date)
                    .font(.custom("Inter", size: 14))
                    .foregroundColor(themeManager.secondaryTextColor)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(booking.status)
                    .font(.custom("Inter", size: 14))
                    .fontWeight(.medium)
                    .foregroundColor(booking.statusColor)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(booking.statusColor.opacity(0.1))
                    .cornerRadius(12)
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}

struct FeaturedDestinationCard: View {
    @EnvironmentObject var themeManager: ThemeManager
    let destination: Destination
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            AsyncImage(url: URL(string: destination.imageURL)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                // Better placeholder with gradient
                ZStack {
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 1.0, green: 0.4, blue: 0.2).opacity(0.1),
                            Color(red: 1.0, green: 0.4, blue: 0.2).opacity(0.3)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    
                    VStack(spacing: 4) {
                        Image(systemName: "photo")
                            .font(.system(size: 24))
                            .foregroundColor(Color(red: 1.0, green: 0.4, blue: 0.2).opacity(0.6))
                        
                        Text("Loading...")
                            .font(.custom("Inter", size: 10))
                            .foregroundColor(Color(red: 1.0, green: 0.4, blue: 0.2).opacity(0.6))
                    }
                }
            }
            .frame(width: 200, height: 120)
            .cornerRadius(12)
            .clipped()
            
            VStack(alignment: .leading, spacing: 6) {
                Text(destination.name)
                    .font(.custom("Inter", size: 16))
                    .fontWeight(.semibold)
                    .foregroundColor(themeManager.textColor)
                
                Text(destination.country)
                    .font(.custom("Inter", size: 14))
                    .foregroundColor(themeManager.secondaryTextColor)
            }
            .padding(.horizontal, 12)
            .padding(.bottom, 8)
        }
        .frame(width: 200)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
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
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: hotel.imageURL)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
            }
            .frame(width: 80, height: 80)
            .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(hotel.name)
                    .font(.custom("Inter", size: 16))
                    .fontWeight(.semibold)
                    .foregroundColor(Color(red: 0.11, green: 0.31, blue: 0.85))
                
                Text(hotel.location)
                    .font(.custom("Inter", size: 14))
                    .foregroundColor(.gray)
                
                HStack {
                    ForEach(0..<hotel.rating, id: \.self) { _ in
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .font(.system(size: 12))
                    }
                }
                
                Text("$\(hotel.pricePerNight)/night")
                    .font(.custom("Inter", size: 14))
                    .fontWeight(.semibold)
                    .foregroundColor(Color(red: 0.11, green: 0.31, blue: 0.85))
            }
            
            Spacer()
        }
        .padding(.vertical, 8)
    }
}

struct DestinationDetailView: View {
    let destination: Destination
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
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
                
                VStack(alignment: .leading, spacing: 12) {
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
                .padding(.horizontal, 20)
                
                Button(action: {}) {
                    Text("Book Now")
                        .font(.custom("Inter", size: 18))
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color(red: 0.11, green: 0.31, blue: 0.85))
                        .cornerRadius(15)
                }
                .padding(.horizontal, 20)
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
        VStack(alignment: .leading, spacing: 12) {
            AsyncImage(url: URL(string: booking.imageURL)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
            }
            .frame(width: 160, height: 100)
            .clipped()
            .cornerRadius(12, corners: [.topLeft, .topRight])
            
            VStack(alignment: .leading, spacing: 6) {
                Text(booking.title)
                    .font(.custom("Inter", size: 16))
                    .fontWeight(.semibold)
                    .foregroundColor(themeManager.textColor)
                    .lineLimit(1)
                
                Text(booking.date)
                    .font(.custom("Inter", size: 14))
                    .foregroundColor(themeManager.secondaryTextColor)
                
                Text(booking.status)
                    .font(.custom("Inter", size: 14))
                    .fontWeight(.medium)
                    .foregroundColor(booking.statusColor)
            }
            .padding(.horizontal, 12)
            .padding(.bottom, 12)
        }
        .frame(width: 160)
        .background(Color.white) // White background
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4) // Light shadow
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