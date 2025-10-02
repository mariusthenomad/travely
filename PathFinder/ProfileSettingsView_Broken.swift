import SwiftUI

struct ProfileSettingsView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @State private var userName = "Marius Bartl"
    @State private var userEmail = "mariusthenomad@gmail.com"
    @State private var userPhone = "+49 151 23333184"
    @State private var userLocation = "Munich, Germany"
    @State private var isEditingProfile = false
    @State private var showingLogoutAlert = false
    @State private var showingAppSettings = false
    
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
                    // Profile Header
                    VStack(spacing: 20) {
                        // Profile Picture
                        ZStack {
                            Circle()
                                .fill(Color(red: 1.0, green: 0.4, blue: 0.2).opacity(0.1)) // Orange
                                .frame(width: 100, height: 100)
                            
                            // Profile image with robust loading
                            Group {
                                // Try to load profile image from Assets.xcassets
                                if let profileImage = UIImage(named: "profile") {
                                    Image(uiImage: profileImage)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 100, height: 100)
                                        .clipShape(Circle())
                                        .overlay(
                                            Circle()
                                                .stroke(Color.white, lineWidth: 3)
                                        )
                                } else {
                                    // Fallback: Try direct bundle loading from ProfileImages
                                    if let bundleURL = Bundle.main.url(forResource: "profile", withExtension: "jpg"),
                                       let bundleImage = UIImage(contentsOfFile: bundleURL.path) {
                                        Image(uiImage: bundleImage)
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 100, height: 100)
                                            .clipShape(Circle())
                                            .overlay(
                                                Circle()
                                                    .stroke(Color.white, lineWidth: 3)
                                            )
                                    } else {
                                        // Final fallback: Create a custom profile image with "M" for Marius
                                        ZStack {
                                            Circle()
                                                .fill(Color(red: 1.0, green: 0.4, blue: 0.2).opacity(0.8))
                                                .frame(width: 100, height: 100)
                                            
                                            VStack(spacing: 2) {
                                                Text("M")
                                                    .font(.system(size: 40, weight: .bold, design: .rounded))
                                                    .foregroundColor(.white)
                                                
                                                Text("Add Photo")
                                                    .font(.system(size: 8, weight: .medium))
                                                    .foregroundColor(.white.opacity(0.8))
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        
                        VStack(spacing: 8) {
                            Text(userName)
                                .font(.custom("Inter", size: 24))
                                .fontWeight(.bold)
                                .foregroundColor(themeManager.textColor)
                            
                            Text(userEmail)
                                .font(.custom("Inter", size: 16))
                                .foregroundColor(themeManager.secondaryTextColor)
                        }
                        
                        Button(action: { isEditingProfile = true }) {
                            Text("Edit Profile")
                                .font(.custom("Inter", size: 18))
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(Color(red: 1.0, green: 0.4, blue: 0.2)) // Orange
                                .cornerRadius(15)
                        }
                        .padding(.horizontal, 20) // Same padding as the cards
                    }
                    .padding(.top, 20)
                    
                    // Profile Information
                    VStack(spacing: 16) {
                        ProfileInfoRow(
                            icon: "person.fill",
                            title: "Full Name",
                            value: userName,
                            isEditable: true
                        )
                        
                        ProfileInfoRow(
                            icon: "envelope.fill",
                            title: "Email",
                            value: userEmail,
                            isEditable: true
                        )
                        
                        ProfileInfoRow(
                            icon: "phone.fill",
                            title: "Phone",
                            value: userPhone,
                            isEditable: true
                        )
                        
                        ProfileInfoRow(
                            icon: "location.fill",
                            title: "Location",
                            value: userLocation,
                            isEditable: true
                        )
                    }
                    .padding(.horizontal, 20)
                    
                    // Settings and Actions
                    VStack(spacing: 12) {
                        NavigationLink(destination: AppSettingsView()) {
                            SettingsRow(
                                icon: "gearshape.fill",
                                title: "App Settings",
                                subtitle: "Notifications, Privacy, Language"
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        Button(action: {}) {
                            SettingsRow(
                                icon: "questionmark.circle.fill",
                                title: "Help & Support",
                                subtitle: "FAQ, Contact Us, Feedback"
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        Button(action: {}) {
                            SettingsRow(
                                icon: "star.fill",
                                title: "Rate PathFinder",
                                subtitle: "Share your experience"
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        Button(action: { showingLogoutAlert = true }) {
                            SettingsRow(
                                icon: "rectangle.portrait.and.arrow.right",
                                title: "Logout",
                                subtitle: "Sign out of your account",
                                isDestructive: true
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $isEditingProfile) {
                EditProfileSheet(
                    userName: $userName,
                    userEmail: $userEmail,
                    userPhone: $userPhone,
                    userLocation: $userLocation
                )
            }
            .alert("Logout", isPresented: $showingLogoutAlert) {
                Button("Logout", role: .destructive) {
                    // Handle logout
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("Are you sure you want to logout?")
            }
        }
    }
}

struct ProfileInfoRow: View {
    @EnvironmentObject var themeManager: ThemeManager
    let icon: String
    let title: String
    let value: String
    let isEditable: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .foregroundColor(themeManager.primaryColor)
                .font(.system(size: 20))
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.custom("Inter", size: 14))
                    .foregroundColor(themeManager.secondaryTextColor)
                
                Text(value)
                    .font(.custom("Inter", size: 16))
                    .foregroundColor(themeManager.textColor)
            }
            
            Spacer()
            
            if isEditable {
                Image(systemName: "chevron.right")
                    .foregroundColor(themeManager.secondaryTextColor)
                    .font(.system(size: 14))
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(Color.white) // White background
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2) // Light shadow
    }
}


struct SettingsRow: View {
    @EnvironmentObject var themeManager: ThemeManager
    let icon: String
    let title: String
    let subtitle: String
    var isDestructive: Bool = false
    
    var body: some View {
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
}

struct EditProfileSheet: View {
    @EnvironmentObject var themeManager: ThemeManager
    @Binding var userName: String
    @Binding var userEmail: String
    @Binding var userPhone: String
    @Binding var userLocation: String
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                VStack(spacing: 16) {
                    ProfileTextField(title: "Full Name", text: $userName)
                    ProfileTextField(title: "E-Mail", text: $userEmail)
                    ProfileTextField(title: "Phone", text: $userPhone)
                    ProfileTextField(title: "Location", text: $userLocation)
                }
                .padding(.top, 20)
                
                Spacer()
                
                Button(action: { presentationMode.wrappedValue.dismiss() }) {
                    Text("Save Changes")
                        .font(.custom("Inter", size: 18))
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(themeManager.primaryColor)
                        .cornerRadius(15)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
            .padding(.horizontal, 20)
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

struct ProfileTextField: View {
    @EnvironmentObject var themeManager: ThemeManager
    let title: String
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.custom("Inter", size: 14))
                .foregroundColor(themeManager.secondaryTextColor)
            
            TextField(title, text: $text)
                .font(.custom("Inter", size: 16))
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
    }
}

#Preview {
    ProfileSettingsView()
        .environmentObject(ThemeManager())
}