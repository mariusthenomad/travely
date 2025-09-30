import SwiftUI

struct TravelRouteView_Optimized: View {
    @State private var showingAddLocation = false
    @State private var selectedStop: RouteStop?
    
    // Sample data directly in view for now
    private let sampleRoute = TravelRoute(
        id: 1,
        title: "Asia Adventure",
        description: "Experience the best of Taiwan and Southeast Asia with this amazing 21-day journey through Taichung, Taipei, Bali, and Bangkok.",
        duration: "21 Days",
        totalPrice: 3488,
        imageURL: "https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=600&h=400&fit=crop&crop=center",
        stops: [
            RouteStop(
                id: 1,
                destination: "Munich",
                country: "Germany",
                countryEmoji: "🇩🇪",
                duration: "0 Days",
                dates: "Thu 07 Mar - Departure",
                hasFlight: true,
                hasTrain: false,
                isStart: true,
                flightInfo: "Munich → Taipei",
                flightDuration: "11h 30m",
                flightPrice: "€589",
                nights: 0
            ),
            RouteStop(
                id: 3,
                destination: "Taichung",
                country: "Taiwan",
                countryEmoji: "🇹🇼",
                duration: "4 Days",
                dates: "Thu 07 Mar - Mon 11 Mar",
                hasFlight: false,
                hasTrain: true,
                isStart: false,
                flightInfo: "Taipei → Taichung",
                flightDuration: "1h 15m",
                flightPrice: "€25",
                nights: 4
            ),
            RouteStop(
                id: 4,
                destination: "Taipei",
                country: "Taiwan",
                countryEmoji: "🇹🇼",
                duration: "2 Days",
                dates: "Mon 11 Mar - Wed 13 Mar",
                hasFlight: true,
                hasTrain: false,
                isStart: false,
                flightInfo: "Taichung → Taipei",
                flightDuration: "1h 15m",
                flightPrice: "€25",
                nights: 2
            ),
            RouteStop(
                id: 7,
                destination: "Bangkok",
                country: "Thailand",
                countryEmoji: "🇹🇭",
                duration: "5 Days",
                dates: "Sun 24 Mar - Fri 29 Mar",
                hasFlight: true,
                hasTrain: false,
                isStart: false,
                flightInfo: "Kuala Lumpur → Bangkok",
                flightDuration: "1h 45m",
                flightPrice: "€298",
                nights: 5
            )
        ],
        priceBreakdown: [
            PriceItem(id: 1, item: "Taichung Accommodation (4 nights)", price: 360),
            PriceItem(id: 2, item: "Taipei Accommodation (2 nights)", price: 180),
            PriceItem(id: 4, item: "Bangkok Accommodation (5 nights)", price: 400),
            PriceItem(id: 5, item: "Munich → Taichung Flight", price: 589),
            PriceItem(id: 6, item: "Taichung → Taipei Train", price: 89),
            PriceItem(id: 8, item: "Bali → Bangkok Flight", price: 298)
        ]
    )
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                FlatDesignSystem.background
                    .ignoresSafeArea()
                
                ScrollView {
                    LazyVStack(spacing: 16) {
                        // Route Header
                        RouteHeaderView(route: sampleRoute)
                        
                        // Route Stops
                        ForEach(sampleRoute.stops) { stop in
                            RouteStopCard(stop: stop)
                                .onTapGesture {
                                    selectedStop = stop
                                }
                        }
                        
                        // Add Location Button
                        Button(action: {
                            showingAddLocation = true
                        }) {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(.orange)
                                
                                Text("Add Location")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.orange)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color.orange.opacity(0.1))
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.orange.opacity(0.3), lineWidth: 1)
                            )
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 8)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    .padding(.bottom, 100)
                }
            }
            .navigationTitle("My Route")
            .navigationBarTitleDisplayMode(.large)
        }
        .sheet(isPresented: $showingAddLocation) {
            AddLocationView(
                onSave: { location, date, nights in
                    // TODO: Implement save functionality
                    showingAddLocation = false
                },
                onCancel: {
                    showingAddLocation = false
                }
            )
        }
        .sheet(item: $selectedStop) { stop in
            RouteStopDetailView(stop: stop)
        }
    }
}

struct RouteStopDetailView: View {
    let stop: RouteStop
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text(stop.destination)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                            
                            Text(stop.countryEmoji)
                                .font(.largeTitle)
                            
                            Spacer()
                        }
                        
                        Text(stop.country)
                            .font(.title3)
                            .foregroundColor(.secondary)
                    }
                    
                    // Dates and Duration
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Dates")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text(stop.dates)
                                    .font(.headline)
                            }
                            
                            Spacer()
                            
                            if stop.nights > 0 {
                                VStack(alignment: .trailing) {
                                    Text("Duration")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    Text("\(stop.nights) nights")
                                        .font(.headline)
                                        .foregroundColor(.orange)
                                }
                            }
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    
                    // Transport Information
                    if stop.hasFlight || stop.hasTrain {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Transport")
                                .font(.headline)
                            
                            HStack {
                                Image(systemName: stop.hasFlight ? "airplane" : "tram.fill")
                                    .font(.title2)
                                    .foregroundColor(.orange)
                                
                                VStack(alignment: .leading) {
                                    Text(stop.flightInfo)
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                    
                                    Text(stop.flightDuration)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                                
                                Text(stop.flightPrice)
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .foregroundColor(.orange)
                            }
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    }
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Stop Details")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                trailing: Button("Done") {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
}

#Preview {
    TravelRouteView_Optimized()
}
