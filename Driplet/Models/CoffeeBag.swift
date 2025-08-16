//  CoffeeBag.swift
//  CoffeeTracker
//
//  Model for tracking coffee bags.

import SwiftData
import Foundation
import SwiftUI

@Model
final class CoffeeBag {
    var name: String
    var roaster: String
    var origin: String
    var roastDate: Date?
    var notes: String
    var photoData: Data?
    var roastLevel: RoastLevel

    init(name: String = "", roaster: String = "", origin: String = "", roastDate: Date? = nil, notes: String = "", photoData: Data? = nil, roastLevel: RoastLevel) {
        self.name = name
        self.roaster = roaster
        self.origin = origin
        self.roastDate = roastDate
        self.notes = notes
        self.photoData = photoData
        self.roastLevel = roastLevel
    }
}

// MARK: - RoastLevel
enum RoastLevel: String, Codable, CaseIterable, Identifiable {
    case light
    case lightMedium
    case medium
    case mediumDark
    case dark

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .light: return "Light"
        case .lightMedium: return "Light-Med"
        case .medium: return "Medium"
        case .mediumDark: return "Med-Dark"
        case .dark: return "Dark"
        }
    }

    var shortName: String {
        switch self {
        case .light: return "L"
        case .lightMedium: return "L-M"
        case .medium: return "M"
        case .mediumDark: return "M-D"
        case .dark: return "D"
        }
    }

    var color: Color {
        switch self {
        case .light: return Color(hue: 0.09, saturation: 0.55, brightness: 0.95)
        case .lightMedium: return Color(hue: 0.08, saturation: 0.60, brightness: 0.80)
        case .medium: return Color(hue: 0.07, saturation: 0.65, brightness: 0.65)
        case .mediumDark: return Color(hue: 0.07, saturation: 0.70, brightness: 0.45)
        case .dark: return Color(hue: 0.07, saturation: 0.75, brightness: 0.30)
        }
    }

    var textColor: Color {
        switch self {
        case .mediumDark, .dark: return .white
        default: return .black
        }
    }
}
