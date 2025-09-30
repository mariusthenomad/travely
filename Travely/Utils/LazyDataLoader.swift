import Foundation
import SwiftUI

// MARK: - Lazy Data Loader
class LazyDataLoader: ObservableObject {
    @Published var isLoading = false
    @Published var error: Error?
    
    private var cache: [String: Any] = [:]
    private let maxCacheSize = 50
    
    // MARK: - Lazy Loading Methods
    func loadData<T>(key: String, loader: @escaping () async throws -> T) async -> T? {
        // Check cache first
        if let cached = cache[key] as? T {
            return cached
        }
        
        // Load from source
        isLoading = true
        error = nil
        
        do {
            let data = try await loader()
            
            // Cache the result
            cache[key] = data
            
            // Manage cache size
            if cache.count > maxCacheSize {
                let keysToRemove = Array(cache.keys.prefix(cache.count - maxCacheSize))
                keysToRemove.forEach { cache.removeValue(forKey: $0) }
            }
            
            isLoading = false
            return data
        } catch {
            self.error = error
            isLoading = false
            return nil
        }
    }
    
    func clearCache() {
        cache.removeAll()
    }
    
    func getCachedData<T>(key: String, type: T.Type) -> T? {
        return cache[key] as? T
    }
}

// MARK: - Image Cache Manager
class ImageCacheManager: ObservableObject {
    static let shared = ImageCacheManager()
    private init() {}
    
    private var cache: [String: UIImage] = [:]
    private let maxCacheSize = 100
    
    func getImage(from url: String) async -> UIImage? {
        // Check cache first
        if let cachedImage = cache[url] {
            return cachedImage
        }
        
        // Load image
        guard let imageURL = URL(string: url) else { return nil }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: imageURL)
            guard let image = UIImage(data: data) else { return nil }
            
            // Cache the image
            cache[url] = image
            
            // Manage cache size
            if cache.count > maxCacheSize {
                let keysToRemove = Array(cache.keys.prefix(cache.count - maxCacheSize))
                keysToRemove.forEach { cache.removeValue(forKey: $0) }
            }
            
            return image
        } catch {
            print("Error loading image: \(error)")
            return nil
        }
    }
    
    func clearCache() {
        cache.removeAll()
    }
}

// MARK: - Async Image View
struct AsyncImageView: View {
    let url: String
    let placeholder: String
    @StateObject private var cacheManager = ImageCacheManager.shared
    @State private var image: UIImage?
    
    var body: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                Image(systemName: placeholder)
                    .font(.largeTitle)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(.systemGray6))
            }
        }
        .task {
            image = await cacheManager.getImage(from: url)
        }
    }
}

// MARK: - Performance Monitor
class PerformanceMonitor: ObservableObject {
    @Published var memoryUsage: Double = 0
    @Published var cpuUsage: Double = 0
    
    private var timer: Timer?
    
    func startMonitoring() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.updateMetrics()
        }
    }
    
    func stopMonitoring() {
        timer?.invalidate()
        timer = nil
    }
    
    private func updateMetrics() {
        // Memory usage
        let info = mach_task_basic_info()
        var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size)/4
        
        let kerr: kern_return_t = withUnsafeMutablePointer(to: &info) {
            $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                task_info(mach_task_self_,
                         task_flavor_t(MACH_TASK_BASIC_INFO),
                         $0,
                         &count)
            }
        }
        
        if kerr == KERN_SUCCESS {
            memoryUsage = Double(info.resident_size) / 1024 / 1024 // MB
        }
    }
}
