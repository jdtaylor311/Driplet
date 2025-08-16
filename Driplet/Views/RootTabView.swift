import SwiftUI

struct RootTabView: View {
    @State private var selectedTab = 0
    @State private var showingAddCoffeeBag = false
    @State private var showingAddBrew = false
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            TabView(selection: $selectedTab) {
                CoffeeBagsView()
                    .tabItem {
                        Label("Bags", systemImage: "bag.fill")
                    }
                    .tag(0)
                BrewsView()
                    .tabItem {
                        Label("Brews", systemImage: "cup.and.saucer.fill")
                    }
                    .tag(1)
            }
            .tint(Color.coffeeAccent)

            Button(action: {
                if selectedTab == 0 {
                    showingAddCoffeeBag = true
                } else if selectedTab == 1 {
                    showingAddBrew = true
                }
            }) {
                Image(systemName: "plus")
                    .foregroundColor(.white)
                    .font(.system(size: 24, weight: .bold))
                    .padding()
                    .background(Color.coffeeAccent)
                    .clipShape(Circle())
                    .shadow(radius: 4)
            }
            .padding()
            .accessibilityLabel(selectedTab == 0 ? "Add Coffee Bag" : "Add Brew")
            .sheet(isPresented: $showingAddCoffeeBag) {
                AddCoffeeBagView()
            }
            .sheet(isPresented: $showingAddBrew) {
                AddBrewView()
            }
        }
    }
}

#Preview {
    RootTabView()
}
