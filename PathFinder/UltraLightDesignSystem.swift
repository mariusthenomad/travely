import SwiftUI

// MARK: - Ultra Light Modern Design System
struct UltraLightDesignSystem {
    
    // MARK: - Core Colors (Orange & Green Theme)
    static let primaryOrange = Color(red: 1.0, green: 0.58, blue: 0.0) // #FF9500
    static let lightOrange = Color(red: 1.0, green: 0.85, blue: 0.7) // #FFD9B3
    static let ultraLightOrange = Color(red: 1.0, green: 0.95, blue: 0.9) // #FFF2E6
    
    static let primaryGreen = Color(red: 0.2, green: 0.78, blue: 0.35) // #34C759
    static let lightGreen = Color(red: 0.7, green: 0.9, blue: 0.8) // #B3E6CC
    static let ultraLightGreen = Color(red: 0.9, green: 0.98, blue: 0.95) // #E6FAF0
    
    // MARK: - Neutral Colors (Ultra Light)
    static let background = Color(.systemBackground)
    static let surface = Color(.secondarySystemBackground)
    static let ultraLightSurface = Color.white.opacity(0.8)
    static let glassSurface = Color.white.opacity(0.1)
    
    static let text = Color(.label)
    static let textSecondary = Color(.secondaryLabel)
    static let textTertiary = Color(.tertiaryLabel)
    
    // MARK: - Spacing (Minimal & Clean)
    static let spaceXS: CGFloat = 2
    static let spaceS: CGFloat = 6
    static let spaceM: CGFloat = 12
    static let spaceL: CGFloat = 20
    static let spaceXL: CGFloat = 28
    static let spaceXXL: CGFloat = 36
    
    // MARK: - Corner Radius (Soft & Modern)
    static let radiusXS: CGFloat = 6
    static let radiusS: CGFloat = 10
    static let radiusM: CGFloat = 16
    static let radiusL: CGFloat = 24
    static let radiusXL: CGFloat = 32
    static let radiusRound: CGFloat = 50
    
    // MARK: - Shadows (Ultra Light)
    static let shadowLight = Color.black.opacity(0.02)
    static let shadowMedium = Color.black.opacity(0.04)
    static let shadowHeavy = Color.black.opacity(0.08)
    
    // MARK: - Blur Effects
    static let blurLight: CGFloat = 10
    static let blurMedium: CGFloat = 20
    static let blurHeavy: CGFloat = 30
}

// MARK: - Ultra Light Glass Card
struct UltraLightCard<Content: View>: View {
    let content: Content
    let style: CardStyle
    
    enum CardStyle {
        case glass
        case solid
        case gradient
        case minimal
    }
    
    init(style: CardStyle = .glass, @ViewBuilder content: () -> Content) {
        self.style = style
        self.content = content()
    }
    
    var body: some View {
        content
            .padding(UltraLightDesignSystem.spaceL)
            .background(backgroundView)
            .cornerRadius(UltraLightDesignSystem.radiusM)
            .shadow(
                color: UltraLightDesignSystem.shadowLight,
                radius: 8,
                x: 0,
                y: 4
            )
    }
    
    @ViewBuilder
    private var backgroundView: some View {
        switch style {
        case .glass:
            RoundedRectangle(cornerRadius: UltraLightDesignSystem.radiusM)
                .fill(UltraLightDesignSystem.glassSurface)
                .background(.ultraThinMaterial)
        case .solid:
            RoundedRectangle(cornerRadius: UltraLightDesignSystem.radiusM)
                .fill(UltraLightDesignSystem.ultraLightSurface)
        case .gradient:
            RoundedRectangle(cornerRadius: UltraLightDesignSystem.radiusM)
                .fill(
                    LinearGradient(
                        colors: [UltraLightDesignSystem.ultraLightOrange, UltraLightDesignSystem.ultraLightGreen],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        case .minimal:
            RoundedRectangle(cornerRadius: UltraLightDesignSystem.radiusM)
                .fill(UltraLightDesignSystem.background)
                .overlay(
                    RoundedRectangle(cornerRadius: UltraLightDesignSystem.radiusM)
                        .stroke(UltraLightDesignSystem.primaryOrange.opacity(0.1), lineWidth: 1)
                )
        }
    }
}

// MARK: - Ultra Light Button Styles
struct UltraLightButton: ViewModifier {
    let style: ButtonStyle
    let isEnabled: Bool
    let size: ButtonSize
    
    enum ButtonStyle {
        case primary
        case secondary
        case ghost
        case gradient
        case floating
    }
    
    enum ButtonSize {
        case small
        case medium
        case large
        
        var padding: CGFloat {
            switch self {
            case .small: return UltraLightDesignSystem.spaceM
            case .medium: return UltraLightDesignSystem.spaceL
            case .large: return UltraLightDesignSystem.spaceXL
            }
        }
        
        var fontSize: CGFloat {
            switch self {
            case .small: return 14
            case .medium: return 16
            case .large: return 18
            }
        }
    }
    
    func body(content: Content) -> some View {
        content
            .font(.system(size: size.fontSize, weight: .semibold, design: .rounded))
            .foregroundColor(textColor)
            .frame(maxWidth: .infinity)
            .padding(.vertical, size.padding)
            .background(backgroundView)
            .cornerRadius(UltraLightDesignSystem.radiusM)
            .scaleEffect(isEnabled ? 1.0 : 0.95)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isEnabled)
    }
    
    @ViewBuilder
    private var backgroundView: some View {
        switch style {
        case .primary:
            RoundedRectangle(cornerRadius: UltraLightDesignSystem.radiusM)
                .fill(isEnabled ? UltraLightDesignSystem.primaryOrange : UltraLightDesignSystem.textTertiary)
        case .secondary:
            RoundedRectangle(cornerRadius: UltraLightDesignSystem.radiusM)
                .fill(UltraLightDesignSystem.ultraLightOrange)
                .overlay(
                    RoundedRectangle(cornerRadius: UltraLightDesignSystem.radiusM)
                        .stroke(UltraLightDesignSystem.primaryOrange.opacity(0.3), lineWidth: 1)
                )
        case .ghost:
            RoundedRectangle(cornerRadius: UltraLightDesignSystem.radiusM)
                .fill(Color.clear)
                .overlay(
                    RoundedRectangle(cornerRadius: UltraLightDesignSystem.radiusM)
                        .stroke(UltraLightDesignSystem.primaryOrange, lineWidth: 2)
                )
        case .gradient:
            RoundedRectangle(cornerRadius: UltraLightDesignSystem.radiusM)
                .fill(
                    LinearGradient(
                        colors: [UltraLightDesignSystem.primaryOrange, UltraLightDesignSystem.primaryGreen],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
        case .floating:
            RoundedRectangle(cornerRadius: UltraLightDesignSystem.radiusRound)
                .fill(UltraLightDesignSystem.primaryOrange)
                .shadow(
                    color: UltraLightDesignSystem.primaryOrange.opacity(0.3),
                    radius: 12,
                    x: 0,
                    y: 6
                )
        }
    }
    
    private var textColor: Color {
        switch style {
        case .primary, .gradient, .floating:
            return .white
        case .secondary, .ghost:
            return UltraLightDesignSystem.primaryOrange
        }
    }
}

// MARK: - Ultra Light Text Field
struct UltraLightTextField: ViewModifier {
    let isFocused: Bool
    
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, UltraLightDesignSystem.spaceL)
            .padding(.vertical, UltraLightDesignSystem.spaceL)
            .background(
                RoundedRectangle(cornerRadius: UltraLightDesignSystem.radiusM)
                    .fill(UltraLightDesignSystem.ultraLightSurface)
                    .overlay(
                        RoundedRectangle(cornerRadius: UltraLightDesignSystem.radiusM)
                            .stroke(
                                isFocused ? UltraLightDesignSystem.primaryOrange : UltraLightDesignSystem.textTertiary,
                                lineWidth: isFocused ? 2 : 1
                            )
                    )
            )
            .animation(.easeInOut(duration: 0.2), value: isFocused)
    }
}

// MARK: - Ultra Light List Row
struct UltraLightListRow<Content: View>: View {
    let content: Content
    let hasChevron: Bool
    let action: (() -> Void)?
    
    init(hasChevron: Bool = true, action: (() -> Void)? = nil, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.hasChevron = hasChevron
        self.action = action
    }
    
    var body: some View {
        Button(action: action ?? {}) {
            HStack(spacing: UltraLightDesignSystem.spaceL) {
                content
                
                if hasChevron {
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(UltraLightDesignSystem.textTertiary)
                        .font(.system(size: 12, weight: .medium))
                }
            }
            .padding(.horizontal, UltraLightDesignSystem.spaceL)
            .padding(.vertical, UltraLightDesignSystem.spaceM)
            .background(UltraLightDesignSystem.ultraLightSurface)
            .cornerRadius(UltraLightDesignSystem.radiusS)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Ultra Light Section Header
struct UltraLightSectionHeader: View {
    let title: String
    let subtitle: String?
    let style: HeaderStyle
    
    enum HeaderStyle {
        case minimal
        case gradient
        case withIcon(String)
    }
    
    init(_ title: String, subtitle: String? = nil, style: HeaderStyle = .minimal) {
        self.title = title
        self.subtitle = subtitle
        self.style = style
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: UltraLightDesignSystem.spaceS) {
            HStack {
                switch style {
                case .minimal:
                    EmptyView()
                case .gradient:
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [UltraLightDesignSystem.primaryOrange, UltraLightDesignSystem.primaryGreen],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 8, height: 8)
                case .withIcon(let iconName):
                    Image(systemName: iconName)
                        .foregroundColor(UltraLightDesignSystem.primaryOrange)
                        .font(.system(size: 16, weight: .semibold))
                }
                
                Text(title)
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(UltraLightDesignSystem.text)
            }
            
            if let subtitle = subtitle {
                Text(subtitle)
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundColor(UltraLightDesignSystem.textSecondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, UltraLightDesignSystem.spaceL)
        .padding(.vertical, UltraLightDesignSystem.spaceM)
    }
}

// MARK: - Ultra Light Toggle
struct UltraLightToggle: View {
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
            VStack(alignment: .leading, spacing: UltraLightDesignSystem.spaceXS) {
                Text(title)
                    .font(.system(size: 17, weight: .semibold, design: .rounded))
                    .foregroundColor(UltraLightDesignSystem.text)
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.system(size: 15, weight: .medium, design: .rounded))
                        .foregroundColor(UltraLightDesignSystem.textSecondary)
                }
            }
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .toggleStyle(CustomToggleStyle())
        }
        .padding(.horizontal, UltraLightDesignSystem.spaceL)
        .padding(.vertical, UltraLightDesignSystem.spaceM)
        .background(UltraLightDesignSystem.ultraLightSurface)
        .cornerRadius(UltraLightDesignSystem.radiusS)
    }
}

// MARK: - Custom Toggle Style
struct CustomToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            
            Button {
                configuration.isOn.toggle()
            } label: {
                RoundedRectangle(cornerRadius: 16)
                    .fill(configuration.isOn ? UltraLightDesignSystem.primaryOrange : UltraLightDesignSystem.textTertiary)
                    .frame(width: 50, height: 30)
                    .overlay(
                        Circle()
                            .fill(.white)
                            .frame(width: 26, height: 26)
                            .offset(x: configuration.isOn ? 10 : -10)
                            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: configuration.isOn)
                    )
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}

// MARK: - Ultra Light Floating Action Button
struct UltraLightFAB: View {
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.white)
                .frame(width: 56, height: 56)
                .background(
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [UltraLightDesignSystem.primaryOrange, UltraLightDesignSystem.primaryGreen],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .shadow(
                            color: UltraLightDesignSystem.primaryOrange.opacity(0.4),
                            radius: 16,
                            x: 0,
                            y: 8
                        )
                )
        }
        .buttonStyle(UltraLightFABStyle())
    }
}

struct UltraLightFABStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

// MARK: - View Extensions
extension View {
    func ultraLightButton(
        style: UltraLightButton.ButtonStyle = .primary,
        size: UltraLightButton.ButtonSize = .medium,
        isEnabled: Bool = true
    ) -> some View {
        self.modifier(UltraLightButton(style: style, isEnabled: isEnabled, size: size))
    }
    
    func ultraLightTextField(isFocused: Bool = false) -> some View {
        self.modifier(UltraLightTextField(isFocused: isFocused))
    }
}

// MARK: - Trade Republic Style Navigation
struct TradeRepublicTabBar: View {
    @Binding var selectedTab: Int
    let tabs: [TabItem]
    
    struct TabItem {
        let icon: String
        let selectedIcon: String?
        let title: String
        let badge: String?
        
        init(icon: String, selectedIcon: String? = nil, title: String, badge: String? = nil) {
            self.icon = icon
            self.selectedIcon = selectedIcon ?? icon
            self.title = title
            self.badge = badge
        }
    }
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<tabs.count, id: \.self) { index in
                TabBarButton(
                    tab: tabs[index],
                    isSelected: selectedTab == index,
                    action: { selectedTab = index }
                )
            }
        }
        .padding(.horizontal, UltraLightDesignSystem.spaceL)
        .padding(.vertical, UltraLightDesignSystem.spaceM)
        .background(
            RoundedRectangle(cornerRadius: UltraLightDesignSystem.radiusL)
                .fill(UltraLightDesignSystem.ultraLightSurface)
                .shadow(
                    color: UltraLightDesignSystem.shadowLight,
                    radius: 20,
                    x: 0,
                    y: -5
                )
        )
        .padding(.horizontal, UltraLightDesignSystem.spaceL)
    }
}

struct TabBarButton: View {
    let tab: TradeRepublicTabBar.TabItem
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: UltraLightDesignSystem.spaceXS) {
                ZStack {
                    // Background circle for selected state
                    if isSelected {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [UltraLightDesignSystem.primaryOrange, UltraLightDesignSystem.primaryGreen],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 40, height: 40)
                            .scaleEffect(1.1)
                    }
                    
                    // Icon
                    Image(systemName: isSelected ? tab.selectedIcon : tab.icon)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(isSelected ? .white : UltraLightDesignSystem.textSecondary)
                        .scaleEffect(isSelected ? 1.1 : 1.0)
                    
                    // Badge
                    if let badge = tab.badge, !badge.isEmpty {
                        Text(badge)
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 4)
                            .padding(.vertical, 2)
                            .background(
                                Capsule()
                                    .fill(UltraLightDesignSystem.primaryGreen)
                            )
                            .offset(x: 15, y: -15)
                    }
                }
                
                // Title
                Text(tab.title)
                    .font(.system(size: 11, weight: .medium, design: .rounded))
                    .foregroundColor(isSelected ? UltraLightDesignSystem.primaryOrange : UltraLightDesignSystem.textSecondary)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: isSelected)
    }
}

// MARK: - Trade Republic Style Window Cards
struct TradeRepublicWindow<Content: View>: View {
    let content: Content
    let title: String?
    let subtitle: String?
    let style: WindowStyle
    
    enum WindowStyle {
        case standard
        case elevated
        case glass
        case minimal
    }
    
    init(
        title: String? = nil,
        subtitle: String? = nil,
        style: WindowStyle = .standard,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.subtitle = subtitle
        self.style = style
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: UltraLightDesignSystem.spaceL) {
            // Header
            if let title = title {
                VStack(alignment: .leading, spacing: UltraLightDesignSystem.spaceXS) {
                    Text(title)
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(UltraLightDesignSystem.text)
                    
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .foregroundColor(UltraLightDesignSystem.textSecondary)
                    }
                }
            }
            
            // Content
            content
        }
        .padding(UltraLightDesignSystem.spaceL)
        .background(backgroundView)
        .cornerRadius(UltraLightDesignSystem.radiusL)
        .shadow(
            color: shadowColor,
            radius: shadowRadius,
            x: 0,
            y: shadowOffset
        )
    }
    
    @ViewBuilder
    private var backgroundView: some View {
        switch style {
        case .standard:
            RoundedRectangle(cornerRadius: UltraLightDesignSystem.radiusL)
                .fill(UltraLightDesignSystem.ultraLightSurface)
        case .elevated:
            RoundedRectangle(cornerRadius: UltraLightDesignSystem.radiusL)
                .fill(UltraLightDesignSystem.background)
        case .glass:
            RoundedRectangle(cornerRadius: UltraLightDesignSystem.radiusL)
                .fill(UltraLightDesignSystem.glassSurface)
                .background(.ultraThinMaterial)
        case .minimal:
            RoundedRectangle(cornerRadius: UltraLightDesignSystem.radiusL)
                .fill(Color.clear)
                .overlay(
                    RoundedRectangle(cornerRadius: UltraLightDesignSystem.radiusL)
                        .stroke(UltraLightDesignSystem.primaryOrange.opacity(0.1), lineWidth: 1)
                )
        }
    }
    
    private var shadowColor: Color {
        switch style {
        case .standard: return UltraLightDesignSystem.shadowLight
        case .elevated: return UltraLightDesignSystem.shadowMedium
        case .glass: return UltraLightDesignSystem.shadowLight
        case .minimal: return Color.clear
        }
    }
    
    private var shadowRadius: CGFloat {
        switch style {
        case .standard: return 8
        case .elevated: return 16
        case .glass: return 12
        case .minimal: return 0
        }
    }
    
    private var shadowOffset: CGFloat {
        switch style {
        case .standard: return 4
        case .elevated: return 8
        case .glass: return 6
        case .minimal: return 0
        }
    }
}

// MARK: - Trade Republic Style List Items
struct TradeRepublicListItem: View {
    let icon: String
    let title: String
    let subtitle: String?
    let value: String?
    let action: (() -> Void)?
    
    init(
        icon: String,
        title: String,
        subtitle: String? = nil,
        value: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
        self.value = value
        self.action = action
    }
    
    var body: some View {
        Button(action: action ?? {}) {
            HStack(spacing: UltraLightDesignSystem.spaceL) {
                // Icon
                ZStack {
                    Circle()
                        .fill(UltraLightDesignSystem.ultraLightOrange)
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(UltraLightDesignSystem.primaryOrange)
                }
                
                // Content
                VStack(alignment: .leading, spacing: UltraLightDesignSystem.spaceXS) {
                    Text(title)
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundColor(UltraLightDesignSystem.text)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .foregroundColor(UltraLightDesignSystem.textSecondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                
                // Value
                if let value = value {
                    Text(value)
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(UltraLightDesignSystem.primaryGreen)
                }
                
                // Chevron
                if action != nil {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(UltraLightDesignSystem.textTertiary)
                }
            }
            .padding(.horizontal, UltraLightDesignSystem.spaceL)
            .padding(.vertical, UltraLightDesignSystem.spaceM)
            .background(UltraLightDesignSystem.ultraLightSurface)
            .cornerRadius(UltraLightDesignSystem.radiusM)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Animation Extensions
extension View {
    func ultraLightPress() -> some View {
        self.scaleEffect(0.95)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: UUID())
    }
    
    func ultraLightHover() -> some View {
        self.scaleEffect(1.02)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: UUID())
    }
    
    func tradeRepublicBounce() -> some View {
        self.scaleEffect(0.98)
            .animation(.spring(response: 0.4, dampingFraction: 0.6), value: UUID())
    }
}
