//
//  LongRangeSensorViewModel.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 6/14/25.
//


import SwiftUI
import Combine

/// ViewModel for LongRangeSensorView.
/// Handles loading and navigation logic for 3x3 quadrant grid.
class LongRangeSensorViewModel: ObservableObject {
    /// Adjacent quadrants surrounding the Enterprise (3x3 grid)
    @Published var adjacentQuadrants: [Quadrant?] = []

    private let appState: AppState
    private let navViewModel: NavigationViewModel
    private var cancellables = Set<AnyCancellable>()

    init(appState: AppState) {
        self.appState = appState
        self.navViewModel = NavigationViewModel(appState: appState)
        self.loadAdjacentQuadrants()
        self.subscribeToQuadrantChanges()
    }

     private func subscribeToQuadrantChanges() {
         AppNotificationCenter.shared.quadrantDataDidChangePublisher
             .sink { [weak self] in
                 self?.loadAdjacentQuadrants()
             }
             .store(in: &cancellables)
     }

    /// Load adjacent quadrants from current enterprise location
    func loadAdjacentQuadrants() {
        print("loading quadrants...")
        self.adjacentQuadrants = appState.adjacentQuadrants()
    }

    /// Convert a grid coordinate to flat array index
    func getQuadrantIndex(row: Int, col: Int) -> Int {
        return col + row * 3
    }
    
    func quadrant(row: Int, col: Int) -> Quadrant? {
        let index = getQuadrantIndex(row: row, col: col)
        return adjacentQuadrants[index]
    }

    /// Process user tap on a specific quadrant
    func processTap(row: Int, col: Int) {
        let index = getQuadrantIndex(row: row, col: col)
        guard let quadrant = adjacentQuadrants[index] else {return}

        // Calculate target sector in center of selected quadrant
        let relSectorNum = Galaxy.sectorCols / 2 + (Galaxy.sectorRows / 2) * Galaxy.sectorCols - 1
        let sectorNum = relSectorNum + quadrant.sectors.count * quadrant.id
        let sector = Sector(sectorNum)
        let targetLocation = GalaxyLocation(sector: sector)

        // Determine navigation data and send to navigation system
        let navData = appState.enterprise.location.navigate(to: targetLocation)
        navViewModel.setCourseAndSpeed(navData: navData)
    }
}
