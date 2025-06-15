//
//  QuadrantView.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 6/14/25.
//

import SwiftUI

///Display all the Sectors in the quadrant the Enterprise occupies in a Grid.
///For each Sector, display an image of the galaxyObject in that Sector if there is one.
struct EnterpriseQuadrantView: View {
    @ObservedObject var appState: AppState
    let onSectorTap: ((Int, Int, Sector?) -> Void)?  // Optional tap handler
    
    init(appState: AppState, onSectorTap: ((Int, Int, Sector?) -> Void)? = nil) {
        self.appState = appState
        self.onSectorTap = onSectorTap
    }
    
    var body: some View {
        NumberedGridWithLines(
                     rows: Galaxy.quadrantRows,
                     columns: Galaxy.quadrantCols,
                     rowHeaderWidth: 25,
                     columnHeaderHeight: 25
                 ) { row, col in
                     objectCellView(object: object(row: row, col: col))
                         .onTapGesture { onSectorTap?(row, col, getSector(row: row, col: col)) }
                    }
    }
    
    /// Returns a view representing a single cell in the quadrant for an optional Locatable object.
    /// If the object is present, its image is shown; otherwise, a black cell is rendered.
    func objectCellView(object: (any Locatable)?) -> some View {
        return ZStack {
            Rectangle()
                .fill(Color.clear)
                .background(Color.black)
            
            if let object = object {
                Image(object.name)
                    .resizable()
                    .scaledToFit()
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
}

#Preview {
    EnterpriseQuadrantView(appState: AppState())
}
