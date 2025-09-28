# UI Design Guide - Travely

## Design Principles

### Flat Design Concept
- **Minimalist**: Less shadows, more focus on content
- **Clarity**: Simple, clear lines and structures
- **Hierarchy**: Visual focus through typography and spacing
- **Consistency**: Unified design system across all tabs

---

## Tab-Specific Design Updates

### Home Tab
**Current elements to be revised:**
- [ ] Flatten card designs (reduce shadows)
- [ ] Simplify button styles
- [ ] Optimize spacing between elements
- [ ] Improve typography hierarchy

**Design Guidelines:**
```swift
// Flache Card Styles
.card {
    backgroundColor: .systemBackground
    cornerRadius: 12
    shadowOpacity: 0.05  // Reduziert von aktuellen Werten
    borderWidth: 1
    borderColor: .systemGray5
}

// Button Styles
.primaryButton {
    backgroundColor: .systemBlue
    cornerRadius: 8
    shadowOpacity: 0
}
```

### Routes Tab
**Functionality Updates:**
- [ ] **Left-Swipe**: Add Edit button next to Delete button
- [ ] **Right-Swipe**: Remove current edit function
- [ ] **Swipe Gestures**: Implement new gesture handlers

**Design Updates:**
- [ ] Flatten route list
- [ ] Visually improve swipe actions
- [ ] Consistently style Edit/Delete buttons

```swift
// Swipe Actions Design
.swipeAction {
    backgroundColor: .systemRed    // Delete
    backgroundColor: .systemBlue   // Edit
    cornerRadius: 8
    shadowOpacity: 0
}
```

### Destination Tab
**Design Updates:**
- [ ] Flatten destination cards
- [ ] Simplify search interface
- [ ] Design filter options minimally
- [ ] Consistently style detail views

### Settings Tab
**New Features:**
- [ ] **Subscription Management**: App Store purchase restore button
- [ ] **Account Settings**: Login/Logout sections
- [ ] **Theme Options**: Dark/Light Mode toggle

**Design Updates:**
- [ ] Flatten settings groups
- [ ] Modernize toggle switches
- [ ] Simplify section headers

---

## Design System

### Farbpalette
```swift
// Primary Colors
.primaryBlue: #007AFF
.secondaryBlue: #5AC8FA
.accentGreen: #34C759

// Neutral Colors
.background: .systemBackground
.surface: .secondarySystemBackground
.border: .systemGray5
.text: .label
.textSecondary: .secondaryLabel
```

### Typografie
```swift
// Headers
.largeTitle: 34pt, .bold
.title1: 28pt, .bold
.title2: 22pt, .bold
.title3: 20pt, .semibold

// Body Text
.body: 17pt, .regular
.bodyBold: 17pt, .semibold
.caption: 12pt, .regular
.footnote: 13pt, .regular
```

### Spacing System
```swift
// Spacing Scale
.paddingXS: 4pt
.paddingS: 8pt
.paddingM: 16pt
.paddingL: 24pt
.paddingXL: 32pt
```

### Corner Radius
```swift
// Border Radius Scale
.radiusS: 4pt
.radiusM: 8pt
.radiusL: 12pt
.radiusXL: 16pt
```

---

## Component Library

### Cards
```swift
struct FlatCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Content
        }
        .padding(.paddingM)
        .background(Color.surface)
        .cornerRadius(.radiusL)
        .overlay(
            RoundedRectangle(cornerRadius: .radiusL)
                .stroke(Color.border, lineWidth: 1)
        )
    }
}
```

### Buttons
```swift
struct PrimaryButton: View {
    var body: some View {
        Button(action: {}) {
            Text("Button Text")
                .font(.bodyBold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.paddingM)
                .background(Color.primaryBlue)
                .cornerRadius(.radiusM)
        }
    }
}
```

### Lists
```swift
struct FlatListRow: View {
    var body: some View {
        HStack(spacing: .paddingM) {
            // Content
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.textSecondary)
                .font(.caption)
        }
        .padding(.paddingM)
        .background(Color.surface)
    }
}
```

---

## Animation Guidelines

### Micro-Interactions
- **Button Press**: Subtle scale animation (0.98x)
- **Card Tap**: Gentle highlight effect
- **Swipe Actions**: Smooth slide-in animations
- **Page Transitions**: Fade or slide effects

### Transition Timing
```swift
// Animation Durations
.short: 0.2s
.medium: 0.3s
.long: 0.5s

// Easing Curves
.easeInOut: easeInOut
.spring: spring(damping: 0.8)
```

---

## Responsive Design

### Breakpoints
- **iPhone SE**: 375x667
- **iPhone Standard**: 375x812
- **iPhone Plus**: 414x896
- **iPhone Pro Max**: 428x926

### Adaptive Layouts
- **Portrait**: Standard mobile layout
- **Landscape**: Optimized for horizontal viewing
- **Accessibility**: Support for Dynamic Type

---

## Design Checklist

### Visual Design
- [ ] Alle Schatten reduziert/entfernt
- [ ] Konsistente Farbpalette verwendet
- [ ] Einheitliche Typografie implementiert
- [ ] Spacing-System befolgt
- [ ] Corner-Radius konsistent

### Interaktionen
- [ ] Swipe-Gesten in Routes aktualisiert
- [ ] Button-Animationen hinzugefügt
- [ ] Micro-Interactions implementiert
- [ ] Accessibility Features getestet

### Responsiveness
- [ ] Alle Screen-Größen getestet
- [ ] Landscape-Mode optimiert
- [ ] Dark Mode Support
- [ ] Dynamic Type Support

---

*UI Design Guide - Travely iOS App*
