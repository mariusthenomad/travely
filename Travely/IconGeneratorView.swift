import SwiftUI

struct IconGeneratorView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("App Icon Generator")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Use this view to generate app icons")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            // Different icon sizes
            VStack(spacing: 16) {
                HStack(spacing: 16) {
                    AppIconView(size: 60)
                    AppIconView(size: 80)
                    AppIconView(size: 100)
                }
                
                HStack(spacing: 16) {
                    AppIconView(size: 120)
                    AppIconView(size: 140)
                    AppIconView(size: 160)
                }
                
                AppIconView(size: 200)
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)
            
            Text("Instructions:")
                .font(.headline)
                .fontWeight(.semibold)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("1. Take screenshots of the icons above")
                Text("2. Save them as PNG files")
                Text("3. Add them to Assets.xcassets/AppIcon.appiconset/")
                Text("4. Update Contents.json with proper sizes")
            }
            .font(.caption)
            .foregroundColor(.secondary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(Color.blue.opacity(0.1))
            .cornerRadius(8)
        }
        .padding()
    }
}

#Preview {
    IconGeneratorView()
}
