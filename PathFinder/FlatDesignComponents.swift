import SwiftUI

// MARK: - Flat Design System
struct FlatDesignSystem {
    
    // MARK: - Colors
    static let primaryBlue = Color(red: 0.0, green: 0.48, blue: 1.0) // #007AFF
    static let secondaryBlue = Color(red: 0.35, green: 0.78, blue: 0.98) // #5AC8FA
    static let accentGreen = Color(red: 0.2, green: 0.78, blue: 0.35) // #34C759
    static let accentRed = Color(red: 1.0, green: 0.23, blue: 0.19) // #FF3B30
    static let accentOrange = Color(red: 1.0, green: 0.58, blue: 0.0) // #FF9500
    
    static let background = Color(.systemBackground)
    static let surface = Color(.secondarySystemBackground)
    static let border = Color(.systemGray5)
    static let text = Color(.label)
    static let textSecondary = Color(.secondaryLabel)
    
    // MARK: - Spacing
    static let paddingXS: CGFloat = 4
    static let paddingS: CGFloat = 8
    static let paddingM: CGFloat = 16
    static let paddingL: CGFloat = 24
    static let paddingXL: CGFloat = 32
    
    // MARK: - Corner Radius
    static let radiusS: CGFloat = 4
    static let radiusM: CGFloat = 8
    static let radiusL: CGFloat = 12
    static let radiusXL: CGFloat = 16
    
    // MARK: - Shadows (Minimal)
    static let shadowOpacity: Double = 0.05
    static let shadowRadius: CGFloat = 2
    static let shadowOffset = CGSize(width: 0, height: 1)
}

// MARK: - Flat Card Component
struct FlatCard<Content: View>: View {
    let content: Content
    let backgroundColor: Color
    let borderColor: Color
    
    init(
        backgroundColor: Color = FlatDesignSystem.surface,
        borderColor: Color = FlatDesignSystem.border,
        @ViewBuilder content: () -> Content
    ) {
        self.backgroundColor = backgroundColor
        self.borderColor = borderColor
        self.content = content()
    }
    
    var body: some View {
        content
            .padding(FlatDesignSystem.paddingM)
            .background(backgroundColor)
            .cornerRadius(FlatDesignSystem.radiusL)
            .overlay(
                RoundedRectangle(cornerRadius: FlatDesignSystem.radiusL)
                    .stroke(borderColor, lineWidth: 1)
            )
            .shadow(
                color: .black.opacity(FlatDesignSystem.shadowOpacity),
                radius: FlatDesignSystem.shadowRadius,
                x: FlatDesignSystem.shadowOffset.width,
                y: FlatDesignSystem.shadowOffset.height
            )
    }
}

// MARK: - Flat Button Styles
struct PrimaryFlatButton: ViewModifier {
    let isEnabled: Bool
    
    func body(content: Content) -> some View {
        content
            .font(.system(size: 17, weight: .semibold))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, FlatDesignSystem.paddingM)
            .background(isEnabled ? FlatDesignSystem.primaryBlue : FlatDesignSystem.border)
            .cornerRadius(FlatDesignSystem.radiusM)
            .overlay(
                RoundedRectangle(cornerRadius: FlatDesignSystem.radiusM)
                    .stroke(isEnabled ? FlatDesignSystem.primaryBlue : FlatDesignSystem.border, lineWidth: 1)
            )
            .scaleEffect(isEnabled ? 1.0 : 0.98)
            .animation(.easeInOut(duration: 0.1), value: isEnabled)
    }
}

struct SecondaryFlatButton: ViewModifier {
    let isEnabled: Bool
    
    func body(content: Content) -> some View {
        content
            .font(.system(size: 17, weight: .medium))
            .foregroundColor(isEnabled ? FlatDesignSystem.primaryBlue : FlatDesignSystem.textSecondary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, FlatDesignSystem.paddingM)
            .background(FlatDesignSystem.background)
            .cornerRadius(FlatDesignSystem.radiusM)
            .overlay(
                RoundedRectangle(cornerRadius: FlatDesignSystem.radiusM)
                    .stroke(isEnabled ? FlatDesignSystem.primaryBlue : FlatDesignSystem.border, lineWidth: 1)
            )
            .scaleEffect(isEnabled ? 1.0 : 0.98)
            .animation(.easeInOut(duration: 0.1), value: isEnabled)
    }
}

// MARK: - Flat Text Field
struct FlatTextField: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, FlatDesignSystem.paddingM)
            .padding(.vertical, FlatDesignSystem.paddingM)
            .background(FlatDesignSystem.background)
            .cornerRadius(FlatDesignSystem.radiusM)
            .overlay(
                RoundedRectangle(cornerRadius: FlatDesignSystem.radiusM)
                    .stroke(FlatDesignSystem.border, lineWidth: 1)
            )
    }
}

// MARK: - Flat List Row
struct FlatListRow<Content: View>: View {
    let content: Content
    let backgroundColor: Color
    
    init(backgroundColor: Color = FlatDesignSystem.surface, @ViewBuilder content: () -> Content) {
        self.backgroundColor = backgroundColor
        self.content = content()
    }
    
    var body: some View {
        HStack(spacing: FlatDesignSystem.paddingM) {
            content
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(FlatDesignSystem.textSecondary)
                .font(.system(size: 14, weight: .medium))
        }
        .padding(.horizontal, FlatDesignSystem.paddingM)
        .padding(.vertical, FlatDesignSystem.paddingM)
        .background(backgroundColor)
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(FlatDesignSystem.border),
            alignment: .bottom
        )
    }
}

// MARK: - Flat Section Header
struct FlatSectionHeader: View {
    let title: String
    let subtitle: String?
    
    init(_ title: String, subtitle: String? = nil) {
        self.title = title
        self.subtitle = subtitle
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(FlatDesignSystem.text)
            
            if let subtitle = subtitle {
                Text(subtitle)
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(FlatDesignSystem.textSecondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, FlatDesignSystem.paddingM)
        .padding(.vertical, FlatDesignSystem.paddingS)
    }
}

// MARK: - Flat Toggle
struct FlatToggle: View {
    @Binding var isOn: Bool
    let title: String
    let subtitle: String?
    
    init(_ title: String, subtitle: String? = nil, isOn: Binding<Bool>) {
        self.title = title
        self.subtitle = subtitle
        self._isOn = isOn
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 17, weight: .medium))
                    .foregroundColor(FlatDesignSystem.text)
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.system(size: 15, weight: .regular))
                        .foregroundColor(FlatDesignSystem.textSecondary)
                }
            }
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .toggleStyle(SwitchToggleStyle(tint: FlatDesignSystem.primaryBlue))
        }
        .padding(.horizontal, FlatDesignSystem.paddingM)
        .padding(.vertical, FlatDesignSystem.paddingM)
        .background(FlatDesignSystem.surface)
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(FlatDesignSystem.border),
            alignment: .bottom
        )
    }
}

// MARK: - View Extensions
extension View {
    func primaryFlatButton(isEnabled: Bool = true) -> some View {
        self.modifier(PrimaryFlatButton(isEnabled: isEnabled))
    }
    
    func secondaryFlatButton(isEnabled: Bool = true) -> some View {
        self.modifier(SecondaryFlatButton(isEnabled: isEnabled))
    }
    
    func flatTextField() -> some View {
        self.modifier(FlatTextField())
    }
}

// MARK: - Animation Extensions
extension View {
    func flatButtonPress() -> some View {
        self.scaleEffect(0.98)
            .animation(.easeInOut(duration: 0.1), value: UUID())
    }
}
