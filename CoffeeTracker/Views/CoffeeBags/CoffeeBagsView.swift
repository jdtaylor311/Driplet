//  CoffeeBagsView.swift
//  CoffeeTracker
//
//  Shows a list of coffee bags and allows adding/removing them.

import SwiftUI
import SwiftData

struct CoffeeBagsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \CoffeeBag.name, order: .forward) private var bags: [CoffeeBag]
    @State private var showingAddBag = false

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(bags) { bag in
                            NavigationLink {
                                VStack(alignment: .leading, spacing: 8) {
                                    if let photoData = bag.photoData, let image = UIImage(data: photoData) {
                                        Image(uiImage: image)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: 150)
                                    }
                                    Text("Roaster: \(bag.roaster)")
                                    Text("Origin: \(bag.origin)")
                                    if let roastDate = bag.roastDate {
                                        Text("Roast Date: \(roastDate.formatted(date: .long, time: .omitted))")
                                    }
                                    if !bag.notes.isEmpty {
                                        Text("Notes: \(bag.notes)")
                                            .italic()
                                    }
                                }
                                .padding()
                                .navigationTitle(bag.name)
                            } label: {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(bag.name)
                                        .font(.headline)
                                    if !bag.roaster.isEmpty {
                                        Text(bag.roaster)
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                }
                                .padding()
                                .background(Color(.systemBackground))
                                .cornerRadius(16)
                                .shadow(radius: 4)
                                .padding(.horizontal)
                            }
                        }
                        .onDelete { indexSet in
                            for index in indexSet {
                                modelContext.delete(bags[index])
                            }
                        }
                    }
                    .padding(.vertical)
                }
                .background(
                    LinearGradient(
                        colors: [Color(red: 245/255, green: 236/255, blue: 219/255), Color(red: 250/255, green: 245/255, blue: 240/255)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .ignoresSafeArea()
                )
                .navigationTitle("Coffee Bags")

                Button {
                    withAnimation {
                        showingAddBag = true
                    }
                } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 56, height: 56)
                        .background(Circle().fill(Color.coffeeAccent))
                        .shadow(radius: 6)
                        .padding()
                }
                .transition(.scale.combined(with: .opacity))
            }
            .sheet(isPresented: $showingAddBag) {
                AddCoffeeBagView()
                    .modelContext(modelContext)
            }
        }
    }
}

#Preview {
    CoffeeBagsView()
        .modelContainer(for: CoffeeBag.self, inMemory: true)
}
