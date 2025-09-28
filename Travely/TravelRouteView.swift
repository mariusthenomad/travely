import SwiftUI

// Data Models
struct TravelRoute: Identifiable {
    let id: Int
    let title: String
    let description: String
    let duration: String
    let totalPrice: Int
    let imageURL: String
    let stops: [RouteStop]
    let priceBreakdown: [PriceItem]
}

struct RouteStop: Identifiable {
    let id: Int
    var destination: String
    let country: String
    let countryEmoji: String
    var duration: String
    var dates: String
    let hasFlight: Bool
    let hasTrain: Bool
    let isStart: Bool
    let flightInfo: String
    let flightDuration: String
    let flightPrice: String
    var nights: Int
}

struct PriceItem: Identifiable {
    let id: Int
    let item: String
    let price: Int
}

struct Ticket: Identifiable {
    let id: Int
    let stopId: Int
    let ticketNumber: String
    let bookingReference: String
    let seatNumber: String
    let gate: String
    let terminal: String
    let departureTime: String
    let arrivalTime: String
    let notes: String
    let ticketImage: String? // For future photo upload functionality
}

struct CustomTextFieldStyle: TextFieldStyle {
    let themeManager: ThemeManager
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(16)
            .frame(height: 50) // Fixed height like FlightBookingView
            .background(Color.white) // White background
            .cornerRadius(12)
            .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2)) // Dark gray text
            .font(.custom("Inter", size: 16))
            .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1) // Light shadow
    }
}

struct TicketSheetView: View {
    @EnvironmentObject var themeManager: ThemeManager
    let stop: RouteStop
    @Binding var tickets: [Ticket]
    let onDismiss: () -> Void
    
    @State private var ticketNumber = ""
    @State private var bookingReference = ""
    @State private var seatNumber = ""
    @State private var gate = ""
    @State private var terminal = ""
    @State private var departureTime = ""
    @State private var arrivalTime = ""
    @State private var notes = ""
    
    private var existingTicket: Ticket? {
        tickets.first { $0.stopId == stop.id }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.white,
                        Color(red: 1.0, green: 0.95, blue: 0.9)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Header
                        VStack(spacing: 8) {
                            Text("Ticket Details")
                                .font(.custom("Inter", size: 28))
                                .font(.custom("Inter", size: 14).weight(.bold))
                                .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                            
                            Text("\(stop.flightInfo)")
                                .font(.custom("Inter", size: 16))
                                .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.5))
                        }
                        .padding(.top, 20)
                        
                        // Form
                        VStack(spacing: 20) {
                            // Ticket Number
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Ticket Number")
                                    .font(.custom("Inter", size: 14))
                                    .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.5))
                                
                                TextField("e.g., 1234567890", text: $ticketNumber)
                                    .textFieldStyle(CustomTextFieldStyle(themeManager: themeManager))
                            }
                            
                            // Booking Reference
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Booking Reference")
                                    .font(.custom("Inter", size: 14))
                                    .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.5))
                                
                                TextField("e.g., ABC123", text: $bookingReference)
                                    .textFieldStyle(CustomTextFieldStyle(themeManager: themeManager))
                            }
                            
                            // Seat Number
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Seat Number")
                                    .font(.custom("Inter", size: 14))
                                    .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.5))
                                
                                TextField("e.g., 12A", text: $seatNumber)
                                    .textFieldStyle(CustomTextFieldStyle(themeManager: themeManager))
                            }
                            
                            // Gate and Terminal
                            HStack(spacing: 16) {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Gate")
                                        .font(.custom("Inter", size: 14))
                                        .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.5))
                                    
                                    TextField("e.g., A12", text: $gate)
                                        .textFieldStyle(CustomTextFieldStyle(themeManager: themeManager))
                                }
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Terminal")
                                        .font(.custom("Inter", size: 14))
                                        .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.5))
                                    
                                    TextField("e.g., T1", text: $terminal)
                                        .textFieldStyle(CustomTextFieldStyle(themeManager: themeManager))
                                }
                            }
                            
                            // Departure and Arrival Times
                            HStack(spacing: 16) {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Departure Time")
                                        .font(.custom("Inter", size: 14))
                                        .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.5))
                                    
                                    TextField("e.g., 14:30", text: $departureTime)
                                        .textFieldStyle(CustomTextFieldStyle(themeManager: themeManager))
                                }
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Arrival Time")
                                        .font(.custom("Inter", size: 14))
                                        .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.5))
                                    
                                    TextField("e.g., 18:45", text: $arrivalTime)
                                        .textFieldStyle(CustomTextFieldStyle(themeManager: themeManager))
                                }
                            }
                            
                            // Notes
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Notes")
                                    .font(.custom("Inter", size: 14))
                                    .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.5))
                                
                                TextField("Additional notes...", text: $notes)
                                    .lineLimit(3)
                                    .textFieldStyle(CustomTextFieldStyle(themeManager: themeManager))
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        // Action Buttons
                        VStack(spacing: 16) {
                            Button(action: saveTicket) {
                                HStack {
                                    Image(systemName: existingTicket != nil ? "checkmark" : "plus")
                                        .font(.system(size: 18))
                                    
                                    Text(existingTicket != nil ? "Update Ticket" : "Save Ticket")
                                        .font(.custom("Inter", size: 18))
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(Color(red: 1.0, green: 0.4, blue: 0.2))
                                .cornerRadius(15)
                            }
                            
                            if existingTicket != nil {
                                Button(action: deleteTicket) {
                                    Text("Delete Ticket")
                                        .font(.custom("Inter", size: 16))
                                        .foregroundColor(.red)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 50)
                                        .background(Color.white)
                                        .cornerRadius(15)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 15)
                                                .stroke(Color.red, lineWidth: 1)
                                        )
                                }
                            }
                            
                            Button(action: onDismiss) {
                                Text("Cancel")
                                    .font(.custom("Inter", size: 16))
                                    .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 50)
                                    .background(Color.white)
                                    .cornerRadius(15)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 15)
                                            .stroke(Color(red: 0.2, green: 0.2, blue: 0.2), lineWidth: 1)
                                    )
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 100)
                    }
                }
            }
            .navigationTitle("Ticket")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("Done") {
                onDismiss()
            })
        }
        .onAppear {
            loadExistingTicket()
        }
    }
    
    private func loadExistingTicket() {
        if let ticket = existingTicket {
            ticketNumber = ticket.ticketNumber
            bookingReference = ticket.bookingReference
            seatNumber = ticket.seatNumber
            gate = ticket.gate
            terminal = ticket.terminal
            departureTime = ticket.departureTime
            arrivalTime = ticket.arrivalTime
            notes = ticket.notes
        }
    }
    
    private func saveTicket() {
        let newTicket = Ticket(
            id: existingTicket?.id ?? Int.random(in: 1000...9999),
            stopId: stop.id,
            ticketNumber: ticketNumber,
            bookingReference: bookingReference,
            seatNumber: seatNumber,
            gate: gate,
            terminal: terminal,
            departureTime: departureTime,
            arrivalTime: arrivalTime,
            notes: notes,
            ticketImage: nil
        )
        
        if let existingIndex = tickets.firstIndex(where: { $0.stopId == stop.id }) {
            tickets[existingIndex] = newTicket
        } else {
            tickets.append(newTicket)
        }
        
        onDismiss()
    }
    
    private func deleteTicket() {
        tickets.removeAll { $0.stopId == stop.id }
        onDismiss()
    }
}

struct TravelRouteView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @State private var selectedRoute: TravelRoute? = nil
    @State private var showingStays = false
    @State private var showingAddLocation = false
    @State private var showingTicketSheet = false
    @State private var selectedStopForTicket: RouteStop? = nil
    @State private var tickets: [Ticket] = []
    @State private var selectedTab = 0 // 0 = Route, 1 = Bookings
    @State private var nights = [0, 0, 5, 2, 5, 5, 4, 0] // Nights for each stop
    @State private var currentRoute: TravelRoute = featuredRoute // Make route mutable
    @State private var showingDeleteAlert = false
    @State private var stopToDelete: (index: Int, stop: RouteStop)? = nil
    @State private var showingEditSheet = false
    @State private var stopToEdit: (index: Int, stop: RouteStop)? = nil
    @State private var showingNightsEditor = false
    
    // Computed property for total nights
    private var totalNights: Int {
        nights.reduce(0, +)
    }
    
    // Computed property for progress (0.0 to 1.0)
    private var progressValue: Double {
        let maxNights = 21 // Original planned nights
        return min(Double(totalNights) / Double(maxNights), 1.0)
    }
    
    // Computed property for progress color
    private var progressColor: Color {
        return totalNights > 21 ? Color.red : Color(red: 1.0, green: 0.4, blue: 0.2) // Orange
    }
    
    // Function to update dates when nights change
    private func updateDates() {
        let startDate = Calendar.current.date(from: DateComponents(year: 2024, month: 3, day: 7)) ?? Date()
        var currentDate = startDate
        
        for i in 0..<currentRoute.stops.count {
            let currentNights = nights[i]
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE dd MMM"
            
            // Calculate dates based on current nights
            let startDateString = formatter.string(from: currentDate)
            let endDateString = currentNights > 0 ? formatter.string(from: Calendar.current.date(byAdding: .day, value: currentNights, to: currentDate) ?? currentDate) : "Transit"
            let newDates = currentNights > 0 ? "\(startDateString) - \(endDateString)" : "\(startDateString) - Transit"
            
            // Update the route
            var updatedStops = currentRoute.stops
            updatedStops[i].dates = newDates
            updatedStops[i].duration = currentNights > 0 ? "\(currentNights) Days" : "0 Days"
            updatedStops[i].nights = currentNights
            
            currentRoute = TravelRoute(
                id: currentRoute.id,
                title: currentRoute.title,
                description: currentRoute.description,
                duration: currentRoute.duration,
                totalPrice: currentRoute.totalPrice,
                imageURL: currentRoute.imageURL,
                stops: updatedStops,
                priceBreakdown: currentRoute.priceBreakdown
            )
            
            // Move to next date
            currentDate = Calendar.current.date(byAdding: .day, value: currentNights, to: currentDate) ?? currentDate
        }
    }
    
    // Function to delete a stop
    private func deleteStop(at index: Int) {
        guard index < currentRoute.stops.count && index < nights.count else { return }
        
        // Don't allow deleting the first or last stop (start/end points)
        if index == 0 || index == currentRoute.stops.count - 1 {
            return
        }
        
        // Remove the stop and corresponding nights
        var updatedStops = currentRoute.stops
        updatedStops.remove(at: index)
        
        var updatedNights = nights
        updatedNights.remove(at: index)
        
        // Update the route
        currentRoute = TravelRoute(
            id: currentRoute.id,
            title: currentRoute.title,
            description: currentRoute.description,
            duration: currentRoute.duration,
            totalPrice: currentRoute.totalPrice,
            imageURL: currentRoute.imageURL,
            stops: updatedStops,
            priceBreakdown: currentRoute.priceBreakdown
        )
        
        // Update nights array
        nights = updatedNights
        
        // Remove any tickets associated with this stop
        let stopId = currentRoute.stops[index].id
        tickets.removeAll { $0.stopId == stopId }
        
        // Update dates after deletion
        updateDates()
    }
    
    // Function to update a stop
    private func updateStop(at index: Int, with newDestination: String) {
        guard index > 0 && index < currentRoute.stops.count - 1 else { return }
        
        // Update the stop destination
        var updatedStops = currentRoute.stops
        updatedStops[index].destination = newDestination
        
        // Update the route
        currentRoute = TravelRoute(
            id: currentRoute.id,
            title: currentRoute.title,
            description: currentRoute.description,
            duration: currentRoute.duration,
            totalPrice: currentRoute.totalPrice,
            imageURL: currentRoute.imageURL,
            stops: updatedStops,
            priceBreakdown: currentRoute.priceBreakdown
        )
        
        // Update dates
        updateDates()
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient like flights
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.white,
                        Color(red: 1.0, green: 0.95, blue: 0.9)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Custom Header with Progress and Tabs
                    HStack {
                        // Progress Indicator
                        Button(action: {
                            showingNightsEditor = true
                        }) {
                            HStack(spacing: 8) {
                                ZStack {
                                    Circle()
                                        .stroke(Color(red: 0.9, green: 0.9, blue: 0.9), lineWidth: 4)
                                        .frame(width: 40, height: 40)
                                    
                                    Circle()
                                        .trim(from: 0, to: progressValue) // Dynamic progress
                                        .stroke(progressColor, lineWidth: 4)
                                        .frame(width: 40, height: 40)
                                        .rotationEffect(.degrees(-90))
                                    
                                    Text("\(totalNights)")
                                        .font(.custom("Inter", size: 14))
                                        .font(.custom("Inter", size: 14).weight(.bold))
                                        .foregroundColor(progressColor)
                                }
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("\(totalNights)/21")
                                        .font(.custom("Inter", size: 16))
                                        .font(.custom("Inter", size: 14).weight(.bold))
                                        .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                                    
                                    Text("Nights planned")
                                        .font(.custom("Inter", size: 12))
                                        .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.5))
                                }
                                
                                Spacer()
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        Spacer()
                        
                        // Tab Segments
                        HStack(spacing: 0) {
                            Button(action: { selectedTab = 0 }) {
                                Text("Route")
                                    .font(.custom("Inter", size: 16))
                                    .foregroundColor(selectedTab == 0 ? .white : Color(red: 0.5, green: 0.5, blue: 0.5))
                                    .frame(width: 80, height: 32)
                                    .background(selectedTab == 0 ? Color(red: 1.0, green: 0.4, blue: 0.2) : Color.clear)
                                    .cornerRadius(16)
                            }
                            
                            Button(action: { selectedTab = 1 }) {
                                Text("Bookings")
                                    .font(.custom("Inter", size: 16))
                                    .foregroundColor(selectedTab == 1 ? .white : Color(red: 0.5, green: 0.5, blue: 0.5))
                                    .frame(width: 80, height: 32)
                                    .background(selectedTab == 1 ? Color(red: 1.0, green: 0.4, blue: 0.2) : Color.clear)
                                    .cornerRadius(16)
                            }
                        }
                        .padding(4)
                        .background(Color(red: 0.95, green: 0.95, blue: 0.95))
                        .cornerRadius(20)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                    .padding(.bottom, 20)
                    
                    // Main content area
                    if selectedTab == 0 {
                        ScrollView {
                            VStack(spacing: 0) {
                                // Route stops
                                ForEach(Array(currentRoute.stops.enumerated()), id: \.offset) { index, stop in
                                    RouteStopRowNew(
                                        stop: stop,
                                        stopNumber: index + 1,
                                        nights: $nights[index],
                                        tickets: tickets,
                                        onTicketTap: { selectedStop in
                                            selectedStopForTicket = selectedStop
                                            showingTicketSheet = true
                                        },
                                        onNightsChanged: {
                                            updateDates()
                                        },
                                        onDelete: { stopToDelete in
                                            self.stopToDelete = (index: index, stop: stopToDelete)
                                            showingDeleteAlert = true
                                        },
                                        onEdit: { stopToEdit in
                                            if let index = currentRoute.stops.firstIndex(where: { $0.id == stopToEdit.id }) {
                                                self.stopToEdit = (index: index, stop: stopToEdit)
                                                showingEditSheet = true
                                            }
                                        },
                                        canDelete: index != 0 && index != currentRoute.stops.count - 1,
                                        canEdit: true // Allow editing for all stops
                                    )
                                    
                                    // Spacing between cards
                                    if index < currentRoute.stops.count - 1 {
                                        Spacer()
                                            .frame(height: 8)
                                    }
                                }
                                
                                Spacer()
                                    .frame(height: 20)
                            }
                            .padding(.horizontal, 20)
                        }
                        .background(Color.clear)
                    } else {
                        // Bookings view placeholder
                        VStack {
                            Text("Bookings")
                                .font(.custom("Inter", size: 24))
                                .font(.custom("Inter", size: 14).weight(.bold))
                                .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                            
                            Text("Your bookings will appear here")
                                .font(.custom("Inter", size: 16))
                                .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.5))
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .sheet(item: $selectedRoute) { route in
            RouteDetailView(route: route)
        }
        .sheet(isPresented: $showingStays) {
            StaysView(stays: sampleStays)
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
        .sheet(isPresented: $showingTicketSheet) {
            if let selectedStop = selectedStopForTicket {
                TicketSheetView(
                    stop: selectedStop,
                    tickets: $tickets,
                    onDismiss: {
                        showingTicketSheet = false
                        selectedStopForTicket = nil
                    }
                )
            }
        }
        .alert("Delete Location", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive) {
                if let stopToDelete = stopToDelete {
                    deleteStop(at: stopToDelete.index)
                }
                self.stopToDelete = nil
            }
            Button("Cancel", role: .cancel) {
                self.stopToDelete = nil
            }
        } message: {
            if let stopToDelete = stopToDelete {
                Text("Are you sure you want to delete \(stopToDelete.stop.destination)? This action cannot be undone.")
            }
        }
        .sheet(isPresented: $showingEditSheet) {
            if let stopToEdit = stopToEdit {
                EditStopView(
                    stop: stopToEdit.stop,
                    onSave: { newDestination in
                        updateStop(at: stopToEdit.index, with: newDestination)
                        self.stopToEdit = nil
                        showingEditSheet = false
                    },
                    onCancel: {
                        self.stopToEdit = nil
                        showingEditSheet = false
                    }
                )
            }
        }
        .sheet(isPresented: $showingNightsEditor) {
            NightsEditorView(
                nights: $nights,
                onSave: {
                    updateDates()
                    showingNightsEditor = false
                },
                onCancel: {
                    showingNightsEditor = false
                }
            )
        }
    }
}

struct EditStopView: View {
    @EnvironmentObject var themeManager: ThemeManager
    let stop: RouteStop
    let onSave: (String) -> Void
    let onCancel: () -> Void
    
    @State private var searchText = ""
    @State private var selectedCategory = "All"
    @State private var showingSearch = false
    
    let categories = ["All", "Europe", "Asia", "Americas", "Africa", "Oceania"]
    
    // Sample data for compatibility
    let popularCountries: [Country] = [
        Country(id: 1, name: "Germany", flag: "🇩🇪", imageURL: "https://images.unsplash.com/photo-1467269204594-9661b134dd2b?w=400&h=300&fit=crop&crop=center", cityCount: 5),
        Country(id: 2, name: "France", flag: "🇫🇷", imageURL: "https://images.unsplash.com/photo-1502602898536-47ad22581b52?w=400&h=300&fit=crop&crop=center", cityCount: 8),
        Country(id: 3, name: "Italy", flag: "🇮🇹", imageURL: "https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=400&h=300&fit=crop&crop=center", cityCount: 6),
        Country(id: 4, name: "Spain", flag: "🇪🇸", imageURL: "https://images.unsplash.com/photo-1496442226666-8d4d0e62e6e9?w=400&h=300&fit=crop&crop=center", cityCount: 7),
        Country(id: 5, name: "Japan", flag: "🇯🇵", imageURL: "https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=400&h=300&fit=crop&crop=center", cityCount: 4),
        Country(id: 6, name: "Thailand", flag: "🇹🇭", imageURL: "https://images.unsplash.com/photo-1539037116277-4db20889f2d4?w=400&h=300&fit=crop&crop=center", cityCount: 3),
        Country(id: 7, name: "USA", flag: "🇺🇸", imageURL: "https://images.unsplash.com/photo-1563492065-1a120d5d8b96?w=400&h=300&fit=crop&crop=center", cityCount: 10),
        Country(id: 8, name: "Australia", flag: "🇦🇺", imageURL: "https://images.unsplash.com/photo-1502602898536-47ad22581b52?w=400&h=300&fit=crop&crop=center", cityCount: 5)
    ]
    
    let popularCities: [City] = [
        City(id: 1, name: "Berlin", country: "Germany", imageURL: "https://images.unsplash.com/photo-1467269204594-9661b134dd2b?w=400&h=300&fit=crop&crop=center"),
        City(id: 2, name: "Munich", country: "Germany", imageURL: "https://images.unsplash.com/photo-1502602898536-47ad22581b52?w=400&h=300&fit=crop&crop=center"),
        City(id: 3, name: "Paris", country: "France", imageURL: "https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=400&h=300&fit=crop&crop=center"),
        City(id: 4, name: "Lyon", country: "France", imageURL: "https://images.unsplash.com/photo-1496442226666-8d4d0e62e6e9?w=400&h=300&fit=crop&crop=center"),
        City(id: 5, name: "Rome", country: "Italy", imageURL: "https://images.unsplash.com/photo-1552832230-c0197dd311b5?w=400&h=300&fit=crop&crop=center"),
        City(id: 6, name: "Milan", country: "Italy", imageURL: "https://images.unsplash.com/photo-1539037116277-4db20889f2d4?w=400&h=300&fit=crop&crop=center"),
        City(id: 7, name: "Madrid", country: "Spain", imageURL: "https://images.unsplash.com/photo-1563492065-1a120d5d8b96?w=400&h=300&fit=crop&crop=center"),
        City(id: 8, name: "Barcelona", country: "Spain", imageURL: "https://images.unsplash.com/photo-1502602898536-47ad22581b52?w=400&h=300&fit=crop&crop=center"),
        City(id: 9, name: "Tokyo", country: "Japan", imageURL: "https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=400&h=300&fit=crop&crop=center"),
        City(id: 10, name: "Osaka", country: "Japan", imageURL: "https://images.unsplash.com/photo-1496442226666-8d4d0e62e6e9?w=400&h=300&fit=crop&crop=center"),
        City(id: 11, name: "Bangkok", country: "Thailand", imageURL: "https://images.unsplash.com/photo-1552832230-c0197dd311b5?w=400&h=300&fit=crop&crop=center"),
        City(id: 12, name: "Chiang Mai", country: "Thailand", imageURL: "https://images.unsplash.com/photo-1539037116277-4db20889f2d4?w=400&h=300&fit=crop&crop=center"),
        City(id: 13, name: "New York", country: "USA", imageURL: "https://images.unsplash.com/photo-1563492065-1a120d5d8b96?w=400&h=300&fit=crop&crop=center"),
        City(id: 14, name: "Los Angeles", country: "USA", imageURL: "https://images.unsplash.com/photo-1502602898536-47ad22581b52?w=400&h=300&fit=crop&crop=center"),
        City(id: 15, name: "Sydney", country: "Australia", imageURL: "https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=400&h=300&fit=crop&crop=center"),
        City(id: 16, name: "Melbourne", country: "Australia", imageURL: "https://images.unsplash.com/photo-1496442226666-8d4d0e62e6e9?w=400&h=300&fit=crop&crop=center")
    ]
    
    var filteredCountries: [Country] {
        let filtered = popularCountries.filter { country in
            if selectedCategory == "All" {
                return true
            } else {
                let region = getRegionForCountry(country.name)
                return region == selectedCategory
            }
        }
        
        if searchText.isEmpty {
            return filtered
        } else {
            return filtered.filter { country in
                country.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var filteredCities: [City] {
        let filtered = popularCities.filter { city in
            if selectedCategory == "All" {
                return true
            } else {
                let region = getRegionForCountry(city.country)
                return region == selectedCategory
            }
        }
        
        if searchText.isEmpty {
            return filtered
        } else {
            return filtered.filter { city in
                city.name.localizedCaseInsensitiveContains(searchText) ||
                city.country.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    func getRegionForCountry(_ country: String) -> String {
        switch country {
        case "France", "Italy", "Spain", "UK", "Germany", "Austria", "Switzerland", "Netherlands", "Belgium", "Portugal", "Greece", "Poland", "Czechia", "Hungary", "Sweden", "Norway", "Denmark", "Finland", "Ireland", "Croatia", "Bulgaria", "Romania", "Slovakia", "Slovenia", "Estonia", "Latvia", "Lithuania":
            return "Europe"
        case "Japan", "Thailand", "China", "India", "South Korea", "Singapore", "Malaysia", "Indonesia", "Philippines", "Vietnam", "Cambodia", "Laos", "Myanmar", "Sri Lanka", "Nepal", "Bhutan", "Bangladesh", "Pakistan", "Afghanistan", "Iran", "Iraq", "Turkey", "Saudi Arabia", "UAE", "Israel", "Jordan", "Lebanon", "Syria", "Kuwait", "Qatar", "Bahrain", "Oman", "Yemen":
            return "Asia"
        case "USA", "Canada", "Mexico", "Brazil", "Argentina", "Chile", "Colombia", "Peru", "Venezuela", "Ecuador", "Bolivia", "Paraguay", "Uruguay", "Guyana", "Suriname", "French Guiana", "Costa Rica", "Panama", "Guatemala", "Honduras", "Nicaragua", "El Salvador", "Belize", "Cuba", "Jamaica", "Haiti", "Dominican Republic", "Puerto Rico", "Trinidad and Tobago", "Barbados", "Antigua and Barbuda", "Saint Lucia", "Grenada", "Saint Vincent and the Grenadines", "Dominica", "Saint Kitts and Nevis":
            return "Americas"
        case "South Africa", "Egypt", "Nigeria", "Kenya", "Morocco", "Algeria", "Tunisia", "Libya", "Sudan", "Ethiopia", "Ghana", "Tanzania", "Uganda", "Cameroon", "Ivory Coast", "Madagascar", "Mozambique", "Angola", "Burkina Faso", "Mali", "Malawi", "Zambia", "Somalia", "Senegal", "Zimbabwe", "Guinea", "Rwanda", "Benin", "Tunisia", "Burundi", "South Sudan", "Togo", "Sierra Leone", "Libya", "Liberia", "Central African Republic", "Mauritania", "Eritrea", "Gambia", "Botswana", "Namibia", "Gabon", "Lesotho", "Guinea-Bissau", "Equatorial Guinea", "Mauritius", "Eswatini", "Djibouti", "Fiji", "Comoros", "Cabo Verde", "São Tomé and Príncipe", "Seychelles", "Marshall Islands", "Kiribati", "Tonga", "Micronesia", "Palau", "Samoa", "Vanuatu", "Solomon Islands", "Tuvalu", "Nauru":
            return "Africa"
        case "Australia", "New Zealand", "Papua New Guinea", "Fiji", "Samoa", "Tonga", "Vanuatu", "Solomon Islands", "Kiribati", "Tuvalu", "Nauru", "Palau", "Marshall Islands", "Micronesia":
            return "Oceania"
        default:
            return "All"
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.white,
                        Color(red: 1.0, green: 0.95, blue: 0.9)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header
                    HStack {
                        Text("Edit Location")
                            .font(.largeTitle)
                                        .font(.custom("Inter", size: 16).weight(.bold))
                            .foregroundColor(.primary)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                    .padding(.bottom, 16)
                    
                    // Current Location Info
                    VStack(spacing: 12) {
                        HStack {
                            Text("Current Location:")
                                .font(.custom("Inter", size: 16))
                                .foregroundColor(themeManager.secondaryTextColor)
                            
                            Spacer()
                        }
                        
                        HStack {
                            Image(systemName: "location.fill")
                                .foregroundColor(Color(red: 1.0, green: 0.4, blue: 0.2))
                                .font(.system(size: 16))
                            
                            Text(stop.destination)
                                .font(.custom("Inter", size: 18))
                                .foregroundColor(themeManager.textColor)
                            
                            Spacer()
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(12)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                    
                    // Search Bar
                    VStack(spacing: 16) {
                        HStack(spacing: 12) {
                            HStack(spacing: 8) {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(themeManager.secondaryTextColor)
                                    .font(.system(size: 16))
                                
                                TextField("Search destinations...", text: $searchText)
                                    .font(.custom("Inter", size: 16))
                                    .foregroundColor(themeManager.textColor)
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(15)
                            
                            Button(action: { showingSearch.toggle() }) {
                                Image(systemName: showingSearch ? "xmark" : "slider.horizontal.3")
                                    .foregroundColor(Color(red: 1.0, green: 0.4, blue: 0.2))
                                    .font(.system(size: 18))
                            }
                            .frame(width: 44, height: 44)
                            .background(Color(red: 1.0, green: 0.4, blue: 0.2).opacity(0.1))
                            .cornerRadius(22)
                        }
                        .padding(.horizontal, 20)
                        
                        // Category Filter
                        if showingSearch {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 8) {
                                    ForEach(categories, id: \.self) { category in
                                        Button(action: { selectedCategory = category }) {
                                            Text(category)
                                                .font(.custom("Inter", size: 14))
                                                .foregroundColor(selectedCategory == category ? .white : Color(red: 1.0, green: 0.4, blue: 0.2))
                                                .padding(.horizontal, 16)
                                                .padding(.vertical, 10)
                                                .background(selectedCategory == category ? Color(red: 1.0, green: 0.4, blue: 0.2) : Color.clear)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 15)
                                                        .stroke(Color(red: 1.0, green: 0.4, blue: 0.2), lineWidth: 1)
                                                )
                                                .cornerRadius(15)
                                        }
                                    }
                                }
                                .padding(.horizontal, 20)
                            }
                        }
                    }
                    .padding(.bottom, 20)
                    .background(themeManager.oledBackgroundColor)
                    
                    // Main Content
                    ScrollView {
                        VStack(spacing: 24) {
                            // Countries Section
                            VStack(alignment: .leading, spacing: 16) {
                                HStack {
                                    Text("Countries")
                                        .font(.custom("Inter", size: 20))
                                        .foregroundColor(themeManager.textColor)
                                    
                                    Spacer()
                                }
                                .padding(.horizontal, 20)
                                
                                LazyVStack(spacing: 12) {
                                    ForEach(Array(filteredCountries.prefix(10))) { country in
                                        Button(action: {
                                            onSave(country.name)
                                        }) {
                                            HStack(spacing: 12) {
                                                AsyncImage(url: URL(string: country.imageURL)) { image in
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
                                                                .font(.system(size: 16))
                                                                .foregroundColor(Color(red: 1.0, green: 0.4, blue: 0.2).opacity(0.6))
                                                            
                                                            Text("Loading...")
                                                                .font(.custom("Inter", size: 8))
                                                                .foregroundColor(Color(red: 1.0, green: 0.4, blue: 0.2).opacity(0.6))
                                                        }
                                                    }
                                                }
                                                .frame(width: 60, height: 60)
                                                .cornerRadius(8)
                                                .clipped()
                                                
                                                VStack(alignment: .leading, spacing: 4) {
                                                    Text(country.name)
                                                        .font(.custom("Inter", size: 16))
                                                        .foregroundColor(themeManager.textColor)
                                                        .lineLimit(1)
                                                    
                                                    Text("\(country.cityCount) Cities")
                                                        .font(.custom("Inter", size: 14))
                                                        .foregroundColor(themeManager.secondaryTextColor)
                                                }
                                                
                                                Spacer()
                                                
                                                Image(systemName: "chevron.right")
                                                    .foregroundColor(themeManager.secondaryTextColor)
                                                    .font(.system(size: 12))
                                            }
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 12)
                                            .background(Color.white)
                                            .cornerRadius(12)
                                            .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                }
                                .padding(.horizontal, 20)
                            }
                            
                            // Cities Section
                            VStack(alignment: .leading, spacing: 16) {
                                HStack {
                                    Text("Cities")
                                        .font(.custom("Inter", size: 20))
                                        .foregroundColor(themeManager.textColor)
                                    
                                    Spacer()
                                }
                                .padding(.horizontal, 20)
                                
                                LazyVStack(spacing: 12) {
                                    ForEach(Array(filteredCities.prefix(10))) { city in
                                        Button(action: {
                                            onSave(city.name)
                                        }) {
                                            HStack(spacing: 12) {
                                                AsyncImage(url: URL(string: city.imageURL)) { image in
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
                                                                .font(.system(size: 16))
                                                                .foregroundColor(Color(red: 1.0, green: 0.4, blue: 0.2).opacity(0.6))
                                                            
                                                            Text("Loading...")
                                                                .font(.custom("Inter", size: 8))
                                                                .foregroundColor(Color(red: 1.0, green: 0.4, blue: 0.2).opacity(0.6))
                                                        }
                                                    }
                                                }
                                                .frame(width: 60, height: 60)
                                                .cornerRadius(8)
                                                .clipped()
                                                
                                                VStack(alignment: .leading, spacing: 4) {
                                                    Text(city.name)
                                                        .font(.custom("Inter", size: 16))
                                                        .foregroundColor(themeManager.textColor)
                                                        .lineLimit(1)
                                                    
                                                    Text(city.country)
                                                        .font(.custom("Inter", size: 14))
                                                        .foregroundColor(themeManager.secondaryTextColor)
                                                }
                                                
                                                Spacer()
                                                
                                                Image(systemName: "chevron.right")
                                                    .foregroundColor(themeManager.secondaryTextColor)
                                                    .font(.system(size: 12))
                                            }
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 12)
                                            .background(Color.white)
                                            .cornerRadius(12)
                                            .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                }
                                .padding(.horizontal, 20)
                            }
                        }
                        .padding(.top, 8)
                        .padding(.bottom, 100)
                    }
                }
            }
            .navigationBarHidden(true)
            .navigationBarItems(
                leading: Button("Cancel") {
                    onCancel()
                },
                trailing: Button("Done") {
                    onCancel()
                }
            )
        }
    }
}

struct NightsEditorView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @Binding var nights: [Int]
    let onSave: () -> Void
    let onCancel: () -> Void
    
    @State private var tempNights: [Int] = []
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.white,
                        Color(red: 1.0, green: 0.95, blue: 0.9)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header
                    HStack {
                        Text("Edit Nights")
                            .font(.largeTitle)
                                        .font(.custom("Inter", size: 16).weight(.bold))
                            .foregroundColor(.primary)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                    .padding(.bottom, 16)
                    
                    // Total Nights Summary
                    VStack(spacing: 12) {
                        HStack {
                            Text("Total Nights:")
                                .font(.custom("Inter", size: 16))
                                .foregroundColor(themeManager.secondaryTextColor)
                            
                            Spacer()
                        }
                        
                        HStack {
                            Image(systemName: "moon.fill")
                                .foregroundColor(Color(red: 1.0, green: 0.4, blue: 0.2))
                                .font(.system(size: 16))
                            
                            Text("\(tempNights.reduce(0, +))/21")
                                .font(.custom("Inter", size: 18))
                                .foregroundColor(themeManager.textColor)
                            
                            Spacer()
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(12)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                    
                    // Nights Editor
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(Array(tempNights.enumerated()), id: \.offset) { index, night in
                                if index > 0 && index < tempNights.count - 1 { // Skip start and end points
                                    VStack(spacing: 8) {
                                        HStack {
                                            Text("Stop \(index + 1)")
                                                .font(.custom("Inter", size: 16))
                                                .foregroundColor(themeManager.textColor)
                                            
                                            Spacer()
                                            
                                            Text("\(night) nights")
                                                .font(.custom("Inter", size: 14))
                                                .foregroundColor(themeManager.secondaryTextColor)
                                        }
                                        
                                        HStack {
                                            Button(action: {
                                                if tempNights[index] > 0 {
                                                    tempNights[index] -= 1
                                                }
                                            }) {
                                                Image(systemName: "minus.circle.fill")
                                                    .font(.system(size: 24))
                                                    .foregroundColor(tempNights[index] > 0 ? Color(red: 1.0, green: 0.4, blue: 0.2) : Color.gray)
                                            }
                                            .disabled(tempNights[index] <= 0)
                                            
                                            Spacer()
                                            
                                            Text("\(tempNights[index])")
                                                .font(.custom("Inter", size: 20))
                                                .font(.custom("Inter", size: 14).weight(.bold))
                                                .foregroundColor(themeManager.textColor)
                                                .frame(minWidth: 40)
                                            
                                            Spacer()
                                            
                                            Button(action: {
                                                if tempNights.reduce(0, +) < 21 { // Max 21 nights total
                                                    tempNights[index] += 1
                                                }
                                            }) {
                                                Image(systemName: "plus.circle.fill")
                                                    .font(.system(size: 24))
                                                    .foregroundColor(tempNights.reduce(0, +) < 21 ? Color(red: 1.0, green: 0.4, blue: 0.2) : Color.gray)
                                            }
                                            .disabled(tempNights.reduce(0, +) >= 21)
                                        }
                                        .padding(.horizontal, 20)
                                    }
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 16)
                                    .background(Color.white)
                                    .cornerRadius(12)
                                    .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                                }
                            }
                        }
                        .padding(.top, 8)
                        .padding(.bottom, 100)
                    }
                }
            }
            .navigationBarHidden(true)
            .navigationBarItems(
                leading: Button("Cancel") {
                    onCancel()
                },
                trailing: Button("Save") {
                    nights = tempNights
                    onSave()
                }
            )
        }
        .onAppear {
            tempNights = nights
        }
    }
}

struct RouteStopRowNew: View {
    @EnvironmentObject var themeManager: ThemeManager
    let stop: RouteStop
    let stopNumber: Int
    @Binding var nights: Int
    let tickets: [Ticket]
    let onTicketTap: (RouteStop) -> Void
    let onNightsChanged: () -> Void
    let onDelete: (RouteStop) -> Void
    let onEdit: (RouteStop) -> Void
    let canDelete: Bool
    let canEdit: Bool
    
    // Swipe functionality removed - no state needed
    
    var body: some View {
        // Simple card without swipe functionality
        HStack(spacing: 16) {
            // Stop number circle (green like in screenshot)
            ZStack {
                Circle()
                    .fill(Color.green)
                    .frame(width: 32, height: 32)
                
                Text("\(stopNumber)")
                    .font(.custom("Inter", size: 16))
                                        .font(.custom("Inter", size: 16).weight(.bold))
                    .foregroundColor(.white)
            }
            
            // Stop details
            VStack(alignment: .leading, spacing: 4) {
                // City name
                Text(stop.destination)
                    .font(.custom("Inter", size: 18))
                    .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                
                // Dates
                Text(stop.dates)
                    .font(.custom("Inter", size: 14))
                    .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.5))
                
                // Transport info
                if !stop.isStart {
                    Button(action: {
                        onTicketTap(stop)
                    }) {
                        HStack(spacing: 8) {
                        // Transport icon (orange like in screenshot)
                        Image(systemName: stop.hasTrain ? "tram.fill" : (stop.hasFlight ? "airplane.departure" : "plus"))
                            .font(.system(size: 14))
                            .foregroundColor(Color(red: 1.0, green: 0.4, blue: 0.2)) // Orange color
                            
                            Text(stop.flightDuration)
                                .font(.custom("Inter", size: 14))
                                .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.5))
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            
            Spacer()
            
            // Nights counter
            VStack(spacing: 4) {
                HStack(spacing: 12) {
                    Button(action: {
                        if nights > 0 {
                            nights -= 1
                            onNightsChanged()
                        }
                    }) {
                        Image(systemName: "minus")
                            .font(.system(size: 16))
                            .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.5))
                    }
                    
                    Text("\(nights)")
                        .font(.custom("Inter", size: 18))
                        .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                        .frame(minWidth: 20)
                    
                    Button(action: {
                        nights += 1
                        onNightsChanged()
                    }) {
                        Image(systemName: "plus")
                            .font(.system(size: 16))
                            .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.5))
                    }
                }
                
                Text("nights")
                    .font(.custom("Inter", size: 12))
                    .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.5))
            }
        }
        .frame(maxWidth: .infinity, minHeight: 80, maxHeight: 80)
        .padding(.vertical, 12)
        .padding(.horizontal, 20)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

struct RouteStopRow: View {
    @EnvironmentObject var themeManager: ThemeManager
    let stop: RouteStop
    let stopNumber: Int
    let isLast: Bool
    let tickets: [Ticket]
    let onTicketTap: (RouteStop) -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            // Stop number circle
            ZStack {
                Circle()
                    .fill(Color(red: 1.0, green: 0.4, blue: 0.2))
                    .frame(width: 36, height: 36)
                
                Text("\(stopNumber)")
                    .font(.custom("Inter", size: 16))
                                        .font(.custom("Inter", size: 16).weight(.bold))
                    .foregroundColor(.white)
            }
            
            // Stop details
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    HStack(spacing: 6) {
                        Text(stop.countryEmoji)
                            .font(.system(size: 16))
                        
                        Text(stop.destination)
                            .font(.custom("Inter", size: 16))
                            .foregroundColor(Color(red: 1.0, green: 0.4, blue: 0.2)) // Orange color
                    }
                    
                    Spacer()
                    
                    Text(stop.dates)
                        .font(.custom("Inter", size: 12))
                        .foregroundColor(themeManager.secondaryTextColor)
                }
                
                HStack {
                    Text(stop.country)
                        .font(.custom("Inter", size: 12))
                        .foregroundColor(themeManager.secondaryTextColor)
                    
                    Spacer()
                    
                    Text(stop.duration)
                        .font(.custom("Inter", size: 14))
                        .foregroundColor(.white)
                }
            }
            
            // Transport icon
            if stop.hasFlight || stop.hasTrain || stop.isStart {
                Button(action: {
                    if !stop.isStart {
                        onTicketTap(stop)
                    }
                }) {
                    ZStack {
                        Image(systemName: stop.isStart ? "play.circle.fill" : (stop.hasTrain ? "tram.fill" : "airplane.departure"))
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(Color(red: 1.0, green: 0.4, blue: 0.2))
                        
                        // Show ticket indicator if ticket exists
                        if !stop.isStart && hasTicketForStop(stop) {
                            Circle()
                                .fill(Color.green)
                                .frame(width: 8, height: 8)
                                .offset(x: 8, y: -8)
                        }
                    }
                }
                .buttonStyle(PlainButtonStyle())
                .disabled(stop.isStart)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.vertical, 16)
        .padding(.horizontal, 20)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
    
    private func hasTicketForStop(_ stop: RouteStop) -> Bool {
        return tickets.contains { ticket in
            ticket.stopId == stop.id
        }
    }
}

struct BookingRow: View {
    @EnvironmentObject var themeManager: ThemeManager
    let item: PriceItem
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(item.item)
                    .font(.custom("Inter", size: 16))
                    .foregroundColor(themeManager.textColor)
                
                Text("Booking details")
                    .font(.custom("Inter", size: 12))
                    .foregroundColor(themeManager.secondaryTextColor)
            }
            
            Spacer()
            
            Text("€\(item.price)")
                .font(.custom("Inter", size: 16))
                .foregroundColor(.white)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(themeManager.oledCardBackgroundColor)
        .cornerRadius(12)
    }
}

struct StayCard: View {
    @EnvironmentObject var themeManager: ThemeManager
    let stay: Stay
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(stay.name)
                        .font(.custom("Inter", size: 18))
                        .foregroundColor(themeManager.textColor)
                    
                    HStack(spacing: 6) {
                        Text(stay.countryEmoji)
                            .font(.system(size: 16))
                        
                        Text(stay.location)
                            .font(.custom("Inter", size: 14))
                            .foregroundColor(themeManager.secondaryTextColor)
                    }
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("€\(stay.pricePerNight)")
                        .font(.custom("Inter", size: 16))
                                        .font(.custom("Inter", size: 16).weight(.bold))
                        .foregroundColor(.white)
                    
                    Text("per night")
                        .font(.custom("Inter", size: 12))
                        .foregroundColor(themeManager.secondaryTextColor)
                }
            }
            
            HStack {
                Text(stay.dates)
                    .font(.custom("Inter", size: 14))
                    .foregroundColor(themeManager.secondaryTextColor)
                
                Spacer()
                
                Text("\(stay.nights) nights")
                    .font(.custom("Inter", size: 14))
                    .foregroundColor(.white)
            }
            
            HStack {
                ForEach(stay.amenities, id: \.self) { amenity in
                    Text(amenity)
                        .font(.custom("Inter", size: 12))
                        .foregroundColor(themeManager.primaryColor)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(themeManager.primaryColor.opacity(0.1))
                        .cornerRadius(8)
                }
                
                Spacer()
            }
        }
        .padding(16)
        .background(themeManager.oledCardBackgroundColor)
        .cornerRadius(12)
        .shadow(color: themeManager.shadowColor, radius: 4, x: 0, y: 2)
    }
}

struct Stay: Identifiable {
    let id: Int
    let name: String
    let location: String
    let countryEmoji: String
    let dates: String
    let nights: Int
    let pricePerNight: Int
    let amenities: [String]
}

struct RouteCard: View {
    @EnvironmentObject var themeManager: ThemeManager
    let route: TravelRoute
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Route Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(route.title)
                        .font(.custom("Inter", size: 22))
                                        .font(.custom("Inter", size: 16).weight(.bold))
                        .foregroundColor(themeManager.textColor)
                    
                    Text(route.duration)
                        .font(.custom("Inter", size: 16))
                        .foregroundColor(themeManager.secondaryTextColor)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("€\(route.totalPrice)")
                        .font(.custom("Inter", size: 24))
                                        .font(.custom("Inter", size: 16).weight(.bold))
                        .foregroundColor(.white)
                    
                    Text("per person")
                        .font(.custom("Inter", size: 12))
                        .foregroundColor(themeManager.secondaryTextColor)
                }
            }
            
            // Route Timeline
            VStack(spacing: 16) {
                ForEach(Array(route.stops.enumerated()), id: \.offset) { index, stop in
                    RouteStopView(
                        stop: stop,
                        isFirst: index == 0,
                        isLast: index == route.stops.count - 1,
                        isEven: index % 2 == 0
                    )
                }
            }
            
            // Action Buttons
            HStack(spacing: 12) {
                Button(action: {}) {
                    Text("Customize")
                        .font(.custom("Inter", size: 16))
                        .foregroundColor(themeManager.primaryColor)
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                        .background(themeManager.primaryColor.opacity(0.1))
                        .cornerRadius(22)
                }
                
                Button(action: {}) {
                    Text("Book Route")
                        .font(.custom("Inter", size: 16))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                        .background(themeManager.primaryColor)
                        .cornerRadius(22)
                }
            }
        }
        .padding(24)
        .background(themeManager.oledCardBackgroundColor)
        .cornerRadius(20)
        .shadow(color: themeManager.shadowColor, radius: 12, x: 0, y: 6)
    }
}

struct RouteStopView: View {
    @EnvironmentObject var themeManager: ThemeManager
    let stop: RouteStop
    let isFirst: Bool
    let isLast: Bool
    let isEven: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            // Timeline indicator
            VStack(spacing: 0) {
                if !isFirst {
                    Rectangle()
                        .fill(themeManager.primaryColor.opacity(0.3))
                        .frame(width: 2, height: 20)
                }
                
                ZStack {
                    Circle()
                        .fill(themeManager.primaryColor)
                        .frame(width: 12, height: 12)
                    
                    if stop.hasFlight {
                        Image(systemName: "airplane")
                            .font(.system(size: 6))
                            .foregroundColor(.white)
                    }
                }
                
                if !isLast {
                    Rectangle()
                        .fill(themeManager.primaryColor.opacity(0.3))
                        .frame(width: 2, height: 20)
                }
            }
            
            // Stop content
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(stop.destination)
                            .font(.custom("Inter", size: 16))
                            .foregroundColor(Color(red: 1.0, green: 0.4, blue: 0.2)) // Orange color
                        
                        Text(stop.country)
                            .font(.custom("Inter", size: 12))
                            .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.5))
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text(stop.duration)
                            .font(.custom("Inter", size: 16))
                            .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                        
                        Text(stop.dates)
                            .font(.custom("Inter", size: 12))
                            .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.5))
                    }
                }
                
                if stop.hasFlight {
                    HStack {
                        Image(systemName: "airplane")
                            .font(.system(size: 12))
                            .foregroundColor(themeManager.primaryColor)
                        
                        Text(stop.flightInfo)
                            .font(.custom("Inter", size: 14))
                            .foregroundColor(themeManager.secondaryTextColor)
                        
                        Spacer()
                        
                        Text(stop.flightPrice)
                            .font(.custom("Inter", size: 14))
                            .foregroundColor(themeManager.primaryColor)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(themeManager.primaryColor.opacity(0.1))
                    .cornerRadius(8)
                }
            }
        }
    }
}

struct QuickRouteCard: View {
    @EnvironmentObject var themeManager: ThemeManager
    let route: TravelRoute
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            AsyncImage(url: URL(string: route.imageURL)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
            }
            .frame(width: 200, height: 120)
            .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(route.title)
                    .font(.custom("Inter", size: 16))
                    .foregroundColor(themeManager.textColor)
                    .lineLimit(2)
                
                Text(route.duration)
                    .font(.custom("Inter", size: 14))
                    .foregroundColor(themeManager.secondaryTextColor)
                
                Text("€\(route.totalPrice)")
                    .font(.custom("Inter", size: 16))
                                        .font(.custom("Inter", size: 16).weight(.bold))
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 12)
            .padding(.bottom, 12)
        }
        .frame(width: 200)
        .background(themeManager.oledCardBackgroundColor)
        .cornerRadius(16)
        .shadow(color: themeManager.shadowColor, radius: 8, x: 0, y: 4)
    }
}

struct RouteDetailView: View {
    @EnvironmentObject var themeManager: ThemeManager
    let route: TravelRoute
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Route Header
                    VStack(alignment: .leading, spacing: 16) {
                        Text(route.title)
                            .font(.custom("Inter", size: 28))
                                        .font(.custom("Inter", size: 16).weight(.bold))
                            .foregroundColor(themeManager.textColor)
                        
                        Text(route.description)
                            .font(.custom("Inter", size: 16))
                            .foregroundColor(themeManager.secondaryTextColor)
                            .lineLimit(nil)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    // Detailed Timeline
                    VStack(spacing: 20) {
                        ForEach(Array(route.stops.enumerated()), id: \.offset) { index, stop in
                            DetailedRouteStopView(
                                stop: stop,
                                isFirst: index == 0,
                                isLast: index == route.stops.count - 1
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    // Price Breakdown
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Price Breakdown")
                            .font(.custom("Inter", size: 20))
                            .foregroundColor(themeManager.textColor)
                            .padding(.horizontal, 20)
                        
                        VStack(spacing: 12) {
                            ForEach(route.priceBreakdown, id: \.item) { item in
                                HStack {
                                    Text(item.item)
                                        .font(.custom("Inter", size: 16))
                                        .foregroundColor(themeManager.textColor)
                                    
                                    Spacer()
                                    
                                    Text("€\(item.price)")
                                        .font(.custom("Inter", size: 16))
                                        .foregroundColor(themeManager.primaryColor)
                                }
                                .padding(.horizontal, 20)
                                .padding(.vertical, 12)
                                .background(themeManager.oledCardBackgroundColor)
                                .cornerRadius(12)
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    // Book Button
                    Button(action: {}) {
                        Text("Book This Route")
                            .font(.custom("Inter", size: 18))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(themeManager.primaryColor)
                            .cornerRadius(15)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
            }
            .background(themeManager.oledBackgroundColor)
            .navigationTitle("Route Details")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

struct DetailedRouteStopView: View {
    @EnvironmentObject var themeManager: ThemeManager
    let stop: RouteStop
    let isFirst: Bool
    let isLast: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 8) {
                        Text(stop.countryEmoji)
                            .font(.system(size: 20))
                        
                        Text(stop.destination)
                            .font(.custom("Inter", size: 20))
                                        .font(.custom("Inter", size: 16).weight(.bold))
                            .foregroundColor(Color(red: 1.0, green: 0.4, blue: 0.2)) // Orange color
                    }
                    
                    Text(stop.country)
                        .font(.custom("Inter", size: 16))
                        .foregroundColor(themeManager.secondaryTextColor)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text(stop.duration)
                        .font(.custom("Inter", size: 18))
                                        .font(.custom("Inter", size: 16).weight(.bold))
                        .foregroundColor(.white)
                    
                    Text(stop.dates)
                        .font(.custom("Inter", size: 14))
                        .foregroundColor(themeManager.secondaryTextColor)
                }
            }
            
            if stop.hasFlight || stop.hasTrain {
                HStack {
                    Image(systemName: stop.hasTrain ? "tram.fill" : "airplane.departure")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(themeManager.primaryColor)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(stop.flightInfo)
                            .font(.custom("Inter", size: 16))
                            .foregroundColor(themeManager.textColor)
                        
                        Text("Duration: \(stop.flightDuration)")
                            .font(.custom("Inter", size: 14))
                            .foregroundColor(themeManager.secondaryTextColor)
                    }
                    
                    Spacer()
                    
                    Text(stop.flightPrice)
                        .font(.custom("Inter", size: 16))
                                        .font(.custom("Inter", size: 16).weight(.bold))
                        .foregroundColor(.white)
                }
                .padding(16)
                .background(themeManager.primaryColor.opacity(0.1))
                .cornerRadius(12)
            }
        }
        .padding(20)
        .background(themeManager.oledCardBackgroundColor)
        .cornerRadius(16)
        .shadow(color: themeManager.shadowColor, radius: 8, x: 0, y: 4)
    }
}

// Sample Data - Your Test Route
let featuredRoute = TravelRoute(
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
            dates: "Thu 07 Mar - Transit",
            hasFlight: true,
            hasTrain: false,
            isStart: false,
            flightInfo: "Home → Munich",
            flightDuration: "1h 30m",
            flightPrice: "€89",
            nights: 0
        ),
        RouteStop(
            id: 2,
            destination: "Taipei",
            country: "Taiwan",
            countryEmoji: "🇹🇼",
            duration: "0 Days",
            dates: "Thu 07 Mar - Transit",
            hasFlight: false,
            hasTrain: true,
            isStart: false,
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
            duration: "5 Days",
            dates: "Thu 07 Mar - Tue 12 Mar",
            hasFlight: false,
            hasTrain: true,
            isStart: false,
            flightInfo: "Taipei → Taichung",
            flightDuration: "1h 15m",
            flightPrice: "€25",
            nights: 5
        ),
        RouteStop(
            id: 4,
            destination: "Taipei",
            country: "Taiwan",
            countryEmoji: "🇹🇼",
            duration: "2 Days",
            dates: "Tue 12 Mar - Thu 14 Mar",
            hasFlight: true,
            hasTrain: false,
            isStart: false,
            flightInfo: "Taichung → Taipei",
            flightDuration: "1h 15m",
            flightPrice: "€25",
            nights: 2
        ),
        RouteStop(
            id: 5,
            destination: "Bali",
            country: "Indonesia",
            countryEmoji: "🇮🇩",
            duration: "5 Days",
            dates: "Thu 14 Mar - Tue 19 Mar",
            hasFlight: true,
            hasTrain: false,
            isStart: false,
            flightInfo: "Taipei → Denpasar",
            flightDuration: "5h 30m",
            flightPrice: "€445",
            nights: 5
        ),
        RouteStop(
            id: 6,
            destination: "Kuala Lumpur",
            country: "Malaysia",
            countryEmoji: "🇲🇾",
            duration: "5 Days",
            dates: "Tue 19 Mar - Sun 24 Mar",
            hasFlight: true,
            hasTrain: false,
            isStart: false,
            flightInfo: "Denpasar → Kuala Lumpur",
            flightDuration: "2h 30m",
            flightPrice: "€189",
            nights: 5
        ),
        RouteStop(
            id: 7,
            destination: "Bangkok",
            country: "Thailand",
            countryEmoji: "🇹🇭",
            duration: "4 Days",
            dates: "Sun 24 Mar - Thu 28 Mar",
            hasFlight: true,
            hasTrain: false,
            isStart: false,
            flightInfo: "Kuala Lumpur → Bangkok",
            flightDuration: "1h 45m",
            flightPrice: "€298",
            nights: 4
        ),
        RouteStop(
            id: 8,
            destination: "Munich",
            country: "Germany",
            countryEmoji: "🇩🇪",
            duration: "0 Days",
            dates: "Thu 28 Mar - Home",
            hasFlight: true,
            hasTrain: false,
            isStart: false,
            flightInfo: "Bangkok → Munich",
            flightDuration: "11h 30m",
            flightPrice: "€589",
            nights: 0
        )
    ],
    priceBreakdown: [
        PriceItem(id: 1, item: "Taichung Accommodation (5 nights)", price: 450),
        PriceItem(id: 2, item: "Taipei Accommodation (2 nights)", price: 180),
        PriceItem(id: 3, item: "Bali Accommodation (10 nights)", price: 650),
        PriceItem(id: 4, item: "Bangkok Accommodation (4 nights)", price: 320),
        PriceItem(id: 5, item: "Munich → Taichung Flight", price: 589),
        PriceItem(id: 6, item: "Taichung → Taipei Train", price: 89),
        PriceItem(id: 7, item: "Taipei → Bali Flight", price: 445),
        PriceItem(id: 8, item: "Bali → Bangkok Flight", price: 298),
        PriceItem(id: 9, item: "Travel Insurance", price: 95),
        PriceItem(id: 10, item: "Visa & Documents", price: 120),
        PriceItem(id: 11, item: "Service Fee", price: 252)
    ]
)

// Sample stays data
let sampleStays = [
    Stay(
        id: 1,
        name: "Grand Hotel Taichung",
        location: "Taichung, Taiwan",
        countryEmoji: "🇹🇼",
        dates: "Thu 07 Mar - Tue 12 Mar",
        nights: 5,
        pricePerNight: 90,
        amenities: ["Wi-Fi", "Pool", "Spa", "Restaurant"]
    ),
    Stay(
        id: 2,
        name: "Taipei Central Hotel",
        location: "Taipei, Taiwan",
        countryEmoji: "🇹🇼",
        dates: "Tue 12 Mar - Thu 14 Mar",
        nights: 2,
        pricePerNight: 90,
        amenities: ["Wi-Fi", "Gym", "Restaurant"]
    ),
    Stay(
        id: 3,
        name: "Bali Beach Resort",
        location: "Denpasar, Indonesia",
        countryEmoji: "🇮🇩",
        dates: "Thu 14 Mar - Sun 24 Mar",
        nights: 10,
        pricePerNight: 65,
        amenities: ["Wi-Fi", "Beach", "Pool", "Spa", "Restaurant"]
    ),
    Stay(
        id: 4,
        name: "Bangkok City Hotel",
        location: "Bangkok, Thailand",
        countryEmoji: "🇹🇭",
        dates: "Sun 24 Mar - Thu 28 Mar",
        nights: 4,
        pricePerNight: 80,
        amenities: ["Wi-Fi", "Pool", "Restaurant", "Bar"]
    )
]

let quickRoutes = [
    TravelRoute(
        id: 2,
        title: "European Grand Tour",
        description: "Explore the best of Europe",
        duration: "14 Days",
        totalPrice: 1899,
        imageURL: "https://images.unsplash.com/photo-1513635269975-59663e0ac1ad?w=600&h=400&fit=crop&crop=center",
        stops: [],
        priceBreakdown: []
    ),
    TravelRoute(
        id: 3,
        title: "Japan Discovery",
        description: "From Tokyo to Kyoto",
        duration: "10 Days",
        totalPrice: 1599,
        imageURL: "https://images.unsplash.com/photo-1493976040374-85c8e12f0c0e?w=600&h=400&fit=crop&crop=center",
        stops: [],
        priceBreakdown: []
    ),
    TravelRoute(
        id: 4,
        title: "Australia Adventure",
        description: "Sydney to Melbourne",
        duration: "12 Days",
        totalPrice: 2199,
        imageURL: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=600&h=400&fit=crop&crop=center",
        stops: [],
        priceBreakdown: []
    )
]

struct StaysView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.presentationMode) var presentationMode
    let stays: [Stay]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Your Stays")
                            .font(.custom("Inter", size: 28))
                                        .font(.custom("Inter", size: 16).weight(.bold))
                            .foregroundColor(themeManager.textColor)
                        
                        Text("Accommodation for your Asia Adventure")
                            .font(.custom("Inter", size: 16))
                            .foregroundColor(themeManager.secondaryTextColor)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    // Stays list
                    LazyVStack(spacing: 16) {
                        ForEach(stays) { stay in
                            StayCard(stay: stay)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 100)
                }
            }
            .background(themeManager.oledBackgroundColor)
            .navigationTitle("Stays")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
    }
}
}
