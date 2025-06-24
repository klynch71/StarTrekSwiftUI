//
//  GalaticRecordView.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 6/2/25.
//
//  Copyright (c) 2025 Kevin Lynch
//  This file is licensed under the MIT license
//

import SwiftUI

/// A view that displays the galactic record grid, showing explored quadrants
/// using the QuadrantExplorerView. Unexplored or out-of-bounds quadrants are shown as empty*
struct GalacticRecordView: View {
    @ObservedObject var appState: AppState
    @State var viewModel: GalacticRecordViewModel
    
    init(appState: AppState) {
        self.appState = appState
        self.viewModel = .init(appState: appState)
    }
    
    var body: some View {
        NumberedGridWithLines(
                     rows: Galaxy.quadrantRows,
                     columns: Galaxy.quadrantCols,
                     rowHeaderWidth: 25,
                     columnHeaderHeight: 25
                 ) { row, col in
                     QuadrantExplorerView(quadrant: viewModel.quadrantAt(row: row, col: col))
                 }
    }
}

#Preview {
    GalacticRecordView(appState: AppState())
}
