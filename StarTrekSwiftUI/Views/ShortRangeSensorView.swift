//
//  ShortRangeSensorView.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 5/16/25.
//

import SwiftUI

/// A view that displays the sectors of a quadrant in a Grid with gridlines as well as numerical column and row header labels
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
                     ObjectCellView(object: object(row: row, col: col))
                         .onTapGesture {processTap(row: row, col: col, appState: appState)
                         }
                 }
    }
    
    /*
     return the sector for the given row and column
     */
    func getSector(row: Int, col: Int) -> Sector? {
        let sectors = appState.enterprise.location.quadrant.sectors
        //row and col are zero-based
        let index = row * Galaxy.sectorCols + col
        guard index >= 0 && index < sectors.count else { return nil }
        
        return sectors[index]
    }
    
    /// Returns the object at the given row and column or nil if there is no object.
    private func object(row: Int, col: Int) -> (any Locatable)? {
        guard let sector = getSector(row: row, col: col) else {return nil}
        
        if appState.enterprise.location.sector == sector {
            return appState.enterprise
        }

        return appState.galaxyObjects.first (where: {$0.location.sector == sector})
    }

    /*
     handle a tap in a sector by setting course and speed
     to reach the sector and setting torpedo course to same
     */
    func processTap(row: Int, col: Int, appState: AppState) {
        guard let tappedSector = getSector(row: row, col: col) else {return}
        
        let destination = GalaxyLocation(sector: tappedSector)
        let navData = appState.enterprise.location.navigate(to: destination)
        
        //set torpedo course
        appState.updateEnterprise {$0.torpedoCourse = navData.course}
        
        //set enteprise course and speed
        navViewModel.setCourseAndSpeed(navData: navData)
    }
}

#Preview {
    ShortRangeSensorView(appState: AppState())
        .environmentObject(AppState())
}

