//
//  CircleView.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 6/20/25.
//
//  Copyright (c) 2025 Kevin Lynch
//  This file is licensed under the MIT license
//

import SwiftUI

/// a simple shape that provides a path for a circle centered at the given point with the given radius
struct CircleView: Shape {
    var at: CGPoint
    var radius: Double
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addEllipse(in: circleRect())
        return path
    }
    
    ///return a CGRect for the circle
    private func circleRect() -> CGRect {
        let x = at.x - CGFloat(radius)
        let y = at.y - CGFloat(radius)
        let side = CGFloat(radius) * 2
        
        return CGRect(x: x, y: y, width: side, height: side)
    }
}

#Preview {
    CircleView(at: CGPoint(x: 50, y: 10), radius: 4)
}
