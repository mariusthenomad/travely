import Foundation
import SwiftUI

// MARK: - Migration Integration View
struct MigrationIntegrationView: View {
    @StateObject private var migrationManager = DatabaseMigrationManager()
    @State private var showingMigration = false
    
    var body: some View {
        VStack(spacing: UltraLightDesignSystem.spaceL) {
            // Header
            UltraLightWindow(
                title: "Database Migration",
                subtitle: "Set up travel routes database",
                style: .premium
            ) {
                EmptyView()
            }
            
            // Migration Status
            UltraLightWindow(
                title: "Migration Status",
                style: .standard
            ) {
                VStack(spacing: UltraLightDesignSystem.spaceM) {
                    HStack {
                        Image(systemName: migrationManager.isMigrating ? "clock.fill" : "checkmark.circle.fill")
                            .foregroundColor(migrationManager.isMigrating ? .orange : .green)
                            .font(.system(size: 20))
                        
                        Text(migrationManager.migrationStatus)
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .foregroundColor(UltraLightDesignSystem.text)
                            .multilineTextAlignment(.leading)
                        
                        Spacer()
                    }
                    
                    if migrationManager.isMigrating {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: UltraLightDesignSystem.primaryOrange))
                            .scaleEffect(0.8)
                    }
                }
            }
            
            // Action Buttons
            VStack(spacing: UltraLightDesignSystem.spaceM) {
                // Run Migration Button
                Button(action: {
                    Task {
                        await migrationManager.runMigration()
                    }
                }) {
                    HStack(spacing: UltraLightDesignSystem.spaceS) {
                        Image(systemName: "arrow.down.circle.fill")
                            .font(.system(size: 16, weight: .semibold))
                        
                        Text(migrationManager.isMigrating ? "Migrating..." : "Run Migration")
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, UltraLightDesignSystem.spaceM)
                    .background(
                        LinearGradient(
                            colors: [UltraLightDesignSystem.primaryOrange, UltraLightDesignSystem.primaryOrange.opacity(0.8)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(UltraLightDesignSystem.radiusM)
                    .shadow(color: UltraLightDesignSystem.primaryOrange.opacity(0.3), radius: 8, x: 0, y: 4)
                }
                .disabled(migrationManager.isMigrating)
                
                // Verify Migration Button
                Button(action: {
                    Task {
                        try await migrationManager.verifyMigration()
                    }
                }) {
                    HStack(spacing: UltraLightDesignSystem.spaceS) {
                        Image(systemName: "checkmark.shield.fill")
                            .font(.system(size: 16, weight: .semibold))
                        
                        Text("Verify Migration")
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                    }
                    .foregroundColor(UltraLightDesignSystem.primaryOrange)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, UltraLightDesignSystem.spaceM)
                    .background(UltraLightDesignSystem.primaryOrange.opacity(0.1))
                    .cornerRadius(UltraLightDesignSystem.radiusM)
                    .overlay(
                        RoundedRectangle(cornerRadius: UltraLightDesignSystem.radiusM)
                            .stroke(UltraLightDesignSystem.primaryOrange.opacity(0.3), lineWidth: 1)
                    )
                }
                .disabled(migrationManager.isMigrating)
                
                // Test Queries Button
                Button(action: {
                    Task {
                        await testQueries()
                    }
                }) {
                    HStack(spacing: UltraLightDesignSystem.spaceS) {
                        Image(systemName: "magnifyingglass.circle.fill")
                            .font(.system(size: 16, weight: .semibold))
                        
                        Text("Test Queries")
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                    }
                    .foregroundColor(UltraLightDesignSystem.textSecondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, UltraLightDesignSystem.spaceM)
                    .background(UltraLightDesignSystem.surface)
                    .cornerRadius(UltraLightDesignSystem.radiusM)
                }
                .disabled(migrationManager.isMigrating)
            }
            
            Spacer()
        }
        .padding(.horizontal, UltraLightDesignSystem.spaceM)
        .padding(.top, UltraLightDesignSystem.spaceM)
    }
    
    // MARK: - Test Queries Function
    private func testQueries() async {
        do {
            // Fetch all routes
            let routes = try await migrationManager.fetchAllRoutes()
            print("📊 Found \(routes.count) routes:")
            for route in routes {
                if let title = route["title"] as? String,
                   let totalCost = route["total_cost"] as? Double {
                    print("  - \(title): €\(totalCost)")
                }
            }
            
            // Fetch stops for the first route
            if let firstRoute = routes.first,
               let routeId = firstRoute["id"] as? String {
                let stops = try await migrationManager.fetchStopsForRoute(routeId: routeId)
                print("📍 Found \(stops.count) stops for route:")
                for stop in stops {
                    if let location = stop["location"] as? String,
                       let country = stop["country"] as? String,
                       let nights = stop["nights"] as? Int {
                        print("  - \(location), \(country): \(nights) nights")
                    }
                }
            }
            
            await MainActor.run {
                migrationManager.migrationStatus = "✅ Test queries completed successfully!"
            }
            
        } catch {
            await MainActor.run {
                migrationManager.migrationStatus = "❌ Test queries failed: \(error.localizedDescription)"
            }
        }
    }
}

// MARK: - Add to ContentView
/*
// To integrate this into your existing ContentView, add this button somewhere:

Button("Database Migration") {
    showingMigration = true
}
.sheet(isPresented: $showingMigration) {
    MigrationIntegrationView()
}
*/

// MARK: - Preview
struct MigrationIntegrationView_Previews: PreviewProvider {
    static var previews: some View {
        MigrationIntegrationView()
            .preferredColorScheme(.dark)
    }
}

