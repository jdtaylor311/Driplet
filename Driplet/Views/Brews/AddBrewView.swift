//  AddBrewView.swift
//  CoffeeTracker
//  Created by jdtaylor311 on 8/12/25.

import SwiftUI
import PhotosUI
import SwiftData

typealias StructBrewTimeMarker = BrewTimeMarker

struct AddBrewView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\EnvironmentValues.modelContext) private var modelContext

    @State private var name: String = ""
    @State private var grindSize: String = ""
    @State private var method: String = ""
    @State private var notes: String = ""
    @State private var rating: Int = 0
    @State private var photoItem: PhotosPickerItem? = nil
    @State private var photoData: Data? = nil

    // Removed direct minute/second timing state, replaced with stopwatch state
    @State private var minutes: Int = 0
    @State private var seconds: Int = 0

    @State private var isUsingStopwatch = false
    @State private var stopwatchTime = 0
    @State private var stopwatchRunning = false
    @State private var timer: Timer? = nil

    @State private var showingMethodPicker = false
    @State private var showingTimePicker = false

    @State private var timeMarkers: [StructBrewTimeMarker] = []
    @State private var showingMarkerLabelsEditor = false

    // For editing multiple markers labels
    @State private var editedMarkers: [StructBrewTimeMarker] = []
    
    @State private var showingCamera = false
    @State private var showingPhotoSourceMenu = false
    @State private var showingPhotoPicker = false

    private let methodOptions = [
        "Pour Over",
        "French Press",
        "Espresso",
        "Aeropress",
        "Cold Brew",
        "Drip",
        "Moka Pot",
        "Siphon"
    ]

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
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        } else {
                            HStack {
                                Image(systemName: "photo")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .foregroundStyle(.secondary)
                                Text("Select Coffee Bag Photo")
                                    .foregroundStyle(.secondary)
                            }
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

                    Section(header: Text("Coffee Details").foregroundColor(.coffeeHeader).bold().font(.title3)) {
                        TextField("Coffee Name", text: $name)
                            .padding(8)
                            .background(Color.coffeeCard)
                            .cornerRadius(8)
                        TextField("Grind Size", text: $grindSize)
                            .padding(8)
                            .background(Color.coffeeCard)
                            .cornerRadius(8)
                        Button {
                            showingMethodPicker = true
                        } label: {
                            HStack {
                                Text("Method")
                                Spacer()
                                Text(method.isEmpty ? "Select" : method)
                                    .foregroundColor(method.isEmpty ? .secondary : .primary)
                            }
                            .padding(8)
                            .background(Color.coffeeCard)
                            .cornerRadius(8)
                        }
                        .sheet(isPresented: $showingMethodPicker) {
                            VStack(spacing: 0) {
                                HStack {
                                    Spacer()
                                    Button("Done") {
                                        showingMethodPicker = false
                                    }
                                    .padding()
                                    .foregroundColor(.coffeeAccent)
                                }
                                Picker("Method", selection: $method) {
                                    ForEach(methodOptions, id: \.self) { option in
                                        Text(option)
                                    }
                                }
                                .pickerStyle(.wheel)
                                .labelsHidden()
                            }
                            .presentationDetents([.medium])
                        }

                        Button {
                            showingTimePicker = true
                        } label: {
                            HStack {
                                Text("Time")
                                Spacer()
                                if isUsingStopwatch {
                                    Text(String(format: "%02d:%02d", stopwatchTime / 60, stopwatchTime % 60))
                                } else {
                                    Text(String(format: "%02d:%02d", minutes, seconds))
                                }
                            }
                            .padding(8)
                            .background(Color.coffeeCard)
                            .cornerRadius(8)
                        }
                        .sheet(isPresented: $showingTimePicker) {
                            VStack {
                                Picker("Time Input", selection: $isUsingStopwatch) {
                                    Text("Manual").tag(false)
                                    Text("Stopwatch").tag(true)
                                }
                                .pickerStyle(.segmented)
                                .padding(.horizontal)

                                if isUsingStopwatch {
                                    VStack {
                                        Text(String(format: "%02d:%02d", stopwatchTime / 60, stopwatchTime % 60))
                                            .font(.title)
                                            .monospacedDigit()
                                            .padding(.bottom)
                                        
                                        // Add Marker button shown only when running
                                        if stopwatchRunning {
                                            Button("Add Marker") {
                                                let newMarker = StructBrewTimeMarker(label: "", seconds: stopwatchTime)
                                                timeMarkers.append(newMarker)
                                            }
                                            .padding(.bottom, 8)
                                            .foregroundColor(.coffeeAccent)
                                        }

                                        TimelineView(
                                            stopwatchTime: stopwatchTime,
                                            markers: timeMarkers,
                                            totalTime: nil
                                        )
                                        .frame(height: 30)
                                        .padding(.bottom, 10)

                                        HStack(spacing: 16) {
                                            Button("Start") {
                                                guard !stopwatchRunning else { return }
                                                // Add "Start" marker at time 0 if not present
                                                if !timeMarkers.contains(where: { $0.seconds == 0 && $0.label == "Start" }) {
                                                    let startMarker = StructBrewTimeMarker(label: "Start", seconds: 0)
                                                    timeMarkers.append(startMarker)
                                                }
                                                stopwatchRunning = true
                                                timer?.invalidate()
                                                timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                                                    stopwatchTime += 1
                                                }
                                            }
                                            .disabled(stopwatchRunning)
                                            .foregroundColor(.coffeeAccent)
                                            Button("Pause") {
                                                guard stopwatchRunning else { return }
                                                // Add "End" marker at current stopwatchTime if not present
                                                if !timeMarkers.contains(where: { $0.seconds == stopwatchTime && $0.label == "End" }) {
                                                    let endMarker = StructBrewTimeMarker(label: "End", seconds: stopwatchTime)
                                                    timeMarkers.append(endMarker)
                                                }
                                                stopwatchRunning = false
                                                timer?.invalidate()
                                            }
                                            .disabled(!stopwatchRunning)
                                            .foregroundColor(.coffeeAccent)
                                            Button("Reset") {
                                                // If running and stopwatchTime > 0, add "End" marker at current time if not present
                                                if stopwatchRunning && stopwatchTime > 0 {
                                                    if !timeMarkers.contains(where: { $0.seconds == stopwatchTime && $0.label == "End" }) {
                                                        let endMarker = StructBrewTimeMarker(label: "End", seconds: stopwatchTime)
                                                        timeMarkers.append(endMarker)
                                                    }
                                                }
                                                stopwatchRunning = false
                                                timer?.invalidate()
                                                stopwatchTime = 0
                                                timeMarkers.removeAll()
                                            }
                                            .foregroundColor(.coffeeAccent)
                                        }

                                        if !timeMarkers.isEmpty {
                                            List {
                                                ForEach(timeMarkers, id: \.self) { marker in
                                                    HStack {
                                                        Text(String(format: "%02d:%02d", marker.seconds / 60, marker.seconds % 60))
                                                            .monospacedDigit()
                                                        Text(marker.label)
                                                    }
                                                }
                                            }
                                            .frame(maxHeight: 150)
                                        }
                                    }
                                    .padding(.vertical)
                                } else {
                                    HStack {
                                        Picker("Minutes", selection: $minutes) {
                                            ForEach(0..<10) { minute in
                                                Text("\(minute) min").tag(minute)
                                            }
                                        }
                                        .pickerStyle(.wheel)
                                        .frame(width: 80)

                                        Picker("Seconds", selection: $seconds) {
                                            ForEach(0..<60) { second in
                                                Text("\(second) sec").tag(second)
                                            }
                                        }
                                        .pickerStyle(.wheel)
                                        .frame(width: 80)
                                    }
                                }

                                Button("Done") {
                                    // If stopwatch was running and stopwatchTime > 0, add "End" marker at current time if not present
                                    if isUsingStopwatch {
                                        if stopwatchRunning && stopwatchTime > 0 {
                                            if !timeMarkers.contains(where: { $0.seconds == stopwatchTime && $0.label == "End" }) {
                                                let endMarker = StructBrewTimeMarker(label: "End", seconds: stopwatchTime)
                                                timeMarkers.append(endMarker)
                                            }
                                        }
                                        stopwatchRunning = false
                                        timer?.invalidate()

                                        // Prepare markers for editing labels
                                        // We allow editing all markers
                                        editedMarkers = timeMarkers

                                        showingMarkerLabelsEditor = true
                                    }
                                    showingTimePicker = false
                                }
                                .padding(.top)
                                .foregroundColor(.coffeeAccent)
                            }
                            .presentationDetents([.medium])
                            .onDisappear {
                                timer?.invalidate()
                            }
                        }

                        TextField("Notes", text: $notes, axis: .vertical)
                            .lineLimit(2...5)
                            .padding(8)
                            .background(Color.coffeeCard)
                            .cornerRadius(8)
                        HStack {
                            Text("Rating")
                            Spacer()
                            Picker("Rating", selection: $rating) {
                                ForEach(1...5, id: \.self) { n in
                                    Text("\(n)").tag(n)
                                }
                            }
                            .pickerStyle(.segmented)
                            .frame(width: 120)
                            .tint(.coffeeAccent)
                        }
                    }
                }
                .background(Color.coffeeCard)
                .cornerRadius(18)
                .shadow(radius: 8)
                .padding(.horizontal)
            }
            .navigationTitle("Add Brew")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(.coffeeAccent)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let timingString: String
                        if isUsingStopwatch {
                            timingString = String(format: "%d:%02d", stopwatchTime / 60, stopwatchTime % 60)
                        } else {
                            timingString = String(format: "%d:%02d", minutes, seconds)
                        }
                        let brew = CoffeeBrew(timestamp: Date(),
                                              photoData: photoData,
                                              name: name,
                                              grindSize: grindSize,
                                              method: method,
                                              timing: timingString,
                                              notes: notes,
                                              rating: rating == 0 ? nil : rating,
                                              markers: timeMarkers)
                        modelContext.insert(brew)
                        dismiss()
                    }
                    .disabled(name.isEmpty)
                    .foregroundColor(.coffeeAccent)
                }
            }
            .onDisappear {
                timer?.invalidate()
            }
            .sheet(isPresented: $showingMarkerLabelsEditor) {
                NavigationStack {
                    Form {
                        Section(header: Text("Edit Markers").foregroundColor(.coffeeHeader).bold().font(.title3)) {
                            if editedMarkers.isEmpty {
                                Text("No markers to edit.")
                            } else {
                                ForEach($editedMarkers) { $marker in
                                    HStack {
                                        Text(String(format: "%02d:%02d", marker.seconds / 60, marker.seconds % 60))
                                            .monospacedDigit()
                                        TextField("Label", text: $marker.label)
                                            .autocapitalization(.sentences)
                                            .padding(6)
                                            .background(Color.coffeeCard)
                                            .cornerRadius(8)
                                    }
                                }
                                .onDelete { indexSet in
                                    editedMarkers.remove(atOffsets: indexSet)
                                }
                            }
                        }
                    }
                    .navigationTitle("Markers")
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") {
                                // Discard edits, keep original timeMarkers
                                editedMarkers = []
                                showingMarkerLabelsEditor = false
                            }
                            .foregroundColor(.coffeeAccent)
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Done") {
                                // Save edited markers to main timeMarkers array
                                // Remove any markers with empty labels (optional, but better UX)
                                let filteredMarkers = editedMarkers.filter { !$0.label.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
                                timeMarkers = filteredMarkers
                                editedMarkers = []
                                showingMarkerLabelsEditor = false
                            }
                            .disabled(editedMarkers.allSatisfy { $0.label.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty })
                            .foregroundColor(.coffeeAccent)
                        }
                    }
                }
            }
            .sheet(isPresented: $showingCamera) {
                CameraPicker(imageData: $photoData)
            }
            .photosPicker(isPresented: $showingPhotoPicker, selection: $photoItem, matching: .images)
            .onChange(of: photoItem) { _, newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
                        photoData = data
                    }
                }
            }
        }
    }
}

struct TimelineView: View {
    let stopwatchTime: Int
    let markers: [StructBrewTimeMarker]
    let totalTime: Int?

    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width
            let height = geo.size.height

            let maxTime = max(stopwatchTime, 1)
            let referenceTime = (totalTime ?? maxTime)

            ZStack(alignment: .leading) {
                // Background bar
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: height / 3)
                    .cornerRadius(height / 6)
                    .position(x: width / 2, y: height / 2)

                // Progress bar
                Rectangle()
                    .fill(Color.accentColor)
                    .frame(width: CGFloat(stopwatchTime) / CGFloat(referenceTime) * width, height: height / 3)
                    .cornerRadius(height / 6)
                    .animation(.linear, value: stopwatchTime)

                // Markers
                ForEach(markers, id: \.self) { marker in
                    let markerPos = CGFloat(marker.seconds) / CGFloat(referenceTime) * width
                    VStack(spacing: 2) {
                        Rectangle()
                            .fill(Color.primary)
                            .frame(width: 2, height: height / 2)
                            .cornerRadius(1)
                        Circle()
                            .stroke(Color.primary, lineWidth: 1.5)
                            .background(Circle().fill(Color.white))
                            .frame(width: 10, height: 10)
                    }
                    .position(x: min(max(markerPos, 0), width), y: height / 2)
                    .accessibilityLabel("\(marker.label) at \(marker.seconds / 60) minutes and \(marker.seconds % 60) seconds")
                }
            }
        }
        .frame(height: 30)
    }
}

#Preview {
    AddBrewView()
        .modelContainer(for: CoffeeBrew.self, inMemory: true)
}

