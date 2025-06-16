//
//  GalaticRecordView.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 6/2/25.
//

import SwiftUI

/// A view that displays the galactic record grid, showing explored quadrants
/// using the QuadrantExplorerView. Unexplored or out-of-bounds quadrants are shown as empty*
struct GalacticRecordView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        NumberedGridWithLines(
                     rows: Galaxy.quadrantRows,
                     columns: Galaxy.quadrantCols,
                     rowHeaderWidth: 25,
                     columnHeaderHeight: 25
                 ) { row, col in
                     QuadrantExplorerView(quadrant: quadrantAt(row: row, col: col))
                 }
    }
    
    /// Returns the quadrant at the specified position if it has been explored,
    /// or nil if it's out of bounds or not yet explored.
    private func quadrantAt(row: Int, col: Int) -> Quadrant? {
        let index = row * Galaxy.quadrantCols + col
        guard index >= 0 && index < Galaxy.quadrants.count else {
            return nil
        }
        let quadrant = Galaxy.quadrants[index]
        let explored = appState.enterprise.exploredSpace.contains(quadrant)
        return explored ? quadrant : nil
    }
}

#Preview {
    GalacticRecordView()
        .environmentObject(AppState())
}
