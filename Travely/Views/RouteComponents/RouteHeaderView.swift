import SwiftUI

struct RouteHeaderView: View {
    let route: TravelRoute
    @State private var showingPriceBreakdown = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Route Title and Description
            VStack(alignment: .leading, spacing: 8) {
                Text(route.title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text(route.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(3)
            }
            
            // Route Stats
            HStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Duration")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(route.duration)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Total Price")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("€\(route.totalPrice)")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.orange)
                }
                
                Spacer()
                
                Button(action: {
                    showingPriceBreakdown = true
                }) {
                    Text("View Details")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.orange)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.orange.opacity(0.1))
                        .cornerRadius(8)
                }
            }
        }
        .padding(20)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        .sheet(isPresented: $showingPriceBreakdown) {
            PriceBreakdownView(priceBreakdown: route.priceBreakdown)
        }
    }
}

struct PriceBreakdownView: View {
    let priceBreakdown: [PriceItem]
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            List {
                ForEach(priceBreakdown) { item in
                    HStack {
                        Text(item.item)
                            .font(.subheadline)
                        
                        Spacer()
                        
                        Text("€\(item.price)")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.orange)
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("Price Breakdown")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                trailing: Button("Done") {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
}

#Preview {
    RouteHeaderView(route: TravelRoute(
        id: 1,
        title: "Sample Route",
        description: "Sample description",
        duration: "7 Days",
        totalPrice: 1500,
        imageURL: "",
        stops: [],
        priceBreakdown: []
    ))
}
