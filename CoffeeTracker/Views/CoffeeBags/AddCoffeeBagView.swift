//  AddCoffeeBagView.swift
//  CoffeeTracker
//
//  View for adding a new CoffeeBag.

import SwiftUI
import PhotosUI
import SwiftData

struct AddCoffeeBagView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var name: String = ""
    @State private var roaster: String = ""
    @State private var origin: String = ""
    @State private var roastDate: Date = Date()
    @State private var notes: String = ""
    @State private var photoItem: PhotosPickerItem? = nil
    @State private var photoData: Data? = nil
    @State private var hasRoastDate: Bool = false
    
    @State private var showingCamera = false
    @State private var showingPhotoSourceMenu = false
    @State private var showingPhotoPicker = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient.coffeeBackground
                    .ignoresSafeArea()
                
                Form {
                    Button {
                        showingPhotoSourceMenu = true
                    } label: {
                        if let photoData, let uiImage = UIImage(data: photoData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 150)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        } else {
                            HStack {
                                Image(systemName: "photo")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .foregroundStyle(.secondary)
                                Text("Select Bag Photo")
                                    .foregroundStyle(.secondary)
                            }
                            .frame(maxWidth: .infinity, minHeight: 150)
                            .background(Color.coffeeCard.opacity(0.6))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    }
                    .confirmationDialog("Select Photo Source", isPresented: $showingPhotoSourceMenu) {
                        Button("Take Photo") {
                            showingCamera = true
                        }
                        Button("Choose from Library") {
                            showingPhotoPicker = true
                        }
                        if photoData != nil {
                            Button("Remove Photo", role: .destructive) {
                                photoData = nil
                                photoItem = nil
                            }
                        }
                        Button("Cancel", role: .cancel) { }
                    }

                    Section {
                        TextField("Coffee Name", text: $name)
                            .textFieldStyle(.roundedBorder)
                        TextField("Roaster", text: $roaster)
                            .textFieldStyle(.roundedBorder)
                        TextField("Origin", text: $origin)
                            .textFieldStyle(.roundedBorder)
                        Toggle("Has Roast Date", isOn: $hasRoastDate)
                        if hasRoastDate {
                            DatePicker("Roast Date", selection: $roastDate, displayedComponents: .date)
                                .datePickerStyle(.compact)
                                .padding(.vertical, 4)
                        }
                        TextField("Notes", text: $notes, axis: .vertical)
                            .lineLimit(2...5)
                            .textFieldStyle(.roundedBorder)
                    } header: {
                        Text("Coffee Bag Details")
                            .fontWeight(.bold)
                            .foregroundColor(Color.coffeeHeader)
                    }
                }
                .background(Color.coffeeCard)
                .cornerRadius(18)
                .shadow(radius: 8)
                .padding(.horizontal)
            }
            .navigationTitle("Add Bag")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .tint(Color.coffeeAccent)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let bag = CoffeeBag(
                            name: name,
                            roaster: roaster,
                            origin: origin,
                            roastDate: hasRoastDate ? roastDate : nil,
                            notes: notes,
                            photoData: photoData
                        )
                        modelContext.insert(bag)
                        dismiss()
                    }
                    .disabled(name.isEmpty)
                    .tint(Color.coffeeAccent)
                }
            }
            .sheet(isPresented: $showingCamera) {
                CameraPicker(imageData: $photoData)
            }
            .photosPicker(isPresented: $showingPhotoPicker, selection: $photoItem, matching: .images)
            .onChange(of: photoItem) { _, newItem in
                Task { @MainActor in
                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
                        photoData = data
                    }
                }
            }
        }
    }
}

#Preview {
    AddCoffeeBagView()
        .modelContainer(for: CoffeeBag.self, inMemory: true)
}
