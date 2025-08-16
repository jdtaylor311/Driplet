//  EditCoffeeBagView.swift
//  CoffeeTracker
//
//  View for editing an existing CoffeeBag.

import SwiftUI
import PhotosUI
import SwiftData

struct EditCoffeeBagView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var bag: CoffeeBag

    @State private var draftName: String
    @State private var draftRoaster: String
    @State private var draftOrigin: String
    @State private var draftRoastDate: Date
    @State private var draftHasRoastDate: Bool
    @State private var draftNotes: String
    @State private var photoItem: PhotosPickerItem? = nil
    @State private var draftPhotoData: Data?
    @State private var draftRoastLevel: RoastLevel // new state
    
    @State private var showingCamera = false
    @State private var showingPhotoSourceMenu = false
    @State private var showingPhotoPicker = false
    
    init(bag: CoffeeBag) {
        self.bag = bag
        _draftName = State(initialValue: bag.name)
        _draftRoaster = State(initialValue: bag.roaster)
        _draftOrigin = State(initialValue: bag.origin)
        _draftRoastDate = State(initialValue: bag.roastDate ?? Date())
        _draftHasRoastDate = State(initialValue: bag.roastDate != nil)
        _draftNotes = State(initialValue: bag.notes)
        _draftPhotoData = State(initialValue: bag.photoData)
        _draftRoastLevel = State(initialValue: bag.roastLevel) // init roast level
    }

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient.coffeeBackground
                    .ignoresSafeArea()
                
                Form {
                    Button(action: { showingPhotoSourceMenu = true }) {
                        if let draftPhotoData, let uiImage = UIImage(data: draftPhotoData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 150)
                        } else {
                            HStack {
                                Image(systemName: "photo")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .foregroundStyle(.secondary)
                                Text("Select Bag Photo")
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    .confirmationDialog("Select Photo Source", isPresented: $showingPhotoSourceMenu) {
                        Button("Take Photo") { showingCamera = true }
                        Button("Choose from Library") { showingPhotoPicker = true }
                        if draftPhotoData != nil {
                            Button("Remove Photo", role: .destructive) { draftPhotoData = nil }
                        }
                        Button("Cancel", role: .cancel) {}
                    }
                    .sheet(isPresented: $showingCamera) {
                        CameraPicker(imageData: $draftPhotoData)
                    }
                    .photosPicker(isPresented: $showingPhotoPicker, selection: $photoItem, matching: .images)
                    .onChange(of: photoItem) { _, newItem in
                        Task {
                            if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                draftPhotoData = data
                            }
                        }
                    }

                    Section(header:
                        Text("Coffee Bag Details")
                            .foregroundStyle(.secondary)
                            .font(.system(size: 19, weight: .semibold))
                    ) {
                        TextField("Coffee Name", text: $draftName)
                            .textFieldStyle(.roundedBorder)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                        TextField("Roaster", text: $draftRoaster)
                            .textFieldStyle(.roundedBorder)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                        TextField("Origin", text: $draftOrigin)
                            .textFieldStyle(.roundedBorder)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                        Picker("Roast Level", selection: $draftRoastLevel) { // roast level picker
                            ForEach(RoastLevel.allCases) { level in
                                HStack {
                                    Circle().fill(level.color).frame(width: 14, height: 14)
                                    Text(level.displayName)
                                }.tag(level)
                            }
                        }
                        .pickerStyle(.menu)
                        Toggle("Has Roast Date", isOn: $draftHasRoastDate)
                        if draftHasRoastDate {
                            DatePicker("Roast Date", selection: $draftRoastDate, displayedComponents: .date)
                        }
                        TextField("Notes", text: $draftNotes, axis: .vertical)
                            .lineLimit(2...5)
                            .textFieldStyle(.roundedBorder)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                    }
                }
                .background(Color.coffeeCard)
                .cornerRadius(18)
                .shadow(radius: 8)
                .padding(.horizontal)
            }
            .navigationTitle("Edit Bag")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(.coffeeAccent)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        bag.name = draftName
                        bag.roaster = draftRoaster
                        bag.origin = draftOrigin
                        bag.roastDate = draftHasRoastDate ? draftRoastDate : nil
                        bag.notes = draftNotes
                        bag.photoData = draftPhotoData
                        bag.roastLevel = draftRoastLevel // save roast level
                        dismiss()
                    }
                    .disabled(draftName.isEmpty)
                    .foregroundColor(.coffeeAccent)
                }
            }
        }
    }
}
