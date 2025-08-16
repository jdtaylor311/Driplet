//  CoffeeBag.swift
//  CoffeeTracker
//
//  Model for tracking coffee bags.

import SwiftData
import Foundation

@Model
final class CoffeeBag {
    var name: String
    var roaster: String
    var origin: String
    var roastDate: Date?
    var notes: String
    var photoData: Data?

    init(name: String = "", roaster: String = "", origin: String = "", roastDate: Date? = nil, notes: String = "", photoData: Data? = nil) {
        self.name = name
        self.roaster = roaster
        self.origin = origin
        self.roastDate = roastDate
        self.notes = notes
        self.photoData = photoData
    }
}
