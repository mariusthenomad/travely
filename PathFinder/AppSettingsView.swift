import SwiftUI

struct AppSettingsView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @State private var notificationsEnabled = true
    @State private var emailNotifications = true
    @State private var pushNotifications = true
    @State private var selectedLanguage = "English"
    @State private var currency = "USD"
    @State private var biometricAuth = false
    @State private var locationServices = true
    @State private var analyticsEnabled = true
    @State private var showingLanguageMenu = false
    @State private var showingCurrencyMenu = false
    @State private var showingNotificationSettings = false
    @State private var showingAccountSettings = false
    @State private var showingPrivacySettings = false
    @State private var showingHelpSettings = false
    
    let languages = ["English", "Spanish", "French", "German", "Italian", "Portuguese"]
    let currencies = ["USD", "EUR", "GBP", "JPY", "CAD", "AUD"]
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient like flights
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.white,
                        Color(red: 1.0, green: 0.95, blue: 0.9) // Light peach/pink
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                // Custom Header
                HStack {
                    Text("Settings")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
                .padding(.bottom, 12)
                
                ScrollView {
                    VStack(spacing: 12) {
                    // Main Settings Menu
                    VStack(spacing: 8) {
                        MenuButtonRow(
                            icon: "bell.fill",
                            title: "Notifications",
                            subtitle: "Manage your alerts",
                            action: { showingNotificationSettings = true }
                        )
                        
                        MenuButtonRow(
                            icon: "lock.fill",
                            title: "Privacy",
                            subtitle: "Control your data",
                            action: { showingPrivacySettings = true }
                        )
                        
                        MenuButtonRow(
                            icon: "questionmark.circle.fill",
                            title: "Help & Support",
                            subtitle: "Get assistance",
                            action: { showingHelpSettings = true }
                        )
                    }
                    .padding(.horizontal, 20)
                    }
                }
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showingNotificationSettings) {
                NotificationSettingsView(
                    notificationsEnabled: $notificationsEnabled,
                    emailNotifications: $emailNotifications,
                    pushNotifications: $pushNotifications
                )
            }
            .sheet(isPresented: $showingAccountSettings) {
                AccountSettingsView()
            }
            .sheet(isPresented: $showingPrivacySettings) {
                PrivacySettingsView(
                    biometricAuth: $biometricAuth,
                    locationServices: $locationServices,
                    analyticsEnabled: $analyticsEnabled
                )
            }
            .sheet(isPresented: $showingLanguageMenu) {
                LanguageRegionView(
                    selectedLanguage: $selectedLanguage,
                    currency: $currency,
                    languages: languages,
                    currencies: currencies
                )
            }
            .sheet(isPresented: $showingHelpSettings) {
                HelpSupportView()
            }
        }
    }
}

// MARK: - Main Menu Button Row
struct MenuButtonRow: View {
    @EnvironmentObject var themeManager: ThemeManager
    let icon: String
    let title: String
    let subtitle: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .foregroundColor(themeManager.primaryColor)
                    .font(.system(size: 20))
                    .frame(width: 28)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.custom("Inter", size: 16))
                        .fontWeight(.semibold)
                        .foregroundColor(themeManager.textColor)
                    
                    Text(subtitle)
                        .font(.custom("Inter", size: 14))
                        .foregroundColor(themeManager.secondaryTextColor)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(themeManager.secondaryTextColor)
                    .font(.system(size: 12))
            }
            .frame(height: 56)
            .padding(.horizontal, 16)
            .background(themeManager.oledCardBackgroundColor)
            .cornerRadius(12)
            .shadow(color: themeManager.shadowColor, radius: 3, x: 0, y: 1)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Notification Settings Submenu
struct NotificationSettingsView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @Binding var notificationsEnabled: Bool
    @Binding var emailNotifications: Bool
    @Binding var pushNotifications: Bool
    @State private var flightAlerts = true
    @State private var hotelAlerts = true
    @State private var priceAlerts = true
    @State private var travelReminders = true
    @State private var marketingEmails = false
    @State private var soundEnabled = true
    @State private var vibrationEnabled = true
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ZStack {
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
                    VStack(spacing: 16) {
                        // General Notifications
                        VStack(alignment: .leading, spacing: 8) {
                            Text("General")
                                .font(.custom("Inter", size: 18))
                                .fontWeight(.semibold)
                                .foregroundColor(themeManager.textColor)
                                .padding(.horizontal, 20)
                            
                            VStack(spacing: 4) {
                                ToggleRow(
                                    icon: "bell.fill",
                                    title: "Push Notifications",
                                    isOn: $notificationsEnabled
                                )
                                
                                ToggleRow(
                                    icon: "envelope.fill",
                                    title: "Email Notifications",
                                    isOn: $emailNotifications
                                )
                                
                                ToggleRow(
                                    icon: "speaker.wave.2.fill",
                                    title: "Sound",
                                    isOn: $soundEnabled
                                )
                                
                                ToggleRow(
                                    icon: "iphone.radiowaves.left.and.right",
                                    title: "Vibration",
                                    isOn: $vibrationEnabled
                                )
                            }
                            .padding(.horizontal, 20)
                        }
                        
                        // Travel Alerts
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Travel Alerts")
                                .font(.custom("Inter", size: 18))
                                .fontWeight(.semibold)
                                .foregroundColor(themeManager.textColor)
                                .padding(.horizontal, 20)
                            
                            VStack(spacing: 4) {
                                ToggleRow(
                                    icon: "airplane",
                                    title: "Flight Updates",
                                    isOn: $flightAlerts
                                )
                                
                                ToggleRow(
                                    icon: "bed.double.fill",
                                    title: "Hotel Confirmations",
                                    isOn: $hotelAlerts
                                )
                                
                                ToggleRow(
                                    icon: "tag.fill",
                                    title: "Price Alerts",
                                    isOn: $priceAlerts
                                )
                                
                                ToggleRow(
                                    icon: "calendar",
                                    title: "Travel Reminders",
                                    isOn: $travelReminders
                                )
                            }
                            .padding(.horizontal, 20)
                        }
                        
                        // Marketing
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Marketing")
                                .font(.custom("Inter", size: 18))
                                .fontWeight(.semibold)
                                .foregroundColor(themeManager.textColor)
                                .padding(.horizontal, 20)
                            
                            VStack(spacing: 4) {
                                ToggleRow(
                                    icon: "megaphone.fill",
                                    title: "Promotional Emails",
                                    isOn: $marketingEmails
                                )
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                    .padding(.top, 20)
                }
            }
            .navigationTitle("Notifications")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

// MARK: - Account Settings Submenu
struct AccountSettingsView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ZStack {
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
                    VStack(spacing: 12) {
                        VStack(spacing: 8) {
                            ActionRow(
                                icon: "person.circle.fill",
                                title: "Edit Profile",
                                action: {}
                            )
                            
                            ActionRow(
                                icon: "key.fill",
                                title: "Change Password",
                                action: {}
                            )
                            
                            ActionRow(
                                icon: "envelope.fill",
                                title: "Email Settings",
                                action: {}
                            )
                            
                            ActionRow(
                                icon: "square.and.arrow.down",
                                title: "Export Data",
                                action: {}
                            )
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding(.top, 20)
                }
            }
            .navigationTitle("Account")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

// MARK: - Privacy Settings Submenu
struct PrivacySettingsView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @Binding var biometricAuth: Bool
    @Binding var locationServices: Bool
    @Binding var analyticsEnabled: Bool
    @State private var dataCollection = true
    @State private var personalizedAds = false
    @State private var crashReporting = true
    @State private var usageAnalytics = true
    @State private var shareDataWithPartners = false
    @State private var autoDeleteData = false
    @State private var dataRetentionDays = 30
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ZStack {
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
                    VStack(spacing: 16) {
                        // Security
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Security")
                                .font(.custom("Inter", size: 18))
                                .fontWeight(.semibold)
                                .foregroundColor(themeManager.textColor)
                                .padding(.horizontal, 20)
                            
                            VStack(spacing: 4) {
                                ToggleRow(
                                    icon: "faceid",
                                    title: "Biometric Authentication",
                                    isOn: $biometricAuth
                                )
                                
                                ToggleRow(
                                    icon: "location.fill",
                                    title: "Location Services",
                                    isOn: $locationServices
                                )
                                
                                ActionRow(
                                    icon: "key.fill",
                                    title: "Change Password",
                                    action: {}
                                )
                                
                                ActionRow(
                                    icon: "shield.checkered",
                                    title: "Two-Factor Authentication",
                                    action: {}
                                )
                            }
                            .padding(.horizontal, 20)
                        }
                        
                        // Data Collection
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Data Collection")
                                .font(.custom("Inter", size: 18))
                                .fontWeight(.semibold)
                                .foregroundColor(themeManager.textColor)
                                .padding(.horizontal, 20)
                            
                            VStack(spacing: 4) {
                                ToggleRow(
                                    icon: "chart.bar.fill",
                                    title: "Usage Analytics",
                                    isOn: $usageAnalytics
                                )
                                
                                ToggleRow(
                                    icon: "exclamationmark.triangle.fill",
                                    title: "Crash Reporting",
                                    isOn: $crashReporting
                                )
                                
                                ToggleRow(
                                    icon: "person.2.fill",
                                    title: "Share with Partners",
                                    isOn: $shareDataWithPartners
                                )
                                
                                ToggleRow(
                                    icon: "target",
                                    title: "Personalized Ads",
                                    isOn: $personalizedAds
                                )
                            }
                            .padding(.horizontal, 20)
                        }
                        
                        // Data Management
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Data Management")
                                .font(.custom("Inter", size: 18))
                                .fontWeight(.semibold)
                                .foregroundColor(themeManager.textColor)
                                .padding(.horizontal, 20)
                            
                            VStack(spacing: 4) {
                                ToggleRow(
                                    icon: "trash.fill",
                                    title: "Auto-Delete Data",
                                    isOn: $autoDeleteData
                                )
                                
                                ActionRow(
                                    icon: "square.and.arrow.down",
                                    title: "Export My Data",
                                    action: {}
                                )
                                
                                ActionRow(
                                    icon: "trash.circle.fill",
                                    title: "Delete All Data",
                                    action: {},
                                    isDestructive: true
                                )
                            }
                            .padding(.horizontal, 20)
                        }
                        
                        // Legal
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Legal")
                                .font(.custom("Inter", size: 18))
                                .fontWeight(.semibold)
                                .foregroundColor(themeManager.textColor)
                                .padding(.horizontal, 20)
                            
                            VStack(spacing: 4) {
                                ActionRow(
                                    icon: "hand.raised.fill",
                                    title: "Privacy Policy",
                                    action: {}
                                )
                                
                                ActionRow(
                                    icon: "doc.text.fill",
                                    title: "Terms of Service",
                                    action: {}
                                )
                                
                                ActionRow(
                                    icon: "info.circle.fill",
                                    title: "About PathFinder",
                                    action: {}
                                )
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                    .padding(.top, 20)
                }
            }
            .navigationTitle("Privacy")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

// MARK: - Language & Region Submenu
struct LanguageRegionView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @Binding var selectedLanguage: String
    @Binding var currency: String
    let languages: [String]
    let currencies: [String]
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ZStack {
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
                    VStack(spacing: 16) {
                        // Language Section
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Language")
                                .font(.custom("Inter", size: 18))
                                .fontWeight(.semibold)
                                .foregroundColor(themeManager.textColor)
                                .padding(.horizontal, 20)
                            
                            VStack(spacing: 4) {
                                ForEach(languages, id: \.self) { language in
                                    SelectionRow(
                                        icon: "globe",
                                        title: language,
                                        value: selectedLanguage == language ? "✓" : "",
                                        action: { selectedLanguage = language }
                                    )
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                        
                        // Currency Section
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Currency")
                                .font(.custom("Inter", size: 18))
                                .fontWeight(.semibold)
                                .foregroundColor(themeManager.textColor)
                                .padding(.horizontal, 20)
                            
                            VStack(spacing: 4) {
                                ForEach(currencies, id: \.self) { currencyOption in
                                    SelectionRow(
                                        icon: "dollarsign.circle",
                                        title: currencyOption,
                                        value: currency == currencyOption ? "✓" : "",
                                        action: { currency = currencyOption }
                                    )
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                    .padding(.top, 20)
                }
            }
            .navigationTitle("Language & Region")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

// MARK: - Help & Support Submenu
struct HelpSupportView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ZStack {
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
                    VStack(spacing: 16) {
                        // Get Help
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Get Help")
                                .font(.custom("Inter", size: 18))
                                .fontWeight(.semibold)
                                .foregroundColor(themeManager.textColor)
                                .padding(.horizontal, 20)
                            
                            VStack(spacing: 4) {
                                ActionRow(
                                    icon: "questionmark.circle.fill",
                                    title: "FAQ",
                                    action: {}
                                )
                                
                                ActionRow(
                                    icon: "message.fill",
                                    title: "Contact Support",
                                    action: {}
                                )
                                
                                ActionRow(
                                    icon: "phone.fill",
                                    title: "Call Support",
                                    action: {}
                                )
                                
                                ActionRow(
                                    icon: "envelope.fill",
                                    title: "Email Support",
                                    action: {}
                                )
                            }
                            .padding(.horizontal, 20)
                        }
                        
                        // Resources
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Resources")
                                .font(.custom("Inter", size: 18))
                                .fontWeight(.semibold)
                                .foregroundColor(themeManager.textColor)
                                .padding(.horizontal, 20)
                            
                            VStack(spacing: 4) {
                                ActionRow(
                                    icon: "book.fill",
                                    title: "User Guide",
                                    action: {}
                                )
                                
                                ActionRow(
                                    icon: "play.rectangle.fill",
                                    title: "Video Tutorials",
                                    action: {}
                                )
                                
                                ActionRow(
                                    icon: "person.3.fill",
                                    title: "Community Forum",
                                    action: {}
                                )
                                
                                ActionRow(
                                    icon: "star.fill",
                                    title: "Rate PathFinder",
                                    action: {}
                                )
                            }
                            .padding(.horizontal, 20)
                        }
                        
                        // App Info
                        VStack(alignment: .leading, spacing: 8) {
                            Text("App Information")
                                .font(.custom("Inter", size: 18))
                                .fontWeight(.semibold)
                                .foregroundColor(themeManager.textColor)
                                .padding(.horizontal, 20)
                            
                            VStack(spacing: 4) {
                                InfoRow(
                                    icon: "info.circle.fill",
                                    title: "Version 1.0.0"
                                )
                                
                                InfoRow(
                                    icon: "calendar",
                                    title: "Last Updated: Oct 4, 2024"
                                )
                                
                                ActionRow(
                                    icon: "arrow.clockwise",
                                    title: "Check for Updates",
                                    action: {}
                                )
                                
                                ActionRow(
                                    icon: "arrow.down.circle.fill",
                                    title: "What's New",
                                    action: {}
                                )
                            }
                            .padding(.horizontal, 20)
                        }
                        
                        // Feedback
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Feedback")
                                .font(.custom("Inter", size: 18))
                                .fontWeight(.semibold)
                                .foregroundColor(themeManager.textColor)
                                .padding(.horizontal, 20)
                            
                            VStack(spacing: 4) {
                                ActionRow(
                                    icon: "exclamationmark.bubble.fill",
                                    title: "Report a Bug",
                                    action: {}
                                )
                                
                                ActionRow(
                                    icon: "lightbulb.fill",
                                    title: "Suggest a Feature",
                                    action: {}
                                )
                                
                                ActionRow(
                                    icon: "heart.fill",
                                    title: "Send Feedback",
                                    action: {}
                                )
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                    .padding(.top, 20)
                }
            }
            .navigationTitle("Help & Support")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

// MARK: - Existing Row Components
struct ToggleRow: View {
    @EnvironmentObject var themeManager: ThemeManager
    let icon: String
    let title: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .foregroundColor(themeManager.primaryColor)
                .font(.system(size: 18))
                .frame(width: 24)
            
            Text(title)
                .font(.custom("Inter", size: 16))
                .fontWeight(.medium)
                .foregroundColor(themeManager.textColor)
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .tint(themeManager.primaryColor)
        }
        .frame(height: 52)
        .padding(.horizontal, 12)
        .background(themeManager.oledCardBackgroundColor)
        .cornerRadius(10)
        .shadow(color: themeManager.shadowColor, radius: 3, x: 0, y: 1)
    }
}

struct SelectionRow: View {
    @EnvironmentObject var themeManager: ThemeManager
    let icon: String
    let title: String
    let value: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .foregroundColor(themeManager.primaryColor)
                    .font(.system(size: 18))
                    .frame(width: 24)
                
                Text(title)
                    .font(.custom("Inter", size: 16))
                    .fontWeight(.medium)
                    .foregroundColor(themeManager.textColor)
                
                Spacer()
                
                if !value.isEmpty {
                    Text(value)
                        .font(.custom("Inter", size: 16))
                        .foregroundColor(themeManager.primaryColor)
                        .fontWeight(.semibold)
                }
            }
            .frame(height: 52)
            .padding(.horizontal, 12)
            .background(themeManager.oledCardBackgroundColor)
            .cornerRadius(10)
            .shadow(color: themeManager.shadowColor, radius: 3, x: 0, y: 1)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct ActionRow: View {
    @EnvironmentObject var themeManager: ThemeManager
    let icon: String
    let title: String
    let action: () -> Void
    var isDestructive: Bool = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .foregroundColor(isDestructive ? .red : themeManager.primaryColor)
                    .font(.system(size: 18))
                    .frame(width: 24)
                
                Text(title)
                    .font(.custom("Inter", size: 16))
                    .fontWeight(.medium)
                    .foregroundColor(isDestructive ? .red : themeManager.textColor)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(themeManager.secondaryTextColor)
                    .font(.system(size: 12))
            }
            .frame(height: 52)
            .padding(.horizontal, 12)
            .background(themeManager.oledCardBackgroundColor)
            .cornerRadius(10)
            .shadow(color: themeManager.shadowColor, radius: 3, x: 0, y: 1)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct InfoRow: View {
    @EnvironmentObject var themeManager: ThemeManager
    let icon: String
    let title: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .foregroundColor(themeManager.primaryColor)
                .font(.system(size: 18))
                .frame(width: 24)
            
            Text(title)
                .font(.custom("Inter", size: 16))
                .fontWeight(.medium)
                .foregroundColor(themeManager.textColor)
            
            Spacer()
        }
        .frame(height: 52)
        .padding(.horizontal, 12)
        .background(themeManager.oledCardBackgroundColor)
        .cornerRadius(10)
        .shadow(color: themeManager.shadowColor, radius: 3, x: 0, y: 1)
    }
}