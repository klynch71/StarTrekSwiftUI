//
//  GridWithLines.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 6/4/25.
//
//  Copyright (c) 2025 Kevin Lynch
//  This file is licensed under the MIT license
//

import SwiftUI

/**
 A grid with gridlines.  Setting border on a LazyVGrid is problematic as sometimes you will get two lines where one is expected.
 This implementation ensures only one line between cells.
 
 Usage:
    dGridWithLines(
              rows: 8,
              columns: 8,
              lineColor: .gray
              lineWidth: 1
          ) { row, col in
              Text("R\(row+1)C\(col+1)")
                  .frame(maxWidth: .infinity, maxHeight: .infinity)
          }
 
 NOTE: row, col are zero-based.
 */
struct GridWithLines<Content: View>: View {
    ///the number of rows in the Grid
    let rows: Int
    
    ///the number of columns in the Grid
    let columns: Int
    
    ///the grid line color
    let lineColor: Color
    
    ///the grid line width
    let lineWidth: CGFloat
    
    ///the content that should be displayed for every gird cell.  (Int, Int) will be (row, col) order.
    let content: (Int, Int) -> Content

    var body: some View {
        GeometryReader { geometry in
            let cellWidth = (geometry.size.width) / CGFloat(columns)
            let cellHeight = (geometry.size.height) / CGFloat(rows)

            VStack(spacing: 0) {
                // Grid rows
                ForEach(0..<rows, id: \.self) { row in
                    HStack(spacing: 0) {
                        // Grid cells
                        ForEach(0..<columns, id: \.self) { col in
                            ZStack {
                                Rectangle()
                                    .stroke(Color.gray, lineWidth: 1)
                                content(row, col)
                            }
                            .frame(width: cellWidth, height: cellHeight)
                        }
                    } //HStack
                } //ForEach
            } //VStack
        }  //GeometryReader
    }
}

#Preview {
    GridWithLines(rows: 4, columns: 5, lineColor: Color.gray, lineWidth: 1) { row, col in
                 Text("R\(row+1)C\(col+1)")
                     .frame(maxWidth: .infinity, maxHeight: .infinity)
             }
}

