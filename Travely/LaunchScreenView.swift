import SwiftUI

struct LaunchScreenView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @State private var isAnimating = false
    @State private var showMainApp = false
    
    var body: some View {
        ZStack {
            // Background gradient like the rest of the app
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.white,
                    Color(red: 1.0, green: 0.95, blue: 0.9) // Light peach/pink
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 30) {
                // App Logo
                ZStack {
                    // Background circle with orange gradient
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color(red: 1.0, green: 0.4, blue: 0.2), // Orange
                                    Color(red: 0.8, green: 0.3, blue: 0.1) // Darker orange
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 120, height: 120)
                        .shadow(color: Color(red: 1.0, green: 0.4, blue: 0.2).opacity(0.3), radius: 20, x: 0, y: 10)
                    
                    // Travel icon
                    Image(systemName: "airplane.departure")
                        .font(.system(size: 50, weight: .bold))
                        .foregroundColor(.white)
                        .rotationEffect(.degrees(isAnimating ? 360 : 0))
                        .animation(
                            Animation.easeInOut(duration: 2.0)
                                .repeatForever(autoreverses: false),
                            value: isAnimating
                        )
                }
                .scaleEffect(isAnimating ? 1.1 : 0.8)
                .animation(
                    Animation.easeInOut(duration: 1.5)
                        .repeatForever(autoreverses: true),
                    value: isAnimating
                )
                
                // App Name
                VStack(spacing: 8) {
                    Text("TRAVELY")
                        .font(.system(size: 36, weight: .black, design: .rounded))
                        .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2)) // Dark gray
                        .tracking(4)
                        .opacity(isAnimating ? 1 : 0)
                        .animation(
                            Animation.easeInOut(duration: 1.0)
                                .delay(0.5),
                            value: isAnimating
                        )
                    
                    Text("Your Journey Starts Here")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.5)) // Medium gray
                        .opacity(isAnimating ? 1 : 0)
                        .animation(
                            Animation.easeInOut(duration: 1.0)
                                .delay(1.0),
                            value: isAnimating
                        )
                }
                
                // Loading indicator
                HStack(spacing: 8) {
                    ForEach(0..<3) { index in
                        Circle()
                            .fill(Color(red: 1.0, green: 0.4, blue: 0.2)) // Orange
                            .frame(width: 8, height: 8)
                            .scaleEffect(isAnimating ? 1.2 : 0.8)
                            .animation(
                                Animation.easeInOut(duration: 0.6)
                                    .repeatForever(autoreverses: true)
                                    .delay(Double(index) * 0.2),
                                value: isAnimating
                            )
                    }
                }
                .opacity(isAnimating ? 1 : 0)
                .animation(
                    Animation.easeInOut(duration: 1.0)
                        .delay(1.5),
                    value: isAnimating
                )
            }
        }
        .onAppear {
            isAnimating = true
            
            // Show main app after 3 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                showMainApp = true
            }
        }
        .fullScreenCover(isPresented: $showMainApp) {
            ContentView()
                .environmentObject(themeManager)
                .preferredColorScheme(themeManager.isDarkMode ? .dark : .light)
        }
    }
}

#Preview {
    LaunchScreenView()
        .environmentObject(ThemeManager())
}
