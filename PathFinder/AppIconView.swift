import SwiftUI

struct AppIconView: View {
    let size: CGFloat
    
    var body: some View {
        ZStack {
            // Background with gradient
            RoundedRectangle(cornerRadius: size * 0.22)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 0.11, green: 0.31, blue: 0.85), // #1D4ED8
                            Color(red: 0.05, green: 0.15, blue: 0.4)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: size, height: size)
                .shadow(color: Color(red: 0.11, green: 0.31, blue: 0.85).opacity(0.3), radius: size * 0.1, x: 0, y: size * 0.05)
            
            // Travel icon
            Image(systemName: "airplane.departure")
                .font(.system(size: size * 0.4, weight: .bold))
                .foregroundColor(.white)
                .rotationEffect(.degrees(-15)) // Slight rotation for dynamic look
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        AppIconView(size: 60)
        AppIconView(size: 120)
        AppIconView(size: 180)
    }
    .padding()
    .background(Color.gray.opacity(0.1))
}
