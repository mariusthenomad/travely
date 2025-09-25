import SwiftUI

struct HotelDetailView: View {
    let hotel: Hotel
    @State private var selectedImageIndex = 0
    @State private var checkInDate = Date()
    @State private var checkOutDate = Date().addingTimeInterval(86400 * 2) // 2 days later
    @State private var guests = 2
    @State private var showingBookingConfirmation = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Hotel Image
                AsyncImage(url: URL(string: hotel.imageURL)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                }
                .frame(height: 300)
                .clipped()
                .overlay(
                    // Image indicators
                    VStack {
                        Spacer()
                        HStack(spacing: 8) {
                            ForEach(0..<3, id: \.self) { index in
                                Circle()
                                    .fill(index == selectedImageIndex ? Color.white : Color.white.opacity(0.5))
                                    .frame(width: 8, height: 8)
                            }
                        }
                        .padding(.bottom, 20)
                    }
                )
                
                VStack(alignment: .leading, spacing: 20) {
                    // Hotel Info
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(hotel.name)
                                    .font(.custom("Inter", size: 24))
                                    .fontWeight(.bold)
                                    .foregroundColor(Color(red: 0.11, green: 0.31, blue: 0.85))
                                
                                Text(hotel.location)
                                    .font(.custom("Inter", size: 16))
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .trailing, spacing: 4) {
                                HStack(spacing: 2) {
                                    ForEach(0..<hotel.rating, id: \.self) { _ in
                                        Image(systemName: "star.fill")
                                            .foregroundColor(.yellow)
                                            .font(.system(size: 16))
                                    }
                                }
                                
                                Text("\(hotel.rating).0")
                                    .font(.custom("Inter", size: 14))
                                    .fontWeight(.semibold)
                                    .foregroundColor(Color(red: 0.11, green: 0.31, blue: 0.85))
                            }
                        }
                        
                        Text("$\(hotel.pricePerNight) per night")
                            .font(.custom("Inter", size: 20))
                            .fontWeight(.bold)
                            .foregroundColor(Color(red: 0.11, green: 0.31, blue: 0.85))
                    }
                    
                    // Amenities
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Amenities")
                            .font(.custom("Inter", size: 18))
                            .fontWeight(.semibold)
                            .foregroundColor(Color(red: 0.11, green: 0.31, blue: 0.85))
                        
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 12) {
                            ForEach(hotel.amenities, id: \.self) { amenity in
                                HStack(spacing: 8) {
                                    Image(systemName: amenityIcon(for: amenity))
                                        .foregroundColor(Color(red: 0.11, green: 0.31, blue: 0.85))
                                        .font(.system(size: 16))
                                    
                                    Text(amenity)
                                        .font(.custom("Inter", size: 14))
                                        .foregroundColor(Color(red: 0.11, green: 0.31, blue: 0.85))
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(Color(red: 0.11, green: 0.31, blue: 0.85).opacity(0.1))
                                .cornerRadius(12)
                            }
                        }
                    }
                    
                    // Booking Details
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Booking Details")
                            .font(.custom("Inter", size: 18))
                            .fontWeight(.semibold)
                            .foregroundColor(Color(red: 0.11, green: 0.31, blue: 0.85))
                        
                        VStack(spacing: 12) {
                            HStack {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Check-in")
                                        .font(.custom("Inter", size: 14))
                                        .foregroundColor(.gray)
                                    
                                    DatePicker("", selection: $checkInDate, displayedComponents: .date)
                                        .datePickerStyle(CompactDatePickerStyle())
                                        .labelsHidden()
                                }
                                
                                Spacer()
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Check-out")
                                        .font(.custom("Inter", size: 14))
                                        .foregroundColor(.gray)
                                    
                                    DatePicker("", selection: $checkOutDate, displayedComponents: .date)
                                        .datePickerStyle(CompactDatePickerStyle())
                                        .labelsHidden()
                                }
                            }
                            
                            HStack {
                                Text("Guests")
                                    .font(.custom("Inter", size: 14))
                                    .foregroundColor(.gray)
                                
                                Spacer()
                                
                                HStack {
                                    Button(action: { if guests > 1 { guests -= 1 } }) {
                                        Image(systemName: "minus.circle.fill")
                                            .foregroundColor(Color(red: 0.11, green: 0.31, blue: 0.85))
                                            .font(.system(size: 20))
                                    }
                                    
                                    Text("\(guests)")
                                        .font(.custom("Inter", size: 16))
                                        .fontWeight(.semibold)
                                        .foregroundColor(Color(red: 0.11, green: 0.31, blue: 0.85))
                                        .frame(minWidth: 30)
                                    
                                    Button(action: { if guests < 8 { guests += 1 } }) {
                                        Image(systemName: "plus.circle.fill")
                                            .foregroundColor(Color(red: 0.11, green: 0.31, blue: 0.85))
                                            .font(.system(size: 20))
                                    }
                                }
                            }
                        }
                        .padding(16)
                        .background(Color.gray.opacity(0.05))
                        .cornerRadius(12)
                    }
                    
                    // Reviews Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Reviews")
                            .font(.custom("Inter", size: 18))
                            .fontWeight(.semibold)
                            .foregroundColor(Color(red: 0.11, green: 0.31, blue: 0.85))
                        
                        VStack(spacing: 12) {
                            ForEach(sampleReviews) { review in
                                ReviewCard(review: review)
                            }
                        }
                    }
                    
                    // Book Now Button
                    Button(action: { showingBookingConfirmation = true }) {
                        Text("Book Now")
                            .font(.custom("Inter", size: 18))
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color(red: 0.11, green: 0.31, blue: 0.85))
                            .cornerRadius(15)
                    }
                    .padding(.top, 20)
                }
                .padding(20)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(hotel.name)
        .alert("Booking Confirmation", isPresented: $showingBookingConfirmation) {
            Button("Confirm") {
                // Handle booking confirmation
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Your booking for \(hotel.name) has been confirmed!")
        }
    }
    
    private func amenityIcon(for amenity: String) -> String {
        switch amenity.lowercased() {
        case "wi-fi", "wifi":
            return "wifi"
        case "pool":
            return "figure.pool.swim"
        case "spa":
            return "leaf.fill"
        case "gym":
            return "dumbbell.fill"
        case "restaurant":
            return "fork.knife"
        case "bar":
            return "wineglass.fill"
        case "tv":
            return "tv.fill"
        case "parking":
            return "car.fill"
        default:
            return "checkmark.circle.fill"
        }
    }
}

struct ReviewCard: View {
    let review: Review
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(review.author)
                        .font(.custom("Inter", size: 14))
                        .fontWeight(.semibold)
                        .foregroundColor(Color(red: 0.11, green: 0.31, blue: 0.85))
                    
                    HStack(spacing: 2) {
                        ForEach(0..<review.rating, id: \.self) { _ in
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                                .font(.system(size: 12))
                        }
                    }
                }
                
                Spacer()
                
                Text(review.date)
                    .font(.custom("Inter", size: 12))
                    .foregroundColor(.gray)
            }
            
            Text(review.comment)
                .font(.custom("Inter", size: 14))
                .foregroundColor(.gray)
                .lineLimit(nil)
        }
        .padding(12)
        .background(Color.gray.opacity(0.05))
        .cornerRadius(12)
    }
}

struct Review: Identifiable {
    let id: Int
    let author: String
    let rating: Int
    let comment: String
    let date: String
}

let sampleReviews = [
    Review(id: 1, author: "Sarah Johnson", rating: 5, comment: "Amazing hotel with excellent service and beautiful rooms. The location is perfect and the staff is very friendly.", date: "2 days ago"),
    Review(id: 2, author: "Mike Chen", rating: 4, comment: "Great stay overall. The amenities are top-notch and the room was clean and comfortable.", date: "1 week ago"),
    Review(id: 3, author: "Emily Davis", rating: 5, comment: "Perfect location and wonderful experience. Would definitely recommend to anyone visiting the area.", date: "2 weeks ago")
]

#Preview {
    NavigationView {
        HotelDetailView(hotel: sampleHotels[0])
    }
}