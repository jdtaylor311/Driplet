import SwiftUI

struct BrewsView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: Text("Bag Details")) {
                    Label("Espresso Bag", systemImage: "bag.fill")
                        .symbolRenderingMode(.hierarchical)
                        .foregroundColor(Color.coffeeHeader)
                }
            }
            .navigationTitle("Bags")
        }
    }
}


struct AddItemView: View {
    var body: some View {
        Text("Add New Item")
            .font(.title)
            .padding()
    }
}
