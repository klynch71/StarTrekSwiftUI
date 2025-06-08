//
//  LongRangeSensorView.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 5/21/25.
//

import SwiftUI

/*
 Scan adjacent sectors to where the Enterprise
 is currently located. 
 */
struct LongRangeSensorView: View {
    @EnvironmentObject var model: AppState
    let columns = Array(repeating: GridItem(.flexible()), count: 3)
    
    var body: some View {
        
        GeometryReader { geometry in
            //get the adjacent quadrants to the enterprise
            let quadrants = Galaxy.adjacentQuadrants(to: model.enterprise.location)
            let rows = quadrants.count / columns.count
            let cellWidth = geometry.size.width  / CGFloat(columns.count)
            let cellHeight = geometry.size.height / CGFloat(rows)
            
            LazyVGrid(columns: columns, spacing: 0) {
                ForEach(quadrants.indices, id:\.self) { index in
                    ZStack {
                        QuadrantExplorerView(quadrant: quadrants[index])
                            .font(.title)
                            .frame(width: cellWidth, height: cellHeight)
                    }.border(Color.white.opacity(0.5), width: 0.5)
                }
            }
            
        }
    }
}

#Preview {
    LongRangeSensorView()
        .environmentObject(AppState())
}
