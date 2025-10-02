import SwiftUI

struct FlightSearchView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @State private var origin = ""
    @State private var destination = ""
    @State private var departureDate = Date()
    @State private var returnDate = Date().addingTimeInterval(86400 * 7) // 7 days later
    @State private var passengers = 1
    @State private var isReturnTrip = true
    @State private var searchResults: [Flight] = []
    @State private var isSearching = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Search Form
                    VStack(spacing: 16) {
                        // Trip Type Toggle
                        HStack {
                            Button(action: { isReturnTrip = false }) {
                                Text("One Way")
                                    .font(.custom("Inter", size: 16))
                                    .fontWeight(.medium)
                                    .foregroundColor(isReturnTrip ? themeManager.secondaryTextColor : themeManager.primaryColor)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 44)
                                    .background(isReturnTrip ? Color.clear : themeManager.primaryColor.opacity(0.1))
                                    .cornerRadius(22)
                            }
                            
                            Button(action: { isReturnTrip = true }) {
                                Text("Round Trip")
                                    .font(.custom("Inter", size: 16))
                                    .fontWeight(.medium)
                                    .foregroundColor(isReturnTrip ? themeManager.primaryColor : themeManager.secondaryTextColor)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 44)
                                    .background(isReturnTrip ? themeManager.primaryColor.opacity(0.1) : Color.clear)
                                    .cornerRadius(22)
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        // Origin and Destination
                        VStack(spacing: 12) {
                            HStack(spacing: 12) {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("From")
                                        .font(.custom("Inter", size: 14))
                                        .foregroundColor(themeManager.secondaryTextColor)
                                    
                                    TextField("Origin", text: $origin)
                                        .font(.custom("Inter", size: 16))
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                }
                                
                                Button(action: {
                                    let temp = origin
                                    origin = destination
                                    destination = temp
                                }) {
                                    Image(systemName: "arrow.up.arrow.down")
                                        .foregroundColor(themeManager.primaryColor)
                                        .font(.system(size: 20))
                                }
                                .frame(width: 44, height: 44)
                                .background(themeManager.primaryColor.opacity(0.1))
                                .cornerRadius(22)
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("To")
                                        .font(.custom("Inter", size: 14))
                                        .foregroundColor(themeManager.secondaryTextColor)
                                    
                                    TextField("Destination", text: $destination)
                                        .font(.custom("Inter", size: 16))
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        // Dates
                        VStack(spacing: 12) {
                            HStack(spacing: 12) {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Departure")
                                        .font(.custom("Inter", size: 14))
                                        .foregroundColor(themeManager.secondaryTextColor)
                                    
                                    DatePicker("", selection: $departureDate, displayedComponents: .date)
                                        .datePickerStyle(CompactDatePickerStyle())
                                        .labelsHidden()
                                }
                                
                                if isReturnTrip {
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("Return")
                                            .font(.custom("Inter", size: 14))
                                            .foregroundColor(themeManager.secondaryTextColor)
                                        
                                        DatePicker("", selection: $returnDate, displayedComponents: .date)
                                            .datePickerStyle(CompactDatePickerStyle())
                                            .labelsHidden()
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        // Passengers
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Passengers")
                                .font(.custom("Inter", size: 14))
                                .foregroundColor(themeManager.secondaryTextColor)
                                .padding(.horizontal, 20)
                            
                            HStack {
                                Button(action: { if passengers > 1 { passengers -= 1 } }) {
                                    Image(systemName: "minus.circle.fill")
                                        .foregroundColor(themeManager.primaryColor)
                                        .font(.system(size: 24))
                                }
                                
                                Text("\(passengers)")
                                    .font(.custom("Inter", size: 18))
                                    .fontWeight(.semibold)
                                    .foregroundColor(themeManager.primaryColor)
                                    .frame(minWidth: 40)
                                
                                Button(action: { if passengers < 9 { passengers += 1 } }) {
                                    Image(systemName: "plus.circle.fill")
                                        .foregroundColor(themeManager.primaryColor)
                                        .font(.system(size: 24))
                                }
                                
                                Spacer()
                            }
                            .padding(.horizontal, 20)
                        }
                        
                        // Search Button
                        Button(action: searchFlights) {
                            HStack {
                                if isSearching {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        .scaleEffect(0.8)
                                } else {
                                    Image(systemName: "magnifyingglass")
                                        .font(.system(size: 18))
                                }
                                
                                Text(isSearching ? "Searching..." : "Search Flights")
                                    .font(.custom("Inter", size: 18))
                                    .fontWeight(.semibold)
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(themeManager.primaryColor)
                            .cornerRadius(15)
                        }
                        .padding(.horizontal, 20)
                        .disabled(isSearching)
                    }
                    .padding(.vertical, 20)
                    .background(themeManager.oledCardBackgroundColor)
                    .cornerRadius(20)
                    .shadow(color: themeManager.shadowColor, radius: 8, x: 0, y: 4)
                    .padding(.horizontal, 20)
                    
                    // Search Results
                    if !searchResults.isEmpty {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Available Flights")
                                .font(.custom("Inter", size: 20))
                                .fontWeight(.semibold)
                                .foregroundColor(themeManager.textColor)
                                .padding(.horizontal, 20)
                            
                            LazyVStack(spacing: 12) {
                                ForEach(searchResults) { flight in
                                    FlightCard(flight: flight)
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                }
            }
            .background(themeManager.oledBackgroundColor)
            .navigationTitle("Flights")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    private func searchFlights() {
        guard !origin.isEmpty && !destination.isEmpty else { return }
        
        isSearching = true
        
        // Simulate API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            searchResults = generateSampleFlights(from: origin, to: destination)
            isSearching = false
        }
    }
    
    private func generateSampleFlights(from: String, to: String) -> [Flight] {
        let airlines = ["American Airlines", "Delta", "United", "Southwest", "JetBlue"]
        let times = ["06:30", "09:15", "12:45", "15:20", "18:00", "21:30"]
        let durations = ["2h 15m", "3h 45m", "1h 55m", "4h 20m", "2h 30m"]
        
        return (0..<5).map { index in
            Flight(
                id: index + 1,
                airline: airlines.randomElement() ?? "American Airlines",
                flightNumber: "\(Int.random(in: 100...999))",
                departureTime: times.randomElement() ?? "09:15",
                arrivalTime: times.randomElement() ?? "12:45",
                duration: durations.randomElement() ?? "2h 15m",
                price: Int.random(in: 200...800),
                departureAirport: from,
                arrivalAirport: to
            )
        }.sorted { $0.price < $1.price }
    }
}

struct FlightCard: View {
    @EnvironmentObject var themeManager: ThemeManager
    let flight: Flight
    
    var body: some View {
        VStack(spacing: 16) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(flight.airline)
                        .font(.custom("Inter", size: 16))
                        .fontWeight(.semibold)
                        .foregroundColor(themeManager.textColor)
                    
                    Text(flight.flightNumber)
                        .font(.custom("Inter", size: 14))
                        .foregroundColor(themeManager.secondaryTextColor)
                }
                
                Spacer()
                
                Text("$\(flight.price)")
                    .font(.custom("Inter", size: 20))
                    .fontWeight(.bold)
                    .foregroundColor(themeManager.primaryColor)
            }
            
            // Flight Details
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(flight.departureTime)
                        .font(.custom("Inter", size: 18))
                        .fontWeight(.semibold)
                        .foregroundColor(themeManager.textColor)
                    
                    Text(flight.departureAirport)
                        .font(.custom("Inter", size: 14))
                        .foregroundColor(themeManager.secondaryTextColor)
                }
                
                Spacer()
                
                VStack(spacing: 4) {
                    Text(flight.duration)
                        .font(.custom("Inter", size: 12))
                        .foregroundColor(themeManager.secondaryTextColor)
                    
                    HStack(spacing: 4) {
                        Circle()
                            .fill(themeManager.primaryColor)
                            .frame(width: 6, height: 6)
                        
                        Rectangle()
                            .fill(themeManager.primaryColor)
                            .frame(height: 1)
                            .frame(maxWidth: .infinity)
                        
                        Image(systemName: "airplane")
                            .foregroundColor(themeManager.primaryColor)
                            .font(.system(size: 12))
                    }
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text(flight.arrivalTime)
                        .font(.custom("Inter", size: 18))
                        .fontWeight(.semibold)
                        .foregroundColor(themeManager.textColor)
                    
                    Text(flight.arrivalAirport)
                        .font(.custom("Inter", size: 14))
                        .foregroundColor(themeManager.secondaryTextColor)
                }
            }
            
            // Book Button
            Button(action: {}) {
                Text("Select Flight")
                    .font(.custom("Inter", size: 16))
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(themeManager.primaryColor)
                    .cornerRadius(22)
            }
        }
        .padding(20)
        .background(themeManager.oledCardBackgroundColor)
        .cornerRadius(16)
        .shadow(color: themeManager.shadowColor, radius: 6, x: 0, y: 3)
    }
}

struct Flight: Identifiable {
    let id: Int
    let airline: String
    let flightNumber: String
    let departureTime: String
    let arrivalTime: String
    let duration: String
    let price: Int
    let departureAirport: String
    let arrivalAirport: String
}

#Preview {
    FlightSearchView()
}