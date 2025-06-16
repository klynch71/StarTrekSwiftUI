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
    @ObservedObject var appState: AppState
    private let navViewModel: NavigationViewModel
    
    init(appState: AppState) {
        self.appState = appState
        self.navViewModel = NavigationViewModel(appState: appState)
    }
    
    var body: some View {
        NumberedGridWithLines(
                     rows: Galaxy.quadrantRows,
                     columns: Galaxy.quadrantCols,
                     rowHeaderWidth: 25,
                     columnHeaderHeight: 25
                 ) { row, col in
                     ObjectCellView(object: objectAt(row: row, col: col))
                         .onTapGesture {handleTap(row: row, col: col)
                         }
                 }
    }
    
    /// Returns the sector at the given grid coordinates.
    private func sectorAt(row: Int, col: Int) -> Sector? {
        let sectors = appState.enterprise.location.quadrant.sectors
        let index = row * Galaxy.sectorCols + col
        return sectors[safe: index]
    }
    
    /// Returns the object located at the specified sector, or nil if empty.
    private func objectAt(row: Int, col: Int) -> (any Locatable)? {
        guard let sector = sectorAt(row: row, col: col) else {return nil}
        
        if appState.enterprise.location.sector == sector {
            return appState.enterprise
        }

        return appState.galaxyObjects.first (where: {$0.location.sector == sector})
    }

    /// Handles a tap gesture on a sector by calculating a navigation course
    /// and updating the enterprise's course, speed, and torpedo heading.
    func handleTap(row: Int, col: Int) {
        guard let tappedSector = sectorAt(row: row, col: col) else {return}
        
        let destination = GalaxyLocation(sector: tappedSector)
        let navData = appState.enterprise.location.navigate(to: destination)
        
        appState.updateEnterprise {$0.torpedoCourse = navData.course}
        
        navViewModel.setCourseAndSpeed(navData: navData)
    }
}

#Preview {
    ShortRangeSensorView(appState: AppState())
}

