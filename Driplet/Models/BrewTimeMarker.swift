import Foundation
struct BrewTimeMarker: Codable, Identifiable, Hashable {
    var id = UUID()
    var label: String
    var seconds: Int
}
