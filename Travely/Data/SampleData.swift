import Foundation

// MARK: - Sample Data Manager
class SampleDataManager {
    static let shared = SampleDataManager()
    private init() {}
    
    // MARK: - Travel Routes
    lazy var featuredRoute: TravelRoute = {
        TravelRoute(
            id: 1,
            title: "Asia Adventure",
            description: "Experience the best of Taiwan and Southeast Asia with this amazing 21-day journey through Taichung, Taipei, Bali, and Bangkok.",
            duration: "21 Days",
            totalPrice: 3488,
            imageURL: "https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=600&h=400&fit=crop&crop=center",
            stops: routeStops,
            priceBreakdown: priceBreakdown
        )
    }()
    
    // MARK: - Route Stops
    private lazy var routeStops: [RouteStop] = {
        [
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
                duration: "10 Days",
                dates: "Wed 13 Mar - Sat 23 Mar",
                hasFlight: true,
                hasTrain: false,
                isStart: false,
                flightInfo: "Taipei → Bali",
                flightDuration: "5h 30m",
                flightPrice: "€445",
                nights: 10
            ),
            RouteStop(
                id: 6,
                destination: "Kuala Lumpur",
                country: "Malaysia",
                countryEmoji: "🇲🇾",
                duration: "1 Day",
                dates: "Sat 23 Mar - Sun 24 Mar",
                hasFlight: true,
                hasTrain: false,
                isStart: false,
                flightInfo: "Bali → Kuala Lumpur",
                flightDuration: "2h 15m",
                flightPrice: "€198",
                nights: 1
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
                dates: "Fri 29 Mar - Return",
                hasFlight: true,
                hasTrain: false,
                isStart: false,
                flightInfo: "Bangkok → Munich",
                flightDuration: "11h 30m",
                flightPrice: "€589",
                nights: 0
            )
        ]
    }()
    
    // MARK: - Price Breakdown
    private lazy var priceBreakdown: [PriceItem] = {
        [
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
    }()
    
    // MARK: - Accommodations
    lazy var accommodations: [Stay] = {
        [
            Stay(
                id: 1,
                name: "Taichung City Hotel",
                location: "Taichung, Taiwan",
                countryEmoji: "🇹🇼",
                dates: "Thu 07 Mar - Mon 11 Mar",
                nights: 4,
                price: 360,
                rating: 4.2,
                imageURL: "https://images.unsplash.com/photo-1566073771259-6a8506099945?w=400&h=300&fit=crop",
                amenities: ["WiFi", "Pool", "Gym", "Restaurant"],
                description: "Modern hotel in the heart of Taichung with excellent city views and convenient access to public transportation."
            ),
            Stay(
                id: 2,
                name: "Taipei Boutique Hotel",
                location: "Taipei, Taiwan",
                countryEmoji: "🇹🇼",
                dates: "Mon 11 Mar - Wed 13 Mar",
                nights: 2,
                price: 180,
                rating: 4.5,
                imageURL: "https://images.unsplash.com/photo-1571896349842-33c89424de2d?w=400&h=300&fit=crop",
                amenities: ["WiFi", "Breakfast", "Concierge"],
                description: "Charming boutique hotel in Taipei's historic district with traditional Taiwanese architecture."
            ),
            Stay(
                id: 3,
                name: "Bali Resort & Spa",
                location: "Ubud, Bali",
                countryEmoji: "🇮🇩",
                dates: "Wed 13 Mar - Sat 23 Mar",
                nights: 10,
                price: 650,
                rating: 4.8,
                imageURL: "https://images.unsplash.com/photo-1571896349842-33c89424de2d?w=400&h=300&fit=crop",
                amenities: ["WiFi", "Pool", "Spa", "Restaurant", "Beach Access"],
                description: "Luxury resort in Ubud with stunning rice terrace views, world-class spa, and authentic Balinese experiences."
            ),
            Stay(
                id: 4,
                name: "Bangkok City Hotel",
                location: "Bangkok, Thailand",
                countryEmoji: "🇹🇭",
                dates: "Sun 24 Mar - Fri 29 Mar",
                nights: 5,
                price: 400,
                rating: 4.3,
                imageURL: "https://images.unsplash.com/photo-1566073771259-6a8506099945?w=400&h=300&fit=crop",
                amenities: ["WiFi", "Pool", "Gym", "Restaurant", "Rooftop Bar"],
                description: "Contemporary hotel in Bangkok's business district with panoramic city views and excellent dining options."
            )
        ]
    }()
    
    // MARK: - Popular Destinations
    lazy var popularDestinations: [Destination] = {
        [
            Destination(
                id: 1,
                name: "Tokyo",
                country: "Japan",
                countryEmoji: "🇯🇵",
                imageURL: "https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=400&h=300&fit=crop",
                description: "Modern metropolis blending traditional culture with cutting-edge technology",
                rating: 4.7,
                priceRange: "€€€"
            ),
            Destination(
                id: 2,
                name: "Paris",
                country: "France",
                countryEmoji: "🇫🇷",
                imageURL: "https://images.unsplash.com/photo-1502602898536-47ad22581b52?w=400&h=300&fit=crop",
                description: "City of Light with world-class art, cuisine, and romantic atmosphere",
                rating: 4.6,
                priceRange: "€€€"
            ),
            Destination(
                id: 3,
                name: "Bali",
                country: "Indonesia",
                countryEmoji: "🇮🇩",
                imageURL: "https://images.unsplash.com/photo-1537953773345-d172ccf13cf1?w=400&h=300&fit=crop",
                description: "Tropical paradise with stunning beaches, temples, and vibrant culture",
                rating: 4.8,
                priceRange: "€€"
            ),
            Destination(
                id: 4,
                name: "New York",
                country: "USA",
                countryEmoji: "🇺🇸",
                imageURL: "https://images.unsplash.com/photo-1563492065-1a120d5d8b96?w=400&h=300&fit=crop",
                description: "The Big Apple - never sleeps with endless entertainment and iconic landmarks",
                rating: 4.5,
                priceRange: "€€€€"
            ),
            Destination(
                id: 5,
                name: "Barcelona",
                country: "Spain",
                countryEmoji: "🇪🇸",
                imageURL: "https://images.unsplash.com/photo-1502602898536-47ad22581b52?w=400&h=300&fit=crop",
                description: "Architectural marvels, Mediterranean beaches, and vibrant nightlife",
                rating: 4.6,
                priceRange: "€€€"
            ),
            Destination(
                id: 6,
                name: "Sydney",
                country: "Australia",
                countryEmoji: "🇦🇺",
                imageURL: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400&h=300&fit=crop",
                description: "Harbor city with iconic Opera House and stunning coastal scenery",
                rating: 4.7,
                priceRange: "€€€€"
            )
        ]
    }()
    
    // MARK: - Quick Actions
    lazy var quickActions: [QuickAction] = {
        [
            QuickAction(
                id: 1,
                title: "Plan Route",
                subtitle: "Create your journey",
                icon: "map.fill",
                color: .orange,
                action: .planRoute
            ),
            QuickAction(
                id: 2,
                title: "Find Flights",
                subtitle: "Search & book",
                icon: "airplane",
                color: .blue,
                action: .findFlights
            ),
            QuickAction(
                id: 3,
                title: "Book Hotel",
                subtitle: "Best deals",
                icon: "bed.double.fill",
                color: .green,
                action: .bookHotel
            ),
            QuickAction(
                id: 4,
                title: "Explore",
                subtitle: "Discover places",
                icon: "globe.americas.fill",
                color: .purple,
                action: .explore
            )
        ]
    }()
}

// MARK: - Additional Models
struct Destination: Identifiable {
    let id: Int
    let name: String
    let country: String
    let countryEmoji: String
    let imageURL: String
    let description: String
    let rating: Double
    let priceRange: String
}

struct Stay: Identifiable {
    let id: Int
    let name: String
    let location: String
    let countryEmoji: String
    let dates: String
    let nights: Int
    let price: Int
    let rating: Double
    let imageURL: String
    let amenities: [String]
    let description: String
}

struct QuickAction: Identifiable {
    let id: Int
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let action: QuickActionType
}

enum QuickActionType {
    case planRoute
    case findFlights
    case bookHotel
    case explore
}
