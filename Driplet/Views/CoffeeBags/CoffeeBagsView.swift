//  CoffeeBagsView.swift
//  CoffeeTracker
//
//  Shows a list of coffee bags and allows adding/removing them.

import SwiftUI
import SwiftData

struct CoffeeBagsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \CoffeeBag.name, order: .forward) private var bags: [CoffeeBag]
    @State private var roastFilter: RoastLevel? = nil // new filter state

    var filteredBags: [CoffeeBag] {
        if let roastFilter { return bags.filter { $0.roastLevel == roastFilter } }
        return bags
    }

    var body: some View {
        NavigationStack {
            Group {
                if bags.isEmpty {
                    ContentUnavailableView(
                        "No Bags Yet",
                        systemImage: "bag",
                        description: Text("Add a coffee bag with the + button.")
                    )
                } else {
                    List {
                        ForEach(filteredBags) { bag in
                            NavigationLink {
                                EditCoffeeBagView(bag: bag)
                            } label: {
                                HStack(alignment: .center) {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(bag.name)
                                            .font(.headline)
                                        if !bag.roaster.isEmpty {
                                            Text(bag.roaster)
                                                .font(.subheadline)
                                                .foregroundColor(.secondary)
                                        }
                                    }
                                    Spacer()
                                    Text(bag.roastLevel.shortName)
                                        .font(.caption2.weight(.bold))
                                        .padding(.vertical, 4)
                                        .padding(.horizontal, 8)
                                        .background(bag.roastLevel.color)
                                        .foregroundColor(bag.roastLevel.textColor)
                                        .clipShape(Capsule())
                                        .accessibilityLabel("Roast level \(bag.roastLevel.displayName)")
                                }
                                .padding(.vertical, 4)
                            }
                        }
                        .onDelete { indexSet in
                            // Need to map indices from filteredBags back to original bags
                            for index in indexSet {
                                let bag = filteredBags[index]
                                if let originalIndex = bags.firstIndex(where: { $0.id == bag.id }) {
                                    modelContext.delete(bags[originalIndex])
                                }
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("Coffee Bags")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button(role: roastFilter == nil ? .destructive : .none) {
                            roastFilter = nil
                        } label: {
                            Label("All Roasts", systemImage: roastFilter == nil ? "checkmark" : "")
                        }
                        Divider()
                        ForEach(RoastLevel.allCases) { level in
                            Button {
                                roastFilter = level
                            } label: {
                                HStack {
                                    Circle().fill(level.color).frame(width: 12, height: 12)
                                    Text(level.displayName)
                                    if roastFilter == level { Image(systemName: "checkmark") }
                                }
                            }
                        }
                    } label: {
                        if let roastFilter {
                            Text(roastFilter.displayName)
                                .font(.subheadline)
                                .padding(6)
                                .background(roastFilter.color.opacity(0.4))
                                .clipShape(Capsule())
                        } else {
                            Image(systemName: "line.3.horizontal.decrease.circle")
                        }
                    }
                    .accessibilityLabel("Filter Roast Level")
                }
            }
        }
    }
}

#Preview {
    CoffeeBagsView()
        .modelContainer(for: CoffeeBag.self, inMemory: true)
}
