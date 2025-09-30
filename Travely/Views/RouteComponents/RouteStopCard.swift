import SwiftUI

struct RouteStopCard: View {
    let stop: RouteStop
    @State private var showingEditMenu = false
    @State private var showingDeleteAlert = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Main Card Content
            HStack(spacing: 16) {
                // Transport Icon
                VStack {
                    ZStack {
                        Circle()
                            .fill(transportIconColor)
                            .frame(width: 40, height: 40)
                        
                        Image(systemName: transportIcon)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    
                    if !stop.isStart {
                        Rectangle()
                            .fill(Color(.systemGray4))
                            .frame(width: 2, height: 20)
                    }
                }
                
                // Stop Details
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(stop.destination)
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                        
                        Text(stop.countryEmoji)
                            .font(.title3)
                        
                        Spacer()
                        
                        if stop.nights > 0 {
                            Text("\(stop.nights) nights")
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(.orange)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.orange.opacity(0.1))
                                .cornerRadius(8)
                        }
                    }
                    
                    Text(stop.dates)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    if stop.hasFlight || stop.hasTrain {
                        HStack(spacing: 4) {
                            Image(systemName: stop.hasFlight ? "airplane" : "tram.fill")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            Text(stop.flightInfo)
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            Spacer()
                            
                            Text(stop.flightPrice)
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(.orange)
                        }
                    }
                }
                
                // Action Menu
                Menu {
                    Button(action: {
                        showingEditMenu = true
                    }) {
                        Label("Edit", systemImage: "pencil")
                    }
                    
                    Button(action: {
                        showingDeleteAlert = true
                    }) {
                        Label("Delete", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.secondary)
                        .frame(width: 24, height: 24)
                }
            }
            .padding(16)
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        }
        .sheet(isPresented: $showingEditMenu) {
            EditRouteStopView(stop: stop)
        }
        .alert("Delete Stop", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                // TODO: Implement delete functionality
            }
        } message: {
            Text("Are you sure you want to delete \(stop.destination)?")
        }
    }
    
    private var transportIcon: String {
        if stop.isStart {
            return "airplane.departure"
        } else if stop.hasFlight {
            return "airplane"
        } else if stop.hasTrain {
            return "tram.fill"
        } else {
            return "mappin.circle.fill"
        }
    }
    
    private var transportIconColor: Color {
        if stop.isStart {
            return .blue
        } else if stop.hasFlight {
            return .orange
        } else if stop.hasTrain {
            return .green
        } else {
            return .purple
        }
    }
}

struct EditRouteStopView: View {
    let stop: RouteStop
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedNights = 3
    @State private var selectedDate = Date()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Edit \(stop.destination)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.top)
                
                VStack(alignment: .leading, spacing: 16) {
                    // Nights Selection
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Nights to stay")
                            .font(.headline)
                        
                        HStack {
                            Button(action: {
                                if selectedNights > 1 {
                                    selectedNights -= 1
                                }
                            }) {
                                Image(systemName: "minus.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(selectedNights > 1 ? .orange : .gray)
                            }
                            .disabled(selectedNights <= 1)
                            
                            Spacer()
                            
                            Text("\(selectedNights) nights")
                                .font(.title3)
                                .fontWeight(.semibold)
                            
                            Spacer()
                            
                            Button(action: {
                                if selectedNights < 14 {
                                    selectedNights += 1
                                }
                            }) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(selectedNights < 14 ? .orange : .gray)
                            }
                            .disabled(selectedNights >= 14)
                        }
                    }
                    
                    // Date Selection
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Start Date")
                            .font(.headline)
                        
                        DatePicker("", selection: $selectedDate, displayedComponents: .date)
                            .datePickerStyle(CompactDatePickerStyle())
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                
                Spacer()
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Save") {
                    // TODO: Implement save functionality
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
}

#Preview {
    RouteStopCard(stop: RouteStop(
        id: 1,
        destination: "Sample City",
        country: "Sample Country",
        countryEmoji: "🏳️",
        duration: "3 Days",
        dates: "Jan 1-4, 2024",
        hasFlight: true,
        hasTrain: false,
        isStart: false,
        flightInfo: "Sample Flight",
        flightDuration: "2h 30m",
        flightPrice: "€200",
        nights: 3
    ))
}
