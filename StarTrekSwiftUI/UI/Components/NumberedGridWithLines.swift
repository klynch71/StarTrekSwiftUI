//
//  NumberedGridWithLines.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 6/2/25.
//

import SwiftUI

/**
 A grid with numbered row and column labels as well as gridlines.
 Usage:
    NumberedGridWithLines(
              rows: 8,
              columns: 8,
              rowHeaderWidth: 30,
              columnHeaderHeight: 30
          ) { row, col in
              Text("R\(row+1)C\(col+1)")
                  .frame(maxWidth: .infinity, maxHeight: .infinity)
          }
 
 NOTE: row, col are zero-based.
 */
struct NumberedGridWithLines<Content: View>: View {
    ///the number of rows in the grid not including the automatically generated numbered column label header
    let rows: Int
    
    ///the number of columns in the grid not including the automatically generated numbered row label headers
    let columns: Int
    
    ///the width of the labeled  row header column
    let rowHeaderWidth: CGFloat
    
    ///the height of the labeld column header column
    let columnHeaderHeight: CGFloat
    
    ///the content for each cell.  (Int, Int) will be in (row, col) order
    let content: (Int, Int) -> Content

    var body: some View {
        GeometryReader { geometry in
            let cellWidth = (geometry.size.width - rowHeaderWidth) / CGFloat(columns)
            let cellHeight = (geometry.size.height - columnHeaderHeight) / CGFloat(rows)

            VStack(spacing: 0) {
                // Column headers
                HStack(spacing: 0) {
                    // Empty top-left corner
                    headerCell("", width: rowHeaderWidth, height: columnHeaderHeight)

                    // Column headers
                    ForEach(0..<columns, id: \.self) { col in
                        headerCell("\(col + 1)", width: cellWidth, height: columnHeaderHeight)
                    }
                }

                // Grid rows
                ForEach(0..<rows, id: \.self) { row in
                    HStack(spacing: 0) {
                        // Row header
                        headerCell("\(row + 1)", width: rowHeaderWidth, height: cellHeight)

                        // Grid cells
                        ForEach(0..<columns, id: \.self) { col in
                            ZStack {
                                Rectangle()
                                    .stroke(Color.gray, lineWidth: 1)
                                content(row, col)
                            }
                            .frame(width: cellWidth, height: cellHeight)
                        }  //ForEach column
                    }  //HStack
                } //ForEach row
            } //VStack
        } //GeometryReader
    }

    /// return a headerCell View with the given text
    private func headerCell(_ text: String, width: CGFloat, height: CGFloat) -> some View {
        ZStack {
            Rectangle()
                .fill(Color.secondary.opacity(0.2))
                .border(Color.gray, width: 1)
            Text(text)
                .font(.system(size: 12, weight: .medium))
        }
        .frame(width: width, height: height)
    }
}

#Preview {
    NumberedGridWithLines(
                 rows: 4,
                 columns: 5,
                 rowHeaderWidth: 30,
                 columnHeaderHeight: 30
             ) { row, col in
                 Text("R\(row+1)C\(col+1)")
                     .frame(maxWidth: .infinity, maxHeight: .infinity)
             }
}
