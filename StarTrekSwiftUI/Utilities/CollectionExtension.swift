//
//  CollectionExtension.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 6/14/25.
//

///a simple extenstion to provide safe access to arrays by checking for index out of bound exceptions
extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
