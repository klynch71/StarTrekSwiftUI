//
//  CollectionExtension.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 6/14/25.
//

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
