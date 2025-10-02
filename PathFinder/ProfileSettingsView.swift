import SwiftUI

struct ProfileSettingsView: View {
    @EnvironmentObject var supabaseManager: SupabaseManager
    @EnvironmentObject var themeManager: ThemeManager
    @State private var userName = "Marius Bartl"
    @State private var userEmail = "mariusthenomad@gmail.com"
    @State private var userPhone = "+49 151 23333184"
    @State private var userLocation = "Munich, Germany"
    @State private var isEditingProfile = false
    @State private var showingLogoutAlert = false
    
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
                    VStack(spacing: 16) {
                    // Profile Header
                    VStack(spacing: 16) {
                                // Profile Picture
                                ZStack {
                                    Circle()
                                        .fill(Color(red: 1.0, green: 0.4, blue: 0.2).opacity(0.1))
                                        .frame(width: 100, height: 100)
                                    
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
                                        ZStack {
                                            Circle()
                                                .fill(Color(red: 1.0, green: 0.4, blue: 0.2))
                                                .frame(width: 100, height: 100)
                                            
                                            VStack(spacing: 4) {
                                                Text("M")
                                                    .font(.custom("Inter", size: 36))
                                                    .fontWeight(.bold)
                                                    .foregroundColor(.white)
                                                
                                                Text("Add Photo")
                                                    .font(.custom("Inter", size: 10))
                                                    .foregroundColor(.white.opacity(0.8))
                                            }
                                        }
                                    }
                                }
                                
                                // User Info
                                VStack(spacing: 8) {
                                    Text(userName)
                                        .font(.custom("Inter", size: 24))
                                        .fontWeight(.bold)
                                        .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                                    
                                    Text(userEmail)
                                        .font(.custom("Inter", size: 16))
                                        .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.5))
                                    
                                    // Edit Profile Button
                                    Button(action: {
                                        isEditingProfile = true
                                    }) {
                                        Text("Edit Profile")
                                            .font(.custom("Inter", size: 14))
                                            .fontWeight(.medium)
                                            .foregroundColor(.white)
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 6)
                                            .background(Color(red: 1.0, green: 0.4, blue: 0.2))
                                            .cornerRadius(12)
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 16)
                            
                            // Profile Information
                            VStack(spacing: 12) {
                                ProfileInfoRow(
                                    icon: "person.fill",
                                    title: "Full Name",
                                    value: userName
                                )
                                
                                ProfileInfoRow(
                                    icon: "envelope.fill",
                                    title: "E-Mail",
                                    value: userEmail
                                )
                                
                                ProfileInfoRow(
                                    icon: "phone.fill",
                                    title: "Phone",
                                    value: userPhone
                                )
                                
                                ProfileInfoRow(
                                    icon: "location.fill",
                                    title: "Location",
                                    value: userLocation
                                )
                            }
                            .padding(.horizontal, 20)
                            
                            // Settings Section
                            VStack(spacing: 12) {
                                
                                VStack(spacing: 12) {
                                    NavigationLink(destination: AppSettingsView()) {
                                        HStack(spacing: 16) {
                                            Image(systemName: "gearshape.fill")
                                                .foregroundColor(Color(red: 1.0, green: 0.4, blue: 0.2))
                                                .font(.system(size: 18))
                                                .frame(width: 24)
                                            
                                            Text("App Settings")
                                                .font(.custom("Inter", size: 16))
                                                .fontWeight(.medium)
                                                .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                                            
                                            Spacer()
                                            
                                            Image(systemName: "chevron.right")
                                                .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.5))
                                                .font(.system(size: 12))
                                        }
                                        .frame(height: 60)
                                        .padding(.horizontal, 12)
                                        .background(Color.white)
                                        .cornerRadius(12)
                                        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    
                                    Button(action: {
                                        showingLogoutAlert = true
                                    }) {
                                        HStack(spacing: 16) {
                                            Image(systemName: "rectangle.portrait.and.arrow.right")
                                                .foregroundColor(.red)
                                                .font(.system(size: 18))
                                                .frame(width: 24)
                                            
                                            Text("Logout")
                                                .font(.custom("Inter", size: 16))
                                                .fontWeight(.medium)
                                                .foregroundColor(.red)
                                            
                                            Spacer()
                                            
                                            Image(systemName: "chevron.right")
                                                .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.5))
                                                .font(.system(size: 12))
                                        }
                                        .frame(height: 60)
                                        .padding(.horizontal, 12)
                                        .background(Color.white)
                                        .cornerRadius(12)
                                        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                                .padding(.horizontal, 20)
                            }
                            .padding(.top, 12)
                        }
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
                    handleLogout()
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("Are you sure you want to logout?")
            }
        }
    }
    
    private func handleLogout() {
        Task {
            do {
                try await supabaseManager.signOut()
            } catch {
                print("Logout error: \(error.localizedDescription)")
            }
        }
    }
}

struct ProfileInfoRow: View {
    @EnvironmentObject var themeManager: ThemeManager
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .foregroundColor(Color(red: 1.0, green: 0.4, blue: 0.2))
                .font(.system(size: 18))
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.custom("Inter", size: 14))
                    .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.5))
                
                Text(value)
                    .font(.custom("Inter", size: 16))
                    .fontWeight(.medium)
                    .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
            }
            
            Spacer()
        }
        .frame(height: 60)
        .padding(.horizontal, 12)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
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
                ProfileTextField(title: "Full Name", text: $userName)
                ProfileTextField(title: "Email", text: $userEmail)
                ProfileTextField(title: "Phone", text: $userPhone)
                ProfileTextField(title: "Location", text: $userLocation)
                
                Spacer()
                
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
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