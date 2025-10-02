import SwiftUI
import Combine

class ThemeManager: ObservableObject {
    @Published var isDarkMode: Bool = false {
        didSet {
            UserDefaults.standard.set(isDarkMode, forKey: "isDarkMode")
        }
    }
    
    init() {
        self.isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
    }
    
    var primaryColor: Color {
        Color(red: 1.0, green: 0.4, blue: 0.2) // Orange
    }
    
    var backgroundColor: Color {
        isDarkMode ? Color.black : Color.white
    }
    
    var secondaryBackgroundColor: Color {
        isDarkMode ? Color(red: 0.10, green: 0.10, blue: 0.10) : Color.gray.opacity(0.05)
    }
    
    var cardBackgroundColor: Color {
        isDarkMode ? Color(red: 0.15, green: 0.15, blue: 0.15) : Color.white
    }
    
    var textColor: Color {
        Color(red: 0.2, green: 0.2, blue: 0.2) // Dark gray for light mode
    }
    
    var secondaryTextColor: Color {
        Color(red: 0.5, green: 0.5, blue: 0.5) // Medium gray for light mode
    }
    
    var destinationTextColor: Color {
        Color(red: 1.0, green: 0.4, blue: 0.2) // Orange
    }
    
    var shadowColor: Color {
        Color.black.opacity(0.05) // Light shadow for light mode
    }
    
    // OLED-optimierte Farben für maximale Stromersparnis
    var oledBackgroundColor: Color {
        isDarkMode ? Color.black : Color.white
    }
    
    var oledCardBackgroundColor: Color {
        Color.white // White for light mode
    }
    
    var oledSecondaryBackgroundColor: Color {
        isDarkMode ? Color(red: 0.08, green: 0.08, blue: 0.08) : Color.gray.opacity(0.05)
    }
}
