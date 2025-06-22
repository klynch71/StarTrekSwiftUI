//
//  ShortRangeSensorView.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 5/16/25.
//

import SwiftUI

/// A view that displays the sectors of a quadrant in a grid with gridlines,
/// along with numerical column and row header labels.
struct ShortRangeSensorView: View {
    @ObservedObject var viewModel: ShortRangeSensorViewModel
    
    var body: some View {
        NumberedGridWithLines(
                     rows: Galaxy.quadrantRows,
                     columns: Galaxy.quadrantCols,
                     rowHeaderWidth: 25,
                     columnHeaderHeight: 25
                 ) { row, col in
                     ObjectCellView(object: viewModel.objectAt(row: row, col: col))
                         .onTapGesture {viewModel.handleTap(row: row, col: col)
                    }
                 }
    }
}

#Preview {
    ShortRangeSensorView(viewModel: ShortRangeSensorViewModel(appState: AppState()))
}

