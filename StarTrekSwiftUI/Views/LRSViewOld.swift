//
//  LongRangeSensorView.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 5/21/25.
//

import SwiftUI

/*
 Scan adjacent sectors to where the Enterprise
 is currently located.
 */
struct LongRangeSensorViewOld: View {
    @ObservedObject var appState: AppState
    private let navViewModel: NavigationViewModel
    
    init(appState: AppState) {
        self.appState = appState
        self.navViewModel = NavigationViewModel(appState: appState)
    }
    
    var body: some View {
        let quadrants = appState.adjacentQuadrants()
        
        VStack {
            ForEach(quadrants.indices, id: \.self) { index in
                if let quadrant = quadrants[index] {
                    Text("Quadrant: \(quadrant.id)")
                } else {
                    Text("Quadrant: ***") // or some placeholder for missing quadrant
                }
            }
        }        //display adjacent quadrants in a 3x3 grid
   /*     GridWithLines(rows: 3, columns: 3, lineColor: .gray, lineWidth: 1) { row, col in
            QuadrantExplorerView(quadrant: quadrants[getQuadrantIndex(row: row, col: col)])
                .onTapGesture {processTap(quadrant: quadrants[getQuadrantIndex(row: row, col: col)], appState: appState)}
            } */
    }
    
    /*
     return the quadrant index for the given row and column
     */
    func getQuadrantIndex(row: Int, col: Int) -> Int {
            return col + row * 3
    }
    
    /*
     handle a tap in a quadrant by setting course and speed
     to reach the quadrant
     */
    func processTap(quadrant: Quadrant?, appState: AppState) {
        //only handle real quadrants
        guard let quadrant = quadrant else {
            return
        }
        
        //aim for the center of the Quadrant more or less
        let relSectorNum = Galaxy.sectorCols/2 + (Galaxy.sectorRows / 2) * Galaxy.sectorCols - 1
        let sectorNum = relSectorNum + quadrant.sectors.count * quadrant.id
        let sector = Sector(sectorNum)
        let targetLocation = GalaxyLocation(sector: sector)
        let navData = appState.enterprise.location.navigate(to: targetLocation)
        
        //set enteprise course and speed
        navViewModel.setCourseAndSpeed(navData: navData)
    }
}

#Preview {
    LongRangeSensorViewOld(appState: AppState())
        .environmentObject(AppState())
}
