//
//  Locatable.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 5/14/25.
//

import Foundation

/*
 A Locatable protcol for objects in the Galaxy
 */
protocol Locatable {
    var location: Location { get }
    var name: String { get }
}
