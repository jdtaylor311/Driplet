import SwiftUI
import SwiftData

@Model
final class CoffeeBrew {
    var timestamp: Date
    var photoData: Data?
    var name: String
    var grindSize: String
    var method: String
    var timing: String
    var notes: String
    var rating: Int?
    var markers: [BrewTimeMarker] = []

    init(timestamp: Date, photoData: Data? = nil, name: String = "", grindSize: String = "", method: String = "", timing: String = "", notes: String = "", rating: Int? = nil, markers: [BrewTimeMarker] = []) {
        self.timestamp = timestamp
        self.photoData = photoData
        self.name = name
        self.grindSize = grindSize
        self.method = method
        self.timing = timing
        self.notes = notes
        self.rating = rating
        self.markers = markers
    }
}
