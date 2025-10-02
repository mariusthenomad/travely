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
                .padding(.bottom, 16)
                
                ScrollView {
                    VStack(spacing: 24) {
                    // Notifications Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Notifications")
                            .font(.custom("Inter", size: 20))
                            .fontWeight(.semibold)
                            .foregroundColor(themeManager.textColor)
                            .padding(.horizontal, 20)
                        
                        VStack(spacing: 12) {
                            ToggleRow(
                                icon: "bell.fill",
                                title: "Notifications",
                                isOn: $notificationsEnabled
                            )
                            
                            if notificationsEnabled {
                                ToggleRow(
                                    icon: "envelope.fill",
                                    title: "Email Notifications",
                                    isOn: $emailNotifications
                                )
                                
                                ToggleRow(
                                    icon: "iphone",
                                    title: "Push Notifications",
                                    isOn: $pushNotifications
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    // Preferences Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Preferences")
                            .font(.custom("Inter", size: 20))
                            .fontWeight(.semibold)
                            .foregroundColor(themeManager.textColor)
                            .padding(.horizontal, 20)
                        
                        VStack(spacing: 12) {
                            SelectionRow(
                                icon: "globe",
                                title: "Language",
                                value: selectedLanguage,
                                action: {}
                            )
                            
                            SelectionRow(
                                icon: "dollarsign.circle",
                                title: "Currency",
                                value: currency,
                                action: {}
                            )
                            
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
                            
                            ToggleRow(
                                icon: "chart.bar.fill",
                                title: "Analytics",
                                isOn: $analyticsEnabled
                            )
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    // Account Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Account")
                            .font(.custom("Inter", size: 20))
                            .fontWeight(.semibold)
                            .foregroundColor(themeManager.textColor)
                            .padding(.horizontal, 20)
                        
                        VStack(spacing: 12) {
                            InfoRow(
                                icon: "person.fill",
                                title: "Account Information"
                            )
                            
                            InfoRow(
                                icon: "lock.fill",
                                title: "Privacy & Security"
                            )
                            
                            InfoRow(
                                icon: "questionmark.circle.fill",
                                title: "Help & Support"
                            )
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    // Actions Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Actions")
                            .font(.custom("Inter", size: 20))
                            .fontWeight(.semibold)
                            .foregroundColor(themeManager.textColor)
                            .padding(.horizontal, 20)
                        
                        VStack(spacing: 12) {
                            ActionRow(
                                icon: "arrow.clockwise",
                                title: "Reset Settings",
                                action: resetSettings
                            )
                            
                            ActionRow(
                                icon: "trash.fill",
                                title: "Delete Account",
                                action: {},
                                isDestructive: true
                            )
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    // Dark Mode Toggle
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Appearance")
                            .font(.custom("Inter", size: 20))
                            .fontWeight(.semibold)
                            .foregroundColor(themeManager.textColor)
                            .padding(.horizontal, 20)
                        
                        VStack(spacing: 12) {
                            ToggleRow(
                                icon: "moon.fill",
                                title: "Dark Mode",
                                isOn: $themeManager.isDarkMode
                            )
                        }
                        .padding(.horizontal, 20)
                    }
                    }
                    .padding(.bottom, 20)
                }
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    private func resetSettings() {
        notificationsEnabled = true
        emailNotifications = true
        pushNotifications = true
        selectedLanguage = "English"
        currency = "USD"
        themeManager.isDarkMode = false
        biometricAuth = false
        locationServices = true
        analyticsEnabled = true
    }
}

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
        .frame(height: 60)
        .padding(.horizontal, 12)
        .background(themeManager.oledCardBackgroundColor)
        .cornerRadius(12)
        .shadow(color: themeManager.shadowColor, radius: 4, x: 0, y: 2)
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
                
                HStack(spacing: 8) {
                    Text(value)
                        .font(.custom("Inter", size: 16))
                        .foregroundColor(themeManager.secondaryTextColor)
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(themeManager.secondaryTextColor)
                        .font(.system(size: 12))
                }
            }
            .frame(height: 60)
            .padding(.horizontal, 12)
            .background(themeManager.oledCardBackgroundColor)
            .cornerRadius(12)
            .shadow(color: themeManager.shadowColor, radius: 4, x: 0, y: 2)
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
            .frame(height: 60)
            .padding(.horizontal, 12)
            .background(themeManager.oledCardBackgroundColor)
            .cornerRadius(12)
            .shadow(color: themeManager.shadowColor, radius: 4, x: 0, y: 2)
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
            
            Image(systemName: "chevron.right")
                .foregroundColor(themeManager.secondaryTextColor)
                .font(.system(size: 12))
        }
        .frame(height: 60)
        .padding(.horizontal, 12)
        .background(themeManager.oledCardBackgroundColor)
        .cornerRadius(12)
        .shadow(color: themeManager.shadowColor, radius: 4, x: 0, y: 2)
    }
}

struct PickerSheet: View {
    @EnvironmentObject var themeManager: ThemeManager
    let title: String
    let options: [String]
    @Binding var selectedValue: String
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            List(options, id: \.self) { option in
                Button(action: {
                    selectedValue = option
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Text(option)
                            .font(.custom("Inter", size: 16))
                            .foregroundColor(themeManager.textColor)
                        
                        Spacer()
                        
                        if selectedValue == option {
                            Image(systemName: "checkmark")
                                .foregroundColor(themeManager.primaryColor)
                        }
                    }
                    .padding(.vertical, 8)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

#Preview {
    AppSettingsView()
        .environmentObject(ThemeManager())
}
