//
//  LineView.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 6/19/25.
//

import SwiftUI

/// A simple shape that draws a straight line from one point to another
struct LineView: Shape {
    var from: CGPoint
    var to: CGPoint

    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: from)
        path.addLine(to: to)
        return path
    }
}

#Preview {
    LineView(from: CGPoint(x: 0, y: 0), to: CGPoint(x: 100, y: 100))
}
