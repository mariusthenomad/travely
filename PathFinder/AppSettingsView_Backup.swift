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
                                subtitle: "Receive app notifications",
                                isOn: $notificationsEnabled
                            )
                            
                            if notificationsEnabled {
                                ToggleRow(
                                    icon: "envelope.fill",
                                    title: "Email Notifications",
                                    subtitle: "Get updates via email",
                                    isOn: $emailNotifications
                                )
                                
                                ToggleRow(
                                    icon: "iphone",
                                    title: "Push Notifications",
                                    subtitle: "Receive push notifications",
                                    isOn: $pushNotifications
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    // App Preferences Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("App Preferences")
                            .font(.custom("Inter", size: 20))
                            .fontWeight(.semibold)
                            .foregroundColor(themeManager.textColor)
                            .padding(.horizontal, 20)
                        
                        VStack(spacing: 12) {
                            SelectionRow(
                                icon: "globe",
                                title: "Language",
                                value: selectedLanguage,
                                options: languages,
                                selectedValue: $selectedLanguage
                            )
                            
                            SelectionRow(
                                icon: "dollarsign.circle.fill",
                                title: "Currency",
                                value: currency,
                                options: currencies,
                                selectedValue: $currency
                            )
                            
                            ToggleRow(
                                icon: "moon.fill",
                                title: "Dark Mode",
                                subtitle: "Use dark appearance",
                                isOn: $themeManager.isDarkMode
                            )
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    // Security Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Security & Privacy")
                            .font(.custom("Inter", size: 20))
                            .fontWeight(.semibold)
                            .foregroundColor(themeManager.textColor)
                            .padding(.horizontal, 20)
                        
                        VStack(spacing: 12) {
                            ToggleRow(
                                icon: "faceid",
                                title: "Biometric Authentication",
                                subtitle: "Use Face ID or Touch ID",
                                isOn: $biometricAuth
                            )
                            
                            ToggleRow(
                                icon: "location.fill",
                                title: "Location Services",
                                subtitle: "Allow location access",
                                isOn: $locationServices
                            )
                            
                            ToggleRow(
                                icon: "chart.bar.fill",
                                title: "Analytics",
                                subtitle: "Help improve the app",
                                isOn: $analyticsEnabled
                            )
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    // Account Actions Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Account")
                            .font(.custom("Inter", size: 20))
                            .fontWeight(.semibold)
                            .foregroundColor(themeManager.textColor)
                            .padding(.horizontal, 20)
                        
                        VStack(spacing: 12) {
                            ActionRow(
                                icon: "key.fill",
                                title: "Change Password",
                                subtitle: "Update your password"
                            ) {
                                // Handle change password
                            }
                            
                            ActionRow(
                                icon: "trash.fill",
                                title: "Delete Account",
                                subtitle: "Permanently delete your account",
                                isDestructive: true
                            ) {
                                // Handle delete account
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    // App Information Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("About")
                            .font(.custom("Inter", size: 20))
                            .fontWeight(.semibold)
                            .foregroundColor(themeManager.textColor)
                            .padding(.horizontal, 20)
                        
                        VStack(spacing: 12) {
                            InfoRow(
                                icon: "info.circle.fill",
                                title: "App Version",
                                value: "1.0.0"
                            )
                            
                            InfoRow(
                                icon: "doc.text.fill",
                                title: "Terms of Service",
                                value: ""
                            ) {
                                // Handle terms of service
                            }
                            
                            InfoRow(
                                icon: "hand.raised.fill",
                                title: "Privacy Policy",
                                value: ""
                            ) {
                                // Handle privacy policy
                            }
                            
                            InfoRow(
                                icon: "envelope.fill",
                                title: "Contact Support",
                                value: "support@travely.com"
                            ) {
                                // Handle contact support
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    // Reset Settings Button
                    Button(action: resetSettings) {
                        Text("Reset to Defaults")
                            .font(.custom("Inter", size: 16))
                            .fontWeight(.semibold)
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.red.opacity(0.1))
                            .cornerRadius(15)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
                }
            }
            .navigationBarHidden(true)
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
}

struct ToggleRow: View {
    @EnvironmentObject var themeManager: ThemeManager
    let icon: String
    let title: String
    let subtitle: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .foregroundColor(themeManager.primaryColor)
                .font(.system(size: 20))
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.custom("Inter", size: 16))
                    .fontWeight(.medium)
                    .foregroundColor(themeManager.textColor)
                
                Text(subtitle)
                    .font(.custom("Inter", size: 14))
                    .foregroundColor(themeManager.secondaryTextColor)
            }
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .tint(themeManager.primaryColor)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(Color.white) // White background
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2) // Light shadow
    }
}

struct SelectionRow: View {
    @EnvironmentObject var themeManager: ThemeManager
    let icon: String
    let title: String
    let value: String
    let options: [String]
    @Binding var selectedValue: String
    @State private var showingPicker = false
    
    var body: some View {
        Button(action: { showingPicker = true }) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .foregroundColor(themeManager.primaryColor)
                    .font(.system(size: 20))
                    .frame(width: 24)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.custom("Inter", size: 16))
                        .fontWeight(.medium)
                        .foregroundColor(themeManager.textColor)
                    
                    Text(selectedValue)
                        .font(.custom("Inter", size: 14))
                        .foregroundColor(themeManager.secondaryTextColor)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(themeManager.secondaryTextColor)
                    .font(.system(size: 14))
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(Color.white) // White background
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2) // Light shadow
        }
        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $showingPicker) {
            PickerSheet(
                title: title,
                options: options,
                selectedValue: $selectedValue
            )
        }
    }
}

struct ActionRow: View {
    @EnvironmentObject var themeManager: ThemeManager
    let icon: String
    let title: String
    let subtitle: String
    var isDestructive: Bool = false
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .foregroundColor(isDestructive ? .red : themeManager.primaryColor)
                    .font(.system(size: 20))
                    .frame(width: 24)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.custom("Inter", size: 16))
                        .fontWeight(.medium)
                        .foregroundColor(isDestructive ? .red : themeManager.textColor)
                    
                    Text(subtitle)
                        .font(.custom("Inter", size: 14))
                        .foregroundColor(themeManager.secondaryTextColor)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(themeManager.secondaryTextColor)
                    .font(.system(size: 14))
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(Color.white) // White background
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2) // Light shadow
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct InfoRow: View {
    @EnvironmentObject var themeManager: ThemeManager
    let icon: String
    let title: String
    let value: String
    var action: (() -> Void)? = nil
    
    var body: some View {
        Button(action: action ?? {}) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .foregroundColor(themeManager.primaryColor)
                    .font(.system(size: 20))
                    .frame(width: 24)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.custom("Inter", size: 16))
                        .fontWeight(.medium)
                        .foregroundColor(themeManager.textColor)
                    
                    if !value.isEmpty {
                        Text(value)
                            .font(.custom("Inter", size: 14))
                            .foregroundColor(themeManager.secondaryTextColor)
                    }
                }
                
                Spacer()
                
                if action != nil {
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                        .font(.system(size: 14))
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(Color.white) // White background
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2) // Light shadow
        }
        .buttonStyle(PlainButtonStyle())
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
                }
                .buttonStyle(PlainButtonStyle())
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

#Preview {
    AppSettingsView()
        .environmentObject(ThemeManager())
}
