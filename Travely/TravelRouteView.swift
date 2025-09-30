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
    @State private var nights = [0, 0, 4, 2, 5, 5, 5, 0] // Nights for each stop
    @State private var currentRoute: TravelRoute = featuredRoute // Make route mutable
    @State private var showingDeleteAlert = false
    @State private var stopToDelete: (index: Int, stop: RouteStop)? = nil
    @State private var showingEditSheet = false
    @State private var stopToEdit: (index: Int, stop: RouteStop)? = nil
    @State private var showingNightsEditor = false
    @State private var showingDatePicker = false
    @State private var selectedStopForDate: RouteStop?
    @State private var showingInsertMenu = false
    @State private var selectedStopForInsert: RouteStop?
    
    // Computed property for total nights
    private var totalNights: Int {
        nights.reduce(0, +)
    }
    
    // Computed property for progress (0.0 to 1.0)
    private var progressValue: Double {
        let maxNights = 21 // Updated to match 21/21 display
        return min(Double(totalNights) / Double(maxNights), 1.0)
    }
    
    // Computed property for progress color
    private var progressColor: Color {
        return totalNights > 21 ? FlatDesignSystem.accentRed : FlatDesignSystem.accentGreen
    }
    
    // Helper function to format date
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
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
                        // Progress Indicator - Green like in screenshot
                        Button(action: {
                            DispatchQueue.main.async {
                                showingNightsEditor = true
                            }
                        }) {
                            HStack(spacing: FlatDesignSystem.paddingS) {
                                ZStack {
                                    Circle()
                                        .stroke(FlatDesignSystem.border, lineWidth: 4)
                                        .frame(width: 50, height: 50)
                                    
                                    Circle()
                                        .trim(from: 0, to: progressValue)
                                        .stroke(FlatDesignSystem.accentGreen, lineWidth: 4)
                                        .frame(width: 50, height: 50)
                                        .rotationEffect(.degrees(-90))
                                    
                                    Text("\(totalNights)")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(FlatDesignSystem.accentGreen)
                                }
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("\(totalNights)/21")
                                        .font(.system(size: 18, weight: .bold))
                                        .foregroundColor(FlatDesignSystem.text)
                                    
                                    Text("Nights planned")
                                        .font(.system(size: 12, weight: .regular))
                                        .foregroundColor(FlatDesignSystem.textSecondary)
                                }
                                
                                Spacer()
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        Spacer()
                        
                        // Tab Segments - Green like in screenshot
                        HStack(spacing: 0) {
                            Button(action: { selectedTab = 0 }) {
                                Text("Route")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(selectedTab == 0 ? .white : FlatDesignSystem.textSecondary)
                                    .frame(width: 80, height: 32)
                                    .background(selectedTab == 0 ? FlatDesignSystem.accentGreen : Color.clear)
                                    .cornerRadius(16)
                            }
                            
                            Button(action: { selectedTab = 1 }) {
                                Text("Bookings")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(selectedTab == 1 ? .white : FlatDesignSystem.textSecondary)
                                    .frame(width: 80, height: 32)
                                    .background(selectedTab == 1 ? FlatDesignSystem.accentGreen : Color.clear)
                                    .cornerRadius(16)
                            }
                        }
                        .padding(4)
                        .background(FlatDesignSystem.border.opacity(0.3))
                        .cornerRadius(20)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                    .padding(.bottom, 20)
                    
                    // Main content area
                    if selectedTab == 0 {
                        ScrollView {
                            VStack(spacing: 0) {
                                // Route stops - Full width seamless cards
                                ForEach(Array(currentRoute.stops.enumerated()), id: \.offset) { index, stop in
                                    RouteStopRowNew(
                                        stop: stop,
                                        stopNumber: index + 1,
                                        nights: $nights[index],
                                        tickets: tickets,
                                        onTicketTap: { selectedStop in
                                            selectedStopForTicket = selectedStop
                                            DispatchQueue.main.async {
                                                showingTicketSheet = true
                                            }
                                        },
                                        onNightsChanged: {
                                            updateDates()
                                        },
                                        onDelete: { stopToDelete in
                                            self.stopToDelete = (index: index, stop: stopToDelete)
                                            DispatchQueue.main.async {
                                                showingDeleteAlert = true
                                            }
                                        },
                                        onEdit: { stopToEdit in
                                            if let index = currentRoute.stops.firstIndex(where: { $0.id == stopToEdit.id }) {
                                                self.stopToEdit = (index: index, stop: stopToEdit)
                                                DispatchQueue.main.async {
                                                    showingEditSheet = true
                                                }
                                            }
                                        },
                                        onSetDate: { selectedStop in
                                            selectedStopForDate = selectedStop
                                            DispatchQueue.main.async {
                                                showingDatePicker = true
                                            }
                                        },
                                        onInsert: { selectedStop in
                                            selectedStopForInsert = selectedStop
                                            DispatchQueue.main.async {
                                                showingInsertMenu = true
                                            }
                                        },
                                        canDelete: index != 0 && index != currentRoute.stops.count - 1,
                                        canEdit: true, // Allow editing for all stops
                                        isFirst: index == 0,
                                        isLast: index == currentRoute.stops.count - 1
                                    )
                                    
                                    // Transport icon between stops (except after last stop)
                                    if index < currentRoute.stops.count - 1 {
                                        TransportIconRow(
                                            stop: stop,
                                            onTicketTap: { selectedStop in
                                                selectedStopForTicket = selectedStop
                                                DispatchQueue.main.async {
                                                    showingTicketSheet = true
                                                }
                                            }
                                        )
                                    }
                                }
                                
                                Spacer()
                                    .frame(height: 20)
                            }
                            // Remove horizontal padding to make cards full width
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
        .sheet(isPresented: $showingDatePicker) {
            if let stop = selectedStopForDate {
                DatePickerView(
                    stop: stop,
                    isPresented: $showingDatePicker,
                    onDateChanged: { updatedStop, newDate in
                        // Update the stop's date in the route
                        if let index = currentRoute.stops.firstIndex(where: { $0.id == updatedStop.id }) {
                            var updatedStops = currentRoute.stops
                            updatedStops[index].dates = formatDate(newDate)
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
                        }
                    }
                )
                .onAppear {
                    // Ensure the sheet content is properly loaded
                }
            } else {
                // Fallback view to prevent sheet issues
                EmptyView()
            }
        }
        .sheet(isPresented: $showingInsertMenu) {
            if let stop = selectedStopForInsert {
                InsertMenuView(
                    currentRoute: currentRoute,
                    selectedStop: stop,
                    isPresented: $showingInsertMenu,
                    onInsertDestination: { selectedStop, destination in
                        // Insert the destination after the selected stop
                        if let index = currentRoute.stops.firstIndex(where: { $0.id == selectedStop.id }) {
                            let newStop = RouteStop(
                                id: UUID().hashValue, // Generate new ID
                                destination: destination,
                                country: "Unknown", // You might want to improve this
                                countryEmoji: "🌍",
                                duration: "1 Day",
                                dates: "TBD",
                                hasFlight: false,
                                hasTrain: false,
                                isStart: false,
                                flightInfo: "",
                                flightDuration: "",
                                flightPrice: "",
                                nights: 1
                            )
                            
                            var updatedStops = currentRoute.stops
                            updatedStops.insert(newStop, at: index + 1)
                            
                            // Add corresponding nights entry
                            var updatedNights = nights
                            updatedNights.insert(1, at: index + 1)
                            
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
                            
                            // Update dates after insertion
                            updateDates()
                        }
                    }
                )
                .onAppear {
                    // Ensure the sheet content is properly loaded
                }
            } else {
                // Fallback view to prevent sheet issues
                EmptyView()
            }
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

// Extension for removing duplicates
extension Array where Element: Equatable {
    func removingDuplicates() -> [Element] {
        var result = [Element]()
        for value in self {
            if !result.contains(value) {
                result.append(value)
            }
        }
        return result
    }
}

struct InsertMenuView: View {
    let currentRoute: TravelRoute
    let selectedStop: RouteStop
    @Binding var isPresented: Bool
    let onInsertDestination: (RouteStop, String) -> Void
    
    // Get unique destinations from current route (excluding start/end points)
    private var availableDestinations: [String] {
        let destinations = currentRoute.stops
            .filter { !$0.isStart && $0.destination != "Munich" } // Exclude start/end points
            .map { $0.destination }
            .removingDuplicates()
        return destinations
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button("Cancel") {
                        isPresented = false
                    }
                    .foregroundColor(FlatDesignSystem.textSecondary)
                    .font(.system(size: 16, weight: .medium))
                    
                    Spacer()
                    
                    HStack(spacing: 8) {
                        Image(systemName: "location.fill")
                            .foregroundColor(FlatDesignSystem.accentGreen)
                            .font(.system(size: 16, weight: .medium))
                        
                        Text("Insert after \(selectedStop.destination)")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(FlatDesignSystem.text)
                            .lineLimit(1)
                    }
                    
                    Spacer()
                    
                    // Empty space for balance
                    Text("")
                        .font(.system(size: 16, weight: .medium))
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(FlatDesignSystem.surface)
                
                // Search bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(FlatDesignSystem.textSecondary)
                        .font(.system(size: 16, weight: .medium))
                    
                    TextField("Enter name E.g. \"Rome\"...", text: .constant(""))
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(FlatDesignSystem.text)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(FlatDesignSystem.surface)
                .cornerRadius(12)
                .padding(.horizontal, 16)
                .padding(.top, 16)
                
                // Destinations list
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Text("TOP \(availableDestinations.count)")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(FlatDesignSystem.textSecondary)
                        
                        Text("Popular destinations in our route")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(FlatDesignSystem.text)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 24)
                    .padding(.bottom, 16)
                    
                    LazyVStack(spacing: 0) {
                        ForEach(Array(availableDestinations.enumerated()), id: \.offset) { index, destination in
                            HStack {
                                // Number badge
                                ZStack {
                                    Circle()
                                        .fill(FlatDesignSystem.accentGreen.opacity(0.2))
                                        .frame(width: 24, height: 24)
                                    
                                    Text("\(index + 1)")
                                        .font(.system(size: 12, weight: .bold))
                                        .foregroundColor(FlatDesignSystem.accentGreen)
                                }
                                
                                // Destination name
                                Text(destination)
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(FlatDesignSystem.text)
                                
                                Spacer()
                                
                                // Plus button
                                Button(action: {
                                    onInsertDestination(selectedStop, destination)
                                    isPresented = false
                                }) {
                                    Image(systemName: "plus")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(FlatDesignSystem.text)
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            
                            if index < availableDestinations.count - 1 {
                                Rectangle()
                                    .fill(FlatDesignSystem.border)
                                    .frame(height: 0.5)
                                    .padding(.leading, 48)
                            }
                        }
                    }
                }
                .padding(.bottom, 12) // Reduced padding for compactness
            }
            .background(FlatDesignSystem.background)
            .frame(maxWidth: UIScreen.main.bounds.width * 0.6) // Half screen width
            .fixedSize(horizontal: true, vertical: false) // Shrink to content width
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
                // Background
                FlatDesignSystem.background
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header
                    HStack {
                        Text("Edit Nights")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(FlatDesignSystem.text)
                        
                        Spacer()
                    }
                    .padding(.horizontal, FlatDesignSystem.paddingL)
                    .padding(.top, FlatDesignSystem.paddingM)
                    .padding(.bottom, FlatDesignSystem.paddingM)
                    
                    // Total Nights Summary
                    VStack(spacing: FlatDesignSystem.paddingS) {
                        HStack {
                            Text("Total Nights:")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(FlatDesignSystem.textSecondary)
                            
                            Spacer()
                        }
                        
                        HStack {
                            Image(systemName: "moon.fill")
                                .foregroundColor(FlatDesignSystem.accentGreen)
                                .font(.system(size: 16))
                            
                            Text("\(tempNights.dropFirst().dropLast().reduce(0, +))/21")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(FlatDesignSystem.text)
                            
                            Spacer()
                        }
                        .padding(.horizontal, FlatDesignSystem.paddingL)
                        .padding(.vertical, FlatDesignSystem.paddingM)
                        .background(FlatDesignSystem.surface)
                        .cornerRadius(12)
                    }
                    .padding(.horizontal, FlatDesignSystem.paddingL)
                    .padding(.bottom, FlatDesignSystem.paddingM)
                    
                    // Nights Editor
                    ScrollView {
                        VStack(spacing: 0) {
                            ForEach(Array(tempNights.enumerated()), id: \.offset) { index, night in
                                if index > 0 && index < tempNights.count - 1 { // Skip start and end points
                                    VStack(spacing: FlatDesignSystem.paddingS) {
                                        HStack {
                                            Text("Stop \(index + 1)")
                                                .font(.system(size: 16, weight: .medium))
                                                .foregroundColor(FlatDesignSystem.text)
                                            
                                            Spacer()
                                            
                                            Text("\(night) nights")
                                                .font(.system(size: 14, weight: .medium))
                                                .foregroundColor(FlatDesignSystem.textSecondary)
                                        }
                                        
                                        HStack {
                                            Button(action: {
                                                if tempNights[index] > 0 {
                                                    tempNights[index] -= 1
                                                }
                                            }) {
                                                Image(systemName: "minus.circle.fill")
                                                    .font(.system(size: 20))
                                                    .foregroundColor(tempNights[index] > 0 ? FlatDesignSystem.accentGreen : FlatDesignSystem.textSecondary)
                                            }
                                            .disabled(tempNights[index] <= 0)
                                            
                                            Spacer()
                                            
                                            Text("\(tempNights[index])")
                                                .font(.system(size: 18, weight: .bold))
                                                .foregroundColor(FlatDesignSystem.text)
                                                .frame(minWidth: 30)
                                            
                                            Spacer()
                                            
                                            Button(action: {
                                                if tempNights.dropFirst().dropLast().reduce(0, +) < 21 { // Max 21 nights total
                                                    tempNights[index] += 1
                                                }
                                            }) {
                                                Image(systemName: "plus.circle.fill")
                                                    .font(.system(size: 20))
                                                    .foregroundColor(tempNights.dropFirst().dropLast().reduce(0, +) < 21 ? FlatDesignSystem.accentGreen : FlatDesignSystem.textSecondary)
                                            }
                                            .disabled(tempNights.dropFirst().dropLast().reduce(0, +) >= 21)
                                        }
                                        .padding(.horizontal, FlatDesignSystem.paddingL)
                                    }
                                    .padding(.horizontal, FlatDesignSystem.paddingL)
                                    .padding(.vertical, FlatDesignSystem.paddingM)
                                    .background(FlatDesignSystem.surface)
                                    .cornerRadius(12)
                                }
                            }
                        }
                        .padding(.top, FlatDesignSystem.paddingS)
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

struct DatePickerView: View {
    let stop: RouteStop
    @Binding var isPresented: Bool
    let onDateChanged: (RouteStop, Date) -> Void
    @State private var selectedDate = Date()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Compact calendar container
                VStack(spacing: 0) {
                    // Header - Compact
                    HStack {
                        Button("Cancel") {
                            isPresented = false
                        }
                        .foregroundColor(FlatDesignSystem.textSecondary)
                        .font(.system(size: 16, weight: .medium))
                        
                        Spacer()
                        
                        Text("Start date for \(stop.destination)")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(FlatDesignSystem.text)
                            .lineLimit(1)
                        
                        Spacer()
                        
                        Button("Done") {
                            // Update the stop's start date
                            onDateChanged(stop, selectedDate)
                            isPresented = false
                        }
                        .foregroundColor(FlatDesignSystem.accentGreen)
                        .font(.system(size: 16, weight: .semibold))
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(FlatDesignSystem.background)
                    
                    // Calendar with compact styling
                    DatePicker(
                        "Select Date",
                        selection: $selectedDate,
                        displayedComponents: [.date]
                    )
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .accentColor(FlatDesignSystem.accentGreen)
                    .colorScheme(.light)
                    .scaleEffect(0.8) // Make calendar even smaller
                    .padding(.horizontal, 8)
                    .padding(.bottom, 8)
                }
                .background(FlatDesignSystem.surface)
                .cornerRadius(12)
                .padding(.horizontal, 8)
                .padding(.bottom, 12) // Reduced padding for compactness
            }
            .background(FlatDesignSystem.background)
            .frame(maxWidth: UIScreen.main.bounds.width * 0.6) // Half screen width
            .fixedSize(horizontal: true, vertical: false) // Shrink to content width
        }
        .onAppear {
            // Set initial date based on stop's current date
            selectedDate = Date() // You can parse the stop's current date here
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
    let onSetDate: (RouteStop) -> Void
    let onInsert: (RouteStop) -> Void
    let canDelete: Bool
    let canEdit: Bool
    let isFirst: Bool
    let isLast: Bool
    
    // Swipe functionality
    @State private var dragOffset: CGFloat = 0
    @State private var isSwipeActive: Bool = false
    
    var body: some View {
        ZStack(alignment: .leading) {
            // Swipe action buttons background - Full height to match card
            HStack(spacing: 0) {
                Spacer()
                
                // Action buttons with consistent alignment
                HStack(spacing: 0) {
                    // Lock date button
                    Button(action: {
                        // Lock date action
                    }) {
                        VStack(spacing: 4) {
                            Image(systemName: "lock.fill")
                                .font(.system(size: 20))
                                .foregroundColor(FlatDesignSystem.textSecondary)
                            
                            Text("Lock date")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(FlatDesignSystem.textSecondary)
                        }
                        .frame(width: 80, height: 80)
                        .background(FlatDesignSystem.background)
                    }
                    
                    // Set date button
                    Button(action: {
                        DispatchQueue.main.async {
                            onSetDate(stop)
                        }
                    }) {
                        VStack(spacing: 4) {
                            Image(systemName: "calendar")
                                .font(.system(size: 20))
                                .foregroundColor(FlatDesignSystem.textSecondary)
                            
                            Text("Set date")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(FlatDesignSystem.textSecondary)
                        }
                        .frame(width: 80, height: 80)
                        .background(FlatDesignSystem.background)
                    }
                    
                    // Insert button
                    Button(action: {
                        onInsert(stop)
                    }) {
                        VStack(spacing: 4) {
                            Image(systemName: "plus.rectangle.on.rectangle")
                                .font(.system(size: 20))
                                .foregroundColor(FlatDesignSystem.textSecondary)
                            
                            Text("Insert")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(FlatDesignSystem.textSecondary)
                        }
                        .frame(width: 80, height: 80)
                        .background(FlatDesignSystem.background)
                    }
                    
                    // Delete button
                    Button(action: {
                        onDelete(stop)
                    }) {
                        VStack(spacing: 4) {
                            Image(systemName: "trash.fill")
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                            
                            Text("Delete")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.white)
                        }
                        .frame(width: 80, height: 80)
                        .background(FlatDesignSystem.accentRed)
                    }
                }
                .frame(width: 320, height: 80) // Fixed width and height for consistent alignment
            }
            
            // Main card content
            VStack(spacing: 0) {
                HStack(spacing: FlatDesignSystem.paddingM) {
                    // Stop number circle - Green like in screenshot
                    ZStack {
                        Circle()
                            .fill(FlatDesignSystem.accentGreen)
                            .frame(width: 40, height: 40)
                        
                        Text("\(stopNumber)")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                    }
                    
                    // Stop details
                    VStack(alignment: .leading, spacing: 4) {
                        // City name - Bold like in screenshot
                        Text(stop.destination)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(FlatDesignSystem.text)
                        
                        // Dates - Secondary text
                        Text(stop.dates)
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(FlatDesignSystem.textSecondary)
                    }
                    
                    Spacer()
                    
                    // Nights counter - Right aligned like in screenshot
                    VStack(spacing: 4) {
                        HStack(spacing: 12) {
                            Button(action: {
                                if nights > 0 {
                                    nights -= 1
                                    onNightsChanged()
                                }
                            }) {
                                Image(systemName: "minus")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(FlatDesignSystem.textSecondary)
                            }
                            
                            Text("\(nights)")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(FlatDesignSystem.text)
                                .frame(minWidth: 24)
                            
                            Button(action: {
                                nights += 1
                                onNightsChanged()
                            }) {
                                Image(systemName: "plus")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(FlatDesignSystem.textSecondary)
                            }
                        }
                        
                        Text("nights")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(FlatDesignSystem.textSecondary)
                    }
                }
                .padding(.horizontal, FlatDesignSystem.paddingM)
                .padding(.vertical, FlatDesignSystem.paddingL) // Increased vertical padding
                .background(FlatDesignSystem.surface)
            }
            .offset(x: dragOffset)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        // No animation during drag for immediate response
                        let translation = value.translation.width
                        if translation < 0 {
                            dragOffset = max(translation, -320) // Limit swipe distance
                        } else {
                            dragOffset = min(translation, 0) // Don't allow right swipe
                        }
                    }
                    .onEnded { value in
                        // Smooth animation only when gesture ends
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8, blendDuration: 0.1)) {
                            if dragOffset < -160 {
                                dragOffset = -320
                                isSwipeActive = true
                            } else {
                                dragOffset = 0
                                isSwipeActive = false
                            }
                        }
                    }
            )
        }
        .frame(maxWidth: .infinity)
        .frame(height: 80) // Fixed height of 80 pixels
        .background(FlatDesignSystem.surface)
        .cornerRadius(isFirst ? FlatDesignSystem.radiusL : 0, corners: isFirst ? [.topLeft, .topRight] : [])
        .cornerRadius(isLast ? FlatDesignSystem.radiusL : 0, corners: isLast ? [.bottomLeft, .bottomRight] : [])
        .clipped()
    }
}

struct TransportIconRow: View {
    let stop: RouteStop
    let onTicketTap: (RouteStop) -> Void
    
    // Timeline offset to align with the center of green circles
    private let timelineXOffset: CGFloat = FlatDesignSystem.paddingM + 20 // 16 + 20 = 36 (center of 40px circle)
    
    var body: some View {
        // Transport icon button without timeline line - TEMPORARILY HIDDEN
        // HStack(spacing: 0) {
        //     Spacer()
        //         .frame(width: timelineXOffset - 12) // Position icon aligned with circles
        //     
        //     Button(action: {
        //         onTicketTap(stop)
        //     }) {
        //         HStack(spacing: 8) {
        //             // Transport icon - Pink/Orange like in screenshot
        //             Image(systemName: stop.hasTrain ? "tram.fill" : (stop.hasFlight ? "airplane.departure" : "plus"))
        //                 .font(.system(size: 14, weight: .medium))
        //                 .foregroundColor(FlatDesignSystem.accentOrange)
        //             
        //             Text(stop.flightDuration)
        //                 .font(.system(size: 14, weight: .regular))
        //                 .foregroundColor(FlatDesignSystem.textSecondary)
        //         }
        //         .padding(.vertical, 6)
        //         .padding(.horizontal, 12)
        //         .background(FlatDesignSystem.background)
        //         .cornerRadius(FlatDesignSystem.radiusM)
        //     }
        //     .buttonStyle(PlainButtonStyle())
        //     
        //     Spacer()
        // }
        // .frame(height: 20) // Smaller height since no timeline line
        // .frame(maxWidth: .infinity)
        // .background(FlatDesignSystem.surface)
        
        // Empty view to hide ticket icon temporarily
        EmptyView()
            .frame(height: 0)
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
        FlatCard {
            VStack(spacing: 0) {
                HStack(spacing: FlatDesignSystem.paddingM) {
                    // Stop number circle - Green like in screenshot
                    ZStack {
                        Circle()
                            .fill(FlatDesignSystem.accentGreen)
                            .frame(width: 40, height: 40)
                        
                        Text("\(stopNumber)")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                    }
                    
                    // Stop details
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            HStack(spacing: FlatDesignSystem.paddingS) {
                                Text(stop.countryEmoji)
                                    .font(.system(size: 16))
                                
                                Text(stop.destination)
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(FlatDesignSystem.text)
                            }
                            
                            Spacer()
                            
                            Text(stop.dates)
                                .font(.system(size: 14, weight: .regular))
                                .foregroundColor(FlatDesignSystem.textSecondary)
                        }
                        
                        HStack {
                            Text(stop.country)
                                .font(.system(size: 14, weight: .regular))
                                .foregroundColor(FlatDesignSystem.textSecondary)
                            
                            Spacer()
                            
                            Text(stop.duration)
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(FlatDesignSystem.text)
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
                                    .foregroundColor(FlatDesignSystem.accentOrange)
                                
                                // Show ticket indicator if ticket exists
                                if !stop.isStart && hasTicketForStop(stop) {
                                    Circle()
                                        .fill(FlatDesignSystem.accentGreen)
                                        .frame(width: 8, height: 8)
                                        .offset(x: 8, y: -8)
                                }
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                        .disabled(stop.isStart)
                    }
                }
                .padding(.vertical, FlatDesignSystem.paddingM)
                
                // Transport info - Below main content like in screenshot
                if !stop.isStart {
                    HStack {
                        Spacer()
                            .frame(width: 40 + FlatDesignSystem.paddingM) // Align with content above
                        
                        Button(action: {
                            onTicketTap(stop)
                        }) {
                            HStack(spacing: 8) {
                                // Transport icon - Pink/Orange like in screenshot
                                Image(systemName: stop.hasTrain ? "tram.fill" : (stop.hasFlight ? "airplane.departure" : "plus"))
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(FlatDesignSystem.accentOrange)
                                
                                Text(stop.flightDuration)
                                    .font(.system(size: 14, weight: .regular))
                                    .foregroundColor(FlatDesignSystem.textSecondary)
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        Spacer()
                    }
                    .padding(.bottom, FlatDesignSystem.paddingS)
                }
            }
        }
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
            duration: "5 Days",
            dates: "Sun 24 Mar - Fri 29 Mar",
            hasFlight: true,
            hasTrain: false,
            isStart: false,
            flightInfo: "Kuala Lumpur → Bangkok",
            flightDuration: "1h 45m",
            flightPrice: "€298",
            nights: 5
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
        PriceItem(id: 1, item: "Taichung Accommodation (4 nights)", price: 360),
        PriceItem(id: 2, item: "Taipei Accommodation (2 nights)", price: 180),
        PriceItem(id: 3, item: "Bali Accommodation (10 nights)", price: 650),
        PriceItem(id: 4, item: "Bangkok Accommodation (5 nights)", price: 400),
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
        dates: "Sun 24 Mar - Fri 29 Mar",
        nights: 5,
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
