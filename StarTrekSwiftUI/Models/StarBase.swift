//
//  StarBase.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 5/11/25.
//

import Foundation

/* represents a StarBase that ships can dock at when they are adjacent */
struct StarBase : Locatable {
    var location: Location
    var name: String {return "StarBase"}
}
