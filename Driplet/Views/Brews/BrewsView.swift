import SwiftUI
import SwiftData

struct BrewsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \CoffeeBrew.timestamp, order: .reverse) private var brews: [CoffeeBrew]

    var body: some View {
        NavigationStack {
            Group {
                if brews.isEmpty {
                    ContentUnavailableView(
                        "No Brews Yet",
                        systemImage: "cup.and.saucer",
                        description: Text("Add a brew with the + button.")
                    )
                } else {
                    List {
                        ForEach(brews) { brew in
                            NavigationLink(destination: BrewDetailView(brew: brew)) {
                                HStack(alignment: .top, spacing: 12) {
                                    brewThumbnail(brew)
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(brew.name.isEmpty ? "Untitled Brew" : brew.name)
                                            .font(.headline)
                                        HStack(spacing: 8) {
                                            if !brew.method.isEmpty { Text(brew.method).foregroundColor(.secondary) }
                                            if !brew.timing.isEmpty { Text(brew.timing).foregroundColor(.secondary) }
                                        }
                                        if let rating = brew.rating { ratingStars(rating: rating) }
                                    }
                                }
                                .padding(.vertical, 4)
                            }
                        }
                        .onDelete { indexSet in
                            for index in indexSet { modelContext.delete(brews[index]) }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Brews")
        }
    }

    @ViewBuilder private func brewThumbnail(_ brew: CoffeeBrew) -> some View {
        if let data = brew.photoData, let uiImage = UIImage(data: data) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFill()
                .frame(width: 44, height: 44)
                .clipShape(RoundedRectangle(cornerRadius: 8))
        } else {
            ZStack {
                RoundedRectangle(cornerRadius: 8).fill(Color.coffeeCard)
                Image(systemName: "cup.and.saucer.fill")
                    .foregroundColor(.coffeeAccent)
            }
            .frame(width: 44, height: 44)
        }
    }

    private func ratingStars(rating: Int) -> some View {
        HStack(spacing: 2) {
            ForEach(1...5, id: \.self) { i in
                Image(systemName: i <= rating ? "star.fill" : "star")
                    .font(.caption2)
                    .foregroundColor(.coffeeAccent)
            }
        }
    }
}

struct BrewDetailView: View {
    @Bindable var brew: CoffeeBrew
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let data = brew.photoData, let uiImage = UIImage(data: data) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                GroupBox("Details") {
                    VStack(alignment: .leading, spacing: 8) {
                        labeled("Name", brew.name.isEmpty ? "—" : brew.name)
                        labeled("Method", brew.method.isEmpty ? "—" : brew.method)
                        labeled("Grind", brew.grindSize.isEmpty ? "—" : brew.grindSize)
                        labeled("Time", brew.timing.isEmpty ? "—" : brew.timing)
                        if let rating = brew.rating { labeled("Rating", String(repeating: "★", count: rating)) }
                        labeled("Date", brew.timestamp.formatted(date: .abbreviated, time: .shortened))
                    }
                }
                if !brew.notes.isEmpty {
                    GroupBox("Notes") { Text(brew.notes) }
                }
            }
            .padding()
        }
        .navigationTitle(brew.name.isEmpty ? "Brew" : brew.name)
        .navigationBarTitleDisplayMode(.inline)
    }

    private func labeled(_ title: String, _ value: String) -> some View {
        HStack(alignment: .top) {
            Text(title).font(.subheadline).foregroundColor(.secondary).frame(width: 70, alignment: .leading)
            Text(value).font(.body)
            Spacer()
        }
    }
}
