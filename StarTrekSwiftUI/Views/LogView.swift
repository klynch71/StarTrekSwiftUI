//
//  LogView.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 5/22/25.
//

import SwiftUI

struct LogView: View {
    let location = Location(x: 1, y: 2)
    var body: some View {
        VStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            Text(getText())
        }
        
    }
    
    func getText() -> String {
 
        var loc1 = Location(x: 1, y: 1)
        let course = Course(degrees: 0)
        let distance = 1.0
        
        for _ in 0...10 {
            let newLoc = loc1.offset(by: course, distance: distance)
            var s = "?"
            if let sector = newLoc.sector {
                s = String(sector.id)
            }
            print("(\(newLoc.x), \(newLoc.y)) in Sector: \(s)")
            loc1 = newLoc
        }
        
 
        
        return ("Hello")
    }
}

#Preview {
    LogView()
}
