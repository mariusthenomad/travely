import SwiftUI

struct LandingPageView: View {
    @State private var currentPage = 0
    @State private var showingAuth = false
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        ZStack {
            // Background Gradient
            LinearGradient(
                colors: [
                    UltraLightDesignSystem.background,
                    UltraLightDesignSystem.primaryOrange.opacity(0.1),
                    UltraLightDesignSystem.primaryGreen.opacity(0.1)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 0) {
                    // Hero Section
                    heroSection
                    
                    // Features Section
                    featuresSection
                    
                    // How It Works Section
                    howItWorksSection
                    
                    // Testimonials Section
                    testimonialsSection
                    
                    // CTA Section
                    ctaSection
                }
            }
        }
        .sheet(isPresented: $showingAuth) {
            AuthenticationView()
        }
    }
    
    // MARK: - Hero Section
    private var heroSection: some View {
        VStack(spacing: UltraLightDesignSystem.spaceXL) {
            Spacer()
                .frame(height: 60)
            
            // App Logo/Icon
            ZStack {
                Circle()
                    .fill(UltraLightDesignSystem.primaryOrange.opacity(0.2))
                    .frame(width: 120, height: 120)
                
                Image(systemName: "map.circle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(UltraLightDesignSystem.primaryOrange)
            }
            
            VStack(spacing: UltraLightDesignSystem.spaceL) {
                Text("PathFinder")
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundColor(UltraLightDesignSystem.text)
                
                Text("Your Ultimate Travel Planning Companion")
                    .font(.system(size: 20, weight: .medium, design: .rounded))
                    .foregroundColor(UltraLightDesignSystem.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                
                Text("Plan, organize, and discover amazing travel experiences with intelligent route optimization and personalized recommendations.")
                    .font(.system(size: 16, weight: .regular, design: .rounded))
                    .foregroundColor(UltraLightDesignSystem.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                    .lineLimit(nil)
            }
            
            // CTA Buttons
            VStack(spacing: UltraLightDesignSystem.spaceM) {
                Button(action: {
                    showingAuth = true
                }) {
                    HStack {
                        Text("Get Started")
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                        Image(systemName: "arrow.right")
                            .font(.system(size: 16, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, UltraLightDesignSystem.spaceL)
                    .background(UltraLightDesignSystem.primaryOrange)
                    .cornerRadius(UltraLightDesignSystem.radiusL)
                }
                
                Button(action: {
                    // Scroll to features
                }) {
                    Text("Learn More")
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundColor(UltraLightDesignSystem.primaryOrange)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, UltraLightDesignSystem.spaceM)
                        .background(UltraLightDesignSystem.primaryOrange.opacity(0.1))
                        .cornerRadius(UltraLightDesignSystem.radiusL)
                }
            }
            .padding(.horizontal, 30)
            
            Spacer()
                .frame(height: 40)
        }
    }
    
    // MARK: - Features Section
    private var featuresSection: some View {
        VStack(spacing: UltraLightDesignSystem.spaceXL) {
            Text("Why Choose PathFinder?")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundColor(UltraLightDesignSystem.text)
                .multilineTextAlignment(.center)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: UltraLightDesignSystem.spaceL) {
                FeatureCard(
                    icon: "map.fill",
                    title: "Smart Routes",
                    description: "AI-powered route optimization for the perfect journey"
                )
                
                FeatureCard(
                    icon: "bed.double.fill",
                    title: "Hotel Management",
                    description: "Find and book the best accommodations"
                )
                
                FeatureCard(
                    icon: "airplane",
                    title: "Flight Integration",
                    description: "Seamless flight booking and management"
                )
                
                FeatureCard(
                    icon: "calendar",
                    title: "Trip Planning",
                    description: "Organize your entire trip in one place"
                )
            }
            .padding(.horizontal, 20)
        }
        .padding(.vertical, UltraLightDesignSystem.spaceXL)
    }
    
    // MARK: - How It Works Section
    private var howItWorksSection: some View {
        VStack(spacing: UltraLightDesignSystem.spaceXL) {
            Text("How It Works")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundColor(UltraLightDesignSystem.text)
            
            VStack(spacing: UltraLightDesignSystem.spaceL) {
                StepCard(
                    number: 1,
                    title: "Plan Your Route",
                    description: "Add destinations and let our AI optimize your travel path"
                )
                
                StepCard(
                    number: 2,
                    title: "Book Accommodations",
                    description: "Find and reserve hotels with integrated booking system"
                )
                
                StepCard(
                    number: 3,
                    title: "Manage Your Trip",
                    description: "Track flights, manage bookings, and stay organized"
                )
            }
        }
        .padding(.vertical, UltraLightDesignSystem.spaceXL)
        .padding(.horizontal, 20)
    }
    
    // MARK: - Testimonials Section
    private var testimonialsSection: some View {
        VStack(spacing: UltraLightDesignSystem.spaceXL) {
            Text("What Travelers Say")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundColor(UltraLightDesignSystem.text)
            
            VStack(spacing: UltraLightDesignSystem.spaceL) {
                TestimonialCard(
                    text: "PathFinder made planning my European adventure so easy! The route optimization saved me hours of research.",
                    author: "Sarah M.",
                    rating: 5
                )
                
                TestimonialCard(
                    text: "Finally, an app that actually understands how to plan a trip. The hotel integration is fantastic!",
                    author: "Mike R.",
                    rating: 5
                )
            }
        }
        .padding(.vertical, UltraLightDesignSystem.spaceXL)
        .padding(.horizontal, 20)
    }
    
    // MARK: - CTA Section
    private var ctaSection: some View {
        VStack(spacing: UltraLightDesignSystem.spaceL) {
            Text("Ready to Start Your Journey?")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(UltraLightDesignSystem.text)
                .multilineTextAlignment(.center)
            
            Text("Join thousands of travelers who trust PathFinder for their adventures")
                .font(.system(size: 16, weight: .medium, design: .rounded))
                .foregroundColor(UltraLightDesignSystem.textSecondary)
                .multilineTextAlignment(.center)
            
            Button(action: {
                showingAuth = true
            }) {
                HStack {
                    Text("Start Planning Now")
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                    Image(systemName: "arrow.right")
                        .font(.system(size: 16, weight: .semibold))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, UltraLightDesignSystem.spaceL)
                .background(UltraLightDesignSystem.primaryOrange)
                .cornerRadius(UltraLightDesignSystem.radiusL)
            }
            .padding(.horizontal, 30)
        }
        .padding(.vertical, UltraLightDesignSystem.spaceXL)
    }
}

// MARK: - Feature Card
struct FeatureCard: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        VStack(spacing: UltraLightDesignSystem.spaceM) {
            ZStack {
                Circle()
                    .fill(UltraLightDesignSystem.primaryOrange.opacity(0.2))
                    .frame(width: 60, height: 60)
                
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(UltraLightDesignSystem.primaryOrange)
            }
            
            VStack(spacing: UltraLightDesignSystem.spaceS) {
                Text(title)
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundColor(UltraLightDesignSystem.text)
                    .multilineTextAlignment(.center)
                
                Text(description)
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundColor(UltraLightDesignSystem.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(3)
            }
        }
        .padding(UltraLightDesignSystem.spaceL)
        .background(UltraLightDesignSystem.surface.opacity(0.5))
        .cornerRadius(UltraLightDesignSystem.radiusL)
    }
}

// MARK: - Step Card
struct StepCard: View {
    let number: Int
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: UltraLightDesignSystem.spaceL) {
            ZStack {
                Circle()
                    .fill(UltraLightDesignSystem.primaryOrange)
                    .frame(width: 50, height: 50)
                
                Text("\(number)")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .leading, spacing: UltraLightDesignSystem.spaceS) {
                Text(title)
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundColor(UltraLightDesignSystem.text)
                
                Text(description)
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundColor(UltraLightDesignSystem.textSecondary)
            }
            
            Spacer()
        }
        .padding(UltraLightDesignSystem.spaceL)
        .background(UltraLightDesignSystem.surface.opacity(0.3))
        .cornerRadius(UltraLightDesignSystem.radiusL)
    }
}

// MARK: - Testimonial Card
struct TestimonialCard: View {
    let text: String
    let author: String
    let rating: Int
    
    var body: some View {
        VStack(spacing: UltraLightDesignSystem.spaceM) {
            HStack {
                ForEach(0..<rating, id: \.self) { _ in
                    Image(systemName: "star.fill")
                        .foregroundColor(UltraLightDesignSystem.primaryOrange)
                        .font(.system(size: 16))
                }
                Spacer()
            }
            
            Text(text)
                .font(.system(size: 16, weight: .medium, design: .rounded))
                .foregroundColor(UltraLightDesignSystem.text)
                .multilineTextAlignment(.leading)
            
            HStack {
                Spacer()
                Text("- \(author)")
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundColor(UltraLightDesignSystem.primaryOrange)
            }
        }
        .padding(UltraLightDesignSystem.spaceL)
        .background(UltraLightDesignSystem.surface.opacity(0.3))
        .cornerRadius(UltraLightDesignSystem.radiusL)
    }
}

#Preview {
    LandingPageView()
        .environmentObject(ThemeManager())
}
