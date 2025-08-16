import SwiftUI

extension Color {
    // Main accent: Rich coffee brown
    static let coffeeAccent = Color(red: 94 / 255, green: 56 / 255, blue: 17 / 255)
    // Warm golden for highlights
    static let coffeeGold = Color(red: 198 / 255, green: 143 / 255, blue: 52 / 255)
    // Creamy tan background
    static let coffeeBackgroundTop = Color(red: 242 / 255, green: 228 / 255, blue: 215 / 255)
    // Near-white, for bottom gradient
    static let coffeeBackgroundBottom = Color(red: 251 / 255, green: 248 / 255, blue: 244 / 255)
    // Card background
    static let coffeeCard = Color.white.opacity(0.95)
    // Section header text
    static let coffeeHeader = Color(red: 128 / 255, green: 93 / 255, blue: 57 / 255)
}

extension LinearGradient {
    static let coffeeBackground = LinearGradient(
        gradient: Gradient(colors: [.coffeeBackgroundTop, .coffeeBackgroundBottom]),
        startPoint: .top, endPoint: .bottom
    )
}
