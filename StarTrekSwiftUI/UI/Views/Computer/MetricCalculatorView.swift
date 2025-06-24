//
//  MetricCalculatorView.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 5/22/25.
//
//  Copyright (c) 2025 Kevin Lynch
//  This file is licensed under the MIT license
//

import SwiftUI

/// A view that displays a grid of sectors and allows users to draw a line between two sectors
/// to calculate navigation distance and course.
struct MetricCalculatorView: View {
    @ObservedObject var sensorViewModel: ShortRangeSensorViewModel
    @StateObject private var drawingViewModel: MetricDrawingViewModel
    
    /// radius of circles at beginning and end of measuring line
    private let circleRadius = 4.0
    
    /// width of the measuring liine
    private let lineWidth = 2.0

    /// Custom color for line and text
    private let color = Color("Aqua")
    
    /// width of row headers
    private let rowHeaderWidth: CGFloat = 25
    
    ///height of column headers
    private let colHeaderHeight: CGFloat = 25
    

    init(viewModel: ShortRangeSensorViewModel) {
        self.sensorViewModel = viewModel
        _drawingViewModel = StateObject(wrappedValue: MetricDrawingViewModel(sensorViewModel: viewModel))
    }

    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Main sensor grid with object views
                NumberedGridWithLines(
                    rows: Galaxy.quadrantRows,
                    columns: Galaxy.quadrantCols,
                    rowHeaderWidth: rowHeaderWidth,
                    columnHeaderHeight: colHeaderHeight
                ) { row, col in
                    ObjectCellView(object: sensorViewModel.objectAt(row: row, col: col))
                        .contentShape(Rectangle())
                        .onTapGesture {
                            drawingViewModel.selectCell(row: row, col: col)
                        }
                }

                // Render a static line with circles at both ends
                if let start = drawingViewModel.selectedStart {
                    CircleView(at: cellCenter(row: start.row, col: start.col, in: geo), radius: circleRadius)
                        .fill(color)
                    
                    if let end = drawingViewModel.selectedEnd {
                        // Static line after both points are selected
                        LineView(
                            from: cellCenter(row: start.row, col: start.col, in: geo),
                            to: cellCenter(row: end.row, col: end.col, in: geo)
                        )
                        .stroke(color, lineWidth: lineWidth)
                        
                        CircleView(at: cellCenter(row: end.row, col: end.col, in: geo), radius: circleRadius)
                            .fill(color)
                    }
                }

                // Show calculated navigation data (distance and course) at bottom center
                if let navData = drawingViewModel.navigationData {
                    VStack {
                        Spacer()
                        Text(String(format: "Distance: %.2f, Course: %.1f°", navData.distance, navData.course.degrees))
                            .foregroundColor(color)
                            .background(Color.black.opacity(0.0))
                            .cornerRadius(10)
                    }
                }
            }
        }
    }

    /// Calculates the center point of a cell within the grid.
    private func cellCenter(row: Int, col: Int, in geo: GeometryProxy) -> CGPoint {
        let totalWidth = geo.size.width - rowHeaderWidth
        let totalHeight = geo.size.height - colHeaderHeight
        let cellWidth = totalWidth / CGFloat(Galaxy.quadrantCols)
        let cellHeight = totalHeight / CGFloat(Galaxy.quadrantRows)

        let x = rowHeaderWidth + CGFloat(col) * cellWidth + cellWidth / 2
        let y = colHeaderHeight + CGFloat(row) * cellHeight + cellHeight / 2

        return CGPoint(x: x, y: y)
    }
}

#Preview {
    MetricCalculatorView(viewModel: ShortRangeSensorViewModel(appState: AppState()))
}
