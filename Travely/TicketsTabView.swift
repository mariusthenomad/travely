import SwiftUI

struct TicketsTabView: View {
    @State private var selectedCategory: BookingCategory = .all
    @State private var searchText = ""
    @State private var showingAddBooking = false
    
    var filteredBookings: [Booking] {
        let bookings = sampleBookings
        
        let categoryFiltered = selectedCategory == .all ? bookings : bookings.filter { $0.category == selectedCategory }
        
        if searchText.isEmpty {
            return categoryFiltered
        } else {
            return categoryFiltered.filter { booking in
                booking.title.localizedCaseInsensitiveContains(searchText) ||
                booking.destination.localizedCaseInsensitiveContains(searchText) ||
                booking.provider.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header with Search
                VStack(spacing: 16) {
                    HStack {
                        Text("My Bookings")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        Button(action: { showingAddBooking = true }) {
                            Image(systemName: "plus.circle.fill")
                                .font(.title2)
                                .foregroundColor(.orange)
                        }
                    }
                    
                    // Search Bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.secondary)
                        
                        TextField("Search bookings...", text: $searchText)
                            .textFieldStyle(PlainTextFieldStyle())
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
                .padding(.bottom, 16)
                
                // Category Filter
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(BookingCategory.allCases, id: \.self) { category in
                            CategoryChip(
                                title: category.title,
                                icon: category.icon,
                                isSelected: selectedCategory == category
                            ) {
                                selectedCategory = category
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.bottom, 16)
                
                // Bookings List
                if filteredBookings.isEmpty {
                    EmptyBookingsView(category: selectedCategory)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(filteredBookings) { booking in
                                BookingCard(booking: booking)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                    }
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showingAddBooking) {
            AddBookingView()
        }
    }
}

// MARK: - Booking Models

enum BookingCategory: String, CaseIterable {
    case all = "all"
    case flights = "flights"
    case hotels = "hotels"
    case airbnb = "airbnb"
    case trains = "trains"
    case activities = "activities"
    
    var title: String {
        switch self {
        case .all: return "All"
        case .flights: return "Flights"
        case .hotels: return "Hotels"
        case .airbnb: return "Airbnb"
        case .trains: return "Trains"
        case .activities: return "Activities"
        }
    }
    
    var icon: String {
        switch self {
        case .all: return "ticket.fill"
        case .flights: return "airplane"
        case .hotels: return "bed.double.fill"
        case .airbnb: return "house.fill"
        case .trains: return "tram.fill"
        case .activities: return "star.fill"
        }
    }
}

struct Booking: Identifiable {
    let id = UUID()
    let title: String
    let destination: String
    let provider: String
    let category: BookingCategory
    let date: String
    let time: String?
    let price: String
    let confirmationNumber: String
    let status: BookingStatus
    let imageURL: String?
    let details: BookingDetails?
}

enum BookingStatus: String, CaseIterable {
    case confirmed = "confirmed"
    case pending = "pending"
    case cancelled = "cancelled"
    case completed = "completed"
    
    var color: Color {
        switch self {
        case .confirmed: return .green
        case .pending: return .orange
        case .cancelled: return .red
        case .completed: return .blue
        }
    }
    
    var title: String {
        switch self {
        case .confirmed: return "Confirmed"
        case .pending: return "Pending"
        case .cancelled: return "Cancelled"
        case .completed: return "Completed"
        }
    }
}

struct BookingDetails {
    let checkIn: String?
    let checkOut: String?
    let flightNumber: String?
    let seatNumber: String?
    let gate: String?
    let terminal: String?
    let roomType: String?
    let guests: Int?
}

// MARK: - Sample Data

let sampleBookings: [Booking] = [
    // Flights
    Booking(
        title: "Munich → Taipei",
        destination: "Taipei, Taiwan",
        provider: "Lufthansa",
        category: .flights,
        date: "Mar 7, 2024",
        time: "14:30",
        price: "€589",
        confirmationNumber: "LH123456",
        status: .confirmed,
        imageURL: "https://images.unsplash.com/photo-1436491865332-7a61a109cc05?w=400&h=300&fit=crop",
        details: BookingDetails(
            checkIn: nil,
            checkOut: nil,
            flightNumber: "LH123",
            seatNumber: "12A",
            gate: "A12",
            terminal: "Terminal 2",
            roomType: nil,
            guests: nil
        )
    ),
    Booking(
        title: "Taipei → Bali",
        destination: "Bali, Indonesia",
        provider: "EVA Air",
        category: .flights,
        date: "Mar 14, 2024",
        time: "08:15",
        price: "€445",
        confirmationNumber: "BR789012",
        status: .confirmed,
        imageURL: "https://images.unsplash.com/photo-1436491865332-7a61a109cc05?w=400&h=300&fit=crop",
        details: BookingDetails(
            checkIn: nil,
            checkOut: nil,
            flightNumber: "BR123",
            seatNumber: "8C",
            gate: "B8",
            terminal: "Terminal 1",
            roomType: nil,
            guests: nil
        )
    ),
    
    // Hotels
    Booking(
        title: "Taichung Hotel",
        destination: "Taichung, Taiwan",
        provider: "Booking.com",
        category: .hotels,
        date: "Mar 7-11, 2024",
        time: nil,
        price: "€360",
        confirmationNumber: "BK345678",
        status: .confirmed,
        imageURL: "https://images.unsplash.com/photo-1566073771259-6a8506099945?w=400&h=300&fit=crop",
        details: BookingDetails(
            checkIn: "Mar 7, 2024",
            checkOut: "Mar 11, 2024",
            flightNumber: nil,
            seatNumber: nil,
            gate: nil,
            terminal: nil,
            roomType: "Deluxe Double",
            guests: 2
        )
    ),
    Booking(
        title: "Bali Resort & Spa",
        destination: "Ubud, Bali",
        provider: "Agoda",
        category: .hotels,
        date: "Mar 14-24, 2024",
        time: nil,
        price: "€650",
        confirmationNumber: "AG901234",
        status: .confirmed,
        imageURL: "https://images.unsplash.com/photo-1571896349842-33c89424de2d?w=400&h=300&fit=crop",
        details: BookingDetails(
            checkIn: "Mar 14, 2024",
            checkOut: "Mar 24, 2024",
            flightNumber: nil,
            seatNumber: nil,
            gate: nil,
            terminal: nil,
            roomType: "Villa with Pool",
            guests: 2
        )
    ),
    
    // Airbnb
    Booking(
        title: "Cozy Taipei Apartment",
        destination: "Taipei, Taiwan",
        provider: "Airbnb",
        category: .airbnb,
        date: "Mar 11-13, 2024",
        time: nil,
        price: "€180",
        confirmationNumber: "AB567890",
        status: .confirmed,
        imageURL: "https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=400&h=300&fit=crop",
        details: BookingDetails(
            checkIn: "Mar 11, 2024",
            checkOut: "Mar 13, 2024",
            flightNumber: nil,
            seatNumber: nil,
            gate: nil,
            terminal: nil,
            roomType: "Entire Apartment",
            guests: 2
        )
    ),
    
    // Trains
    Booking(
        title: "Taipei → Taichung",
        destination: "Taichung, Taiwan",
        provider: "Taiwan Railway",
        category: .trains,
        date: "Mar 7, 2024",
        time: "16:45",
        price: "€25",
        confirmationNumber: "TR123456",
        status: .confirmed,
        imageURL: "https://images.unsplash.com/photo-1544620347-c4fd4a3d5957?w=400&h=300&fit=crop",
        details: BookingDetails(
            checkIn: nil,
            checkOut: nil,
            flightNumber: "TR123",
            seatNumber: "Car 3, Seat 12",
            gate: nil,
            terminal: nil,
            roomType: nil,
            guests: nil
        )
    ),
    
    // Activities
    Booking(
        title: "Bali Cooking Class",
        destination: "Ubud, Bali",
        provider: "GetYourGuide",
        category: .activities,
        date: "Mar 18, 2024",
        time: "10:00",
        price: "€45",
        confirmationNumber: "GY234567",
        status: .confirmed,
        imageURL: "https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=400&h=300&fit=crop",
        details: BookingDetails(
            checkIn: nil,
            checkOut: nil,
            flightNumber: nil,
            seatNumber: nil,
            gate: nil,
            terminal: nil,
            roomType: nil,
            guests: 2
        )
    )
]

// MARK: - Views

struct CategoryChip: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.caption)
                
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(isSelected ? Color.orange : Color(.systemGray6))
            .foregroundColor(isSelected ? .white : .primary)
            .cornerRadius(20)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct BookingCard: View {
    let booking: Booking
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(booking.title)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    Text(booking.destination)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text(booking.price)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.orange)
                    
                    StatusBadge(status: booking.status)
                }
            }
            
            // Details
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(booking.provider)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text(booking.date)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    if let time = booking.time {
                        Text(time)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 2) {
                    Text("Confirmation")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    
                    Text(booking.confirmationNumber)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                }
            }
            
            // Category Badge
            HStack {
                Image(systemName: booking.category.icon)
                    .font(.caption)
                    .foregroundColor(.orange)
                
                Text(booking.category.title)
                    .font(.caption)
                    .foregroundColor(.orange)
                
                Spacer()
            }
        }
        .padding(16)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

struct StatusBadge: View {
    let status: BookingStatus
    
    var body: some View {
        Text(status.title)
            .font(.caption2)
            .fontWeight(.medium)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(status.color.opacity(0.2))
            .foregroundColor(status.color)
            .cornerRadius(8)
    }
}

struct EmptyBookingsView: View {
    let category: BookingCategory
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: category.icon)
                .font(.system(size: 48))
                .foregroundColor(.secondary)
            
            Text("No \(category.title.lowercased()) bookings")
                .font(.headline)
                .foregroundColor(.primary)
            
            Text("Your \(category.title.lowercased()) bookings will appear here")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(40)
    }
}

struct AddBookingView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Add New Booking")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
                
                Text("Coming soon...")
                    .foregroundColor(.secondary)
                
                Spacer()
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
}

// MARK: - Preview

struct TicketsTabView_Previews: PreviewProvider {
    static var previews: some View {
        TicketsTabView()
    }
}
