import SwiftUI

struct TravelRouteView_Optimized: View {
    @StateObject private var dataManager = SampleDataManager.shared
    @State private var showingAddLocation = false
    @State private var selectedStop: RouteStop?
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                FlatDesignSystem.background
                    .ignoresSafeArea()
                
                ScrollView {
                    LazyVStack(spacing: 16) {
                        // Route Header
                        RouteHeaderView(route: dataManager.featuredRoute)
                        
                        // Route Stops
                        ForEach(dataManager.featuredRoute.stops) { stop in
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
