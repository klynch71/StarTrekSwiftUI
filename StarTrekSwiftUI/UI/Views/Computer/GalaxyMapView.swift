//
//  GalaxyGridView.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 5/23/25.
//

import SwiftUI

/// Displays a grid-based galaxy map with quadrant coordinates and star system names.
/// - Uses a fixed number of rows and columns defined in `Galaxy`.
/// - Row and column headers are labeled numerically.
/// - Star system names are displayed in merged cells, two per row.
/// - Automatically adjusts layout based on available space.
struct GalaxyMapView: View {
    let colHeaderHeight: CGFloat = 25
    let rowHeaderWidth: CGFloat = 25
    let rows = Galaxy.quadrantRows
    let columns = Galaxy.quadrantCols
    let systemNames = Galaxy.starSystemNames
    let namesPerRow = 2

    var body: some View {
        GeometryReader { geometry in
            let cellWidth = (geometry.size.width - rowHeaderWidth) / CGFloat(columns)
            let cellHeight = (geometry.size.height - colHeaderHeight) / CGFloat(rows)
            let mergedColsPerName = CGFloat(columns / namesPerRow)
            
            VStack(spacing: 0) {
                // Top row: Column headers (1 through columns)
                HStack(spacing: 0) {
                    Color.clear
                        .frame(width: rowHeaderWidth, height: colHeaderHeight)
                    ForEach(1...columns, id: \.self) { col in
                        Text("\(col)")
                            .frame(width: cellWidth, height: colHeaderHeight)
                            .background(Color.gray.opacity(0.2))
                    }
                }

                // Main grid: Each row has a header and two merged cells for star system names
                ForEach(0..<rows, id:\.self) { row in
                    HStack(spacing: 0) {
                        // Row header
                        Text("\(row + 1)")
                            .frame(width: rowHeaderWidth, height: cellHeight)
                            .background(Color.gray.opacity(0.2))

                        // // Left merged cell (columns 1–4): First star system name for the row
                        let nameIndex1 = row * namesPerRow
                        let name1 = nameIndex1 < systemNames.count ? systemNames[nameIndex1] : ""
                        Text(name1)
                            .font(.title2)
                            .frame(width: cellWidth * mergedColsPerName, height: cellHeight)
                            .border(Color.white.opacity(0.5), width: 0.5)

                        // Right merged cell (cols 5–8)
                        let nameIndex2 = row * namesPerRow + 1
                        let name2 = nameIndex2 < systemNames.count ? systemNames[nameIndex2] : ""
                        Text(name2)
                            .font(.title2)
                            .frame(width: cellWidth * mergedColsPerName, height: cellHeight)
                            .border(Color.white.opacity(0.5), width: 0.5)
                    }
                }
            }
            .font(.system(size: 12, weight: .medium, design: .monospaced))
        }
    }
}

struct GalaxyMapView_Previews: PreviewProvider {
    static var previews: some View {
        GalaxyMapView()
            .previewLayout(.fixed(width: 400, height: 400))
    }
}

