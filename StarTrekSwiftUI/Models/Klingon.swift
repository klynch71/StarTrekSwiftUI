//
//  Klingon.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 5/16/25.
//

import Foundation

/*
 a Klingon ship
 */
struct Klingon: Locatable {
    var location: Location
    var energy: Int
    var name:String {return "Klingon"}
    
    init(location: Location, energy: Int) {
        self.location = location
        self.energy = energy
    }
}

