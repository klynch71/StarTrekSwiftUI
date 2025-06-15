//
//  GalaxyGridView.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 5/23/25.
//

import SwiftUI

/*
 display the starSystem names in a grid
 */
struct GalaxyMapView: View {
    let colHeaderHeight: CGFloat = 25
    let rowHeaderWidth: CGFloat = 25
    let rows = Galaxy.quadrantRows
    let columns = Galaxy.quadrantCols
    let systemNames = Galaxy.starSystemNames

    var body: some View {
        GeometryReader { geometry in
            let cellWidth = (geometry.size.width - rowHeaderWidth) / CGFloat(columns)
            let cellHeight = (geometry.size.height - colHeaderHeight) / CGFloat(rows)

            VStack(spacing: 0) {
                // Column header row
                HStack(spacing: 0) {
                    Color.clear
                        .frame(width: rowHeaderWidth, height: colHeaderHeight)
                    ForEach(1...columns, id: \.self) { col in
                        Text("\(col)")
                            .frame(width: cellWidth, height: colHeaderHeight)
                            .background(Color.gray.opacity(0.2))
                    }
                }

                // Grid rows
                ForEach(0..<rows, id:\.self) { row in
                    HStack(spacing: 0) {
                        // Row header
                        Text("\(row + 1)")
                            .frame(width: rowHeaderWidth, height: cellHeight)
                            .background(Color.gray.opacity(0.2))

                        // First merged cell (cols 1–4)
                        let nameIndex1 = row * 2
                        let name1 = nameIndex1 < systemNames.count ? systemNames[nameIndex1] : ""
                        Text(name1)
                            .font(.title2)
                            .frame(width: cellWidth * 4, height: cellHeight)
                            .border(Color.white.opacity(0.5), width: 0.5)

                        // Second merged cell (cols 5–8)
                        let nameIndex2 = row * 2 + 1
                        let name2 = nameIndex2 < systemNames.count ? systemNames[nameIndex2] : ""
                        Text(name2)
                            .font(.title2)
                            .frame(width: cellWidth * 4, height: cellHeight)
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

