//
//  GalaticRecordView.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 6/2/25.
//

import SwiftUI

struct GalaticRecordView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        NumberedGridWithLines(
                     rows: Galaxy.quadrantRows,
                     columns: Galaxy.quadrantCols,
                     rowHeaderWidth: 25,
                     columnHeaderHeight: 25
                 ) { row, col in
                     QuadrantExplorerView(quadrant: getQuadrant(row: row, col: col))
                 }
    }
    
    /*
     return the quadrant for the given row, col or nil
     if not explored yet (or out of bounds)
     */
    private func getQuadrant(row: Int, col: Int) -> Quadrant? {
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
    GalaticRecordView()
        .environmentObject(AppState())
}
