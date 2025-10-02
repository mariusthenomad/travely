import SwiftUI

// App Icon for 1024x1024 (App Store)
struct AppIcon1024: View {
    var body: some View {
        AppIconView(size: 1024)
    }
}

// App Icon for 180x180 (iPhone 6 Plus, 7 Plus, 8 Plus, X, XS, XS Max, 11 Pro Max, 12 Pro Max, 13 Pro Max, 14 Pro Max, 15 Pro Max)
struct AppIcon180: View {
    var body: some View {
        AppIconView(size: 180)
    }
}

// App Icon for 167x167 (iPad Pro 12.9")
struct AppIcon167: View {
    var body: some View {
        AppIconView(size: 167)
    }
}

// App Icon for 152x152 (iPad Pro 11")
struct AppIcon152: View {
    var body: some View {
        AppIconView(size: 152)
    }
}

// App Icon for 120x120 (iPhone 6, 7, 8, X, XS, 11 Pro, 12, 12 Pro, 13, 13 Pro, 14, 14 Pro, 15, 15 Pro)
struct AppIcon120: View {
    var body: some View {
        AppIconView(size: 120)
    }
}

// App Icon for 87x87 (iPhone 6 Plus, 7 Plus, 8 Plus, X, XS, XS Max, 11 Pro Max, 12 Pro Max, 13 Pro Max, 14 Pro Max, 15 Pro Max)
struct AppIcon87: View {
    var body: some View {
        AppIconView(size: 87)
    }
}

// App Icon for 80x80 (iPad, iPad Air, iPad mini)
struct AppIcon80: View {
    var body: some View {
        AppIconView(size: 80)
    }
}

// App Icon for 76x76 (iPad, iPad Air, iPad mini)
struct AppIcon76: View {
    var body: some View {
        AppIconView(size: 76)
    }
}

// App Icon for 60x60 (iPhone 6, 7, 8, X, XS, 11 Pro, 12, 12 Pro, 13, 13 Pro, 14, 14 Pro, 15, 15 Pro)
struct AppIcon60: View {
    var body: some View {
        AppIconView(size: 60)
    }
}

// App Icon for 58x58 (iPhone 6 Plus, 7 Plus, 8 Plus, X, XS, XS Max, 11 Pro Max, 12 Pro Max, 13 Pro Max, 14 Pro Max, 15 Pro Max)
struct AppIcon58: View {
    var body: some View {
        AppIconView(size: 58)
    }
}

// App Icon for 40x40 (iPhone 6, 7, 8, X, XS, 11 Pro, 12, 12 Pro, 13, 13 Pro, 14, 14 Pro, 15, 15 Pro)
struct AppIcon40: View {
    var body: some View {
        AppIconView(size: 40)
    }
}

// App Icon for 29x29 (iPhone 6, 7, 8, X, XS, 11 Pro, 12, 12 Pro, 13, 13 Pro, 14, 14 Pro, 15, 15 Pro)
struct AppIcon29: View {
    var body: some View {
        AppIconView(size: 29)
    }
}

// App Icon for 20x20 (iPhone 6, 7, 8, X, XS, 11 Pro, 12, 12 Pro, 13, 13 Pro, 14, 14 Pro, 15, 15 Pro)
struct AppIcon20: View {
    var body: some View {
        AppIconView(size: 20)
    }
}

#Preview {
    ScrollView {
        VStack(spacing: 20) {
            Text("App Icon Sizes")
                .font(.title)
                .fontWeight(.bold)
            
            VStack(spacing: 16) {
                AppIcon1024()
                AppIcon180()
                AppIcon167()
                AppIcon152()
                AppIcon120()
                AppIcon87()
                AppIcon80()
                AppIcon76()
                AppIcon60()
                AppIcon58()
                AppIcon40()
                AppIcon29()
                AppIcon20()
            }
        }
        .padding()
    }
}
