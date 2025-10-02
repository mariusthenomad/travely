import Foundation
import CoreLocation

class PlacesManager: ObservableObject {
    @Published var searchResults: [PlaceResult] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    // Sample data for demonstration
    private let samplePlaces = [
        PlaceResult(id: "1", name: "Berlin", description: "Deutschland", placeID: "1"),
        PlaceResult(id: "2", name: "Paris", description: "Frankreich", placeID: "2"),
        PlaceResult(id: "3", name: "London", description: "Vereinigtes Königreich", placeID: "3"),
        PlaceResult(id: "4", name: "Rom", description: "Italien", placeID: "4"),
        PlaceResult(id: "5", name: "Madrid", description: "Spanien", placeID: "5"),
        PlaceResult(id: "6", name: "Amsterdam", description: "Niederlande", placeID: "6"),
        PlaceResult(id: "7", name: "Wien", description: "Österreich", placeID: "7"),
        PlaceResult(id: "8", name: "Zürich", description: "Schweiz", placeID: "8"),
        PlaceResult(id: "9", name: "Prag", description: "Tschechien", placeID: "9"),
        PlaceResult(id: "10", name: "Budapest", description: "Ungarn", placeID: "10"),
        PlaceResult(id: "11", name: "Warschau", description: "Polen", placeID: "11"),
        PlaceResult(id: "12", name: "Kopenhagen", description: "Dänemark", placeID: "12"),
        PlaceResult(id: "13", name: "Stockholm", description: "Schweden", placeID: "13"),
        PlaceResult(id: "14", name: "Oslo", description: "Norwegen", placeID: "14"),
        PlaceResult(id: "15", name: "Helsinki", description: "Finnland", placeID: "15"),
        PlaceResult(id: "16", name: "Dublin", description: "Irland", placeID: "16"),
        PlaceResult(id: "17", name: "Lissabon", description: "Portugal", placeID: "17"),
        PlaceResult(id: "18", name: "Athen", description: "Griechenland", placeID: "18"),
        PlaceResult(id: "19", name: "Istanbul", description: "Türkei", placeID: "19"),
        PlaceResult(id: "20", name: "Moskau", description: "Russland", placeID: "20"),
        PlaceResult(id: "21", name: "Tokio", description: "Japan", placeID: "21"),
        PlaceResult(id: "22", name: "Seoul", description: "Südkorea", placeID: "22"),
        PlaceResult(id: "23", name: "Peking", description: "China", placeID: "23"),
        PlaceResult(id: "24", name: "Bangkok", description: "Thailand", placeID: "24"),
        PlaceResult(id: "25", name: "Singapur", description: "Singapur", placeID: "25"),
        PlaceResult(id: "26", name: "Kuala Lumpur", description: "Malaysia", placeID: "26"),
        PlaceResult(id: "27", name: "Jakarta", description: "Indonesien", placeID: "27"),
        PlaceResult(id: "28", name: "Manila", description: "Philippinen", placeID: "28"),
        PlaceResult(id: "29", name: "Ho-Chi-Minh-Stadt", description: "Vietnam", placeID: "29"),
        PlaceResult(id: "30", name: "Mumbai", description: "Indien", placeID: "30"),
        PlaceResult(id: "31", name: "New York", description: "USA", placeID: "31"),
        PlaceResult(id: "32", name: "Los Angeles", description: "USA", placeID: "32"),
        PlaceResult(id: "33", name: "Chicago", description: "USA", placeID: "33"),
        PlaceResult(id: "34", name: "Toronto", description: "Kanada", placeID: "34"),
        PlaceResult(id: "35", name: "Vancouver", description: "Kanada", placeID: "35"),
        PlaceResult(id: "36", name: "Mexiko-Stadt", description: "Mexiko", placeID: "36"),
        PlaceResult(id: "37", name: "São Paulo", description: "Brasilien", placeID: "37"),
        PlaceResult(id: "38", name: "Buenos Aires", description: "Argentinien", placeID: "38"),
        PlaceResult(id: "39", name: "Santiago", description: "Chile", placeID: "39"),
        PlaceResult(id: "40", name: "Lima", description: "Peru", placeID: "40"),
        PlaceResult(id: "41", name: "Bogotá", description: "Kolumbien", placeID: "41"),
        PlaceResult(id: "42", name: "Caracas", description: "Venezuela", placeID: "42"),
        PlaceResult(id: "43", name: "Quito", description: "Ecuador", placeID: "43"),
        PlaceResult(id: "44", name: "La Paz", description: "Bolivien", placeID: "44"),
        PlaceResult(id: "45", name: "Asunción", description: "Paraguay", placeID: "45"),
        PlaceResult(id: "46", name: "Montevideo", description: "Uruguay", placeID: "46"),
        PlaceResult(id: "47", name: "Kairo", description: "Ägypten", placeID: "47"),
        PlaceResult(id: "48", name: "Kapstadt", description: "Südafrika", placeID: "48"),
        PlaceResult(id: "49", name: "Lagos", description: "Nigeria", placeID: "49"),
        PlaceResult(id: "50", name: "Nairobi", description: "Kenia", placeID: "50"),
        PlaceResult(id: "51", name: "Casablanca", description: "Marokko", placeID: "51"),
        PlaceResult(id: "52", name: "Tunis", description: "Tunesien", placeID: "52"),
        PlaceResult(id: "53", name: "Algier", description: "Algerien", placeID: "53"),
        PlaceResult(id: "54", name: "Tripolis", description: "Libyen", placeID: "54"),
        PlaceResult(id: "55", name: "Khartum", description: "Sudan", placeID: "55"),
        PlaceResult(id: "56", name: "Addis Abeba", description: "Äthiopien", placeID: "56"),
        PlaceResult(id: "57", name: "Accra", description: "Ghana", placeID: "57"),
        PlaceResult(id: "58", name: "Dar es Salaam", description: "Tansania", placeID: "58"),
        PlaceResult(id: "59", name: "Kampala", description: "Uganda", placeID: "59"),
        PlaceResult(id: "60", name: "Yaoundé", description: "Kamerun", placeID: "60"),
        PlaceResult(id: "61", name: "Abidjan", description: "Elfenbeinküste", placeID: "61"),
        PlaceResult(id: "62", name: "Antananarivo", description: "Madagaskar", placeID: "62"),
        PlaceResult(id: "63", name: "Maputo", description: "Mosambik", placeID: "63"),
        PlaceResult(id: "64", name: "Luanda", description: "Angola", placeID: "64"),
        PlaceResult(id: "65", name: "Sydney", description: "Australien", placeID: "65"),
        PlaceResult(id: "66", name: "Melbourne", description: "Australien", placeID: "66"),
        PlaceResult(id: "67", name: "Brisbane", description: "Australien", placeID: "67"),
        PlaceResult(id: "68", name: "Perth", description: "Australien", placeID: "68"),
        PlaceResult(id: "69", name: "Adelaide", description: "Australien", placeID: "69"),
        PlaceResult(id: "70", name: "Auckland", description: "Neuseeland", placeID: "70"),
        PlaceResult(id: "71", name: "Wellington", description: "Neuseeland", placeID: "71"),
        PlaceResult(id: "72", name: "Christchurch", description: "Neuseeland", placeID: "72"),
        PlaceResult(id: "73", name: "Suva", description: "Fidschi", placeID: "73"),
        PlaceResult(id: "74", name: "Port Moresby", description: "Papua-Neuguinea", placeID: "74"),
        PlaceResult(id: "75", name: "Apia", description: "Samoa", placeID: "75"),
        PlaceResult(id: "76", name: "Nuku'alofa", description: "Tonga", placeID: "76"),
        PlaceResult(id: "77", name: "Port Vila", description: "Vanuatu", placeID: "77"),
        PlaceResult(id: "78", name: "Honiara", description: "Salomonen", placeID: "78"),
        PlaceResult(id: "79", name: "Tarawa", description: "Kiribati", placeID: "79"),
        PlaceResult(id: "80", name: "Funafuti", description: "Tuvalu", placeID: "80")
    ]
    
    init() {
        // Sample implementation without Google Places API
    }
    
    func searchPlaces(query: String, type: PlaceType = .all) {
        guard !query.isEmpty else {
            searchResults = []
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.isLoading = false
            
            let filtered = self.samplePlaces.filter { place in
                place.name.localizedCaseInsensitiveContains(query) ||
                place.description.localizedCaseInsensitiveContains(query)
            }
            
            self.searchResults = Array(filtered.prefix(10)) // Limit to 10 results
        }
    }
    
    func getPlaceDetails(placeID: String, completion: @escaping (PlaceDetails?) -> Void) {
        // Simulate getting place details
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            if let place = self.samplePlaces.first(where: { $0.placeID == placeID }) {
                let details = PlaceDetails(
                    placeID: place.placeID,
                    name: place.name,
                    address: place.description,
                    coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0),
                    types: []
                )
                completion(details)
            } else {
                completion(nil)
            }
        }
    }
}

enum PlaceType {
    case country
    case city
    case all
}

struct PlaceResult: Identifiable, Hashable {
    let id: String
    let name: String
    let description: String
    let placeID: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: PlaceResult, rhs: PlaceResult) -> Bool {
        lhs.id == rhs.id
    }
}

struct PlaceDetails {
    let placeID: String
    let name: String
    let address: String
    let coordinate: CLLocationCoordinate2D
    let types: [String]
    
    var isCountry: Bool {
        types.contains("country")
    }
    
    var isCity: Bool {
        types.contains("locality") || types.contains("administrative_area_level_1")
    }
    
    var countryName: String {
        // Extrahiere den Ländernamen aus der Adresse
        let components = address.components(separatedBy: ",")
        return components.last?.trimmingCharacters(in: .whitespaces) ?? ""
    }
    
    var cityName: String {
        // Extrahiere den Städtenamen aus der Adresse
        let components = address.components(separatedBy: ",")
        return components.first?.trimmingCharacters(in: .whitespaces) ?? name
    }
}
