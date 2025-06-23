//
//  LongRangeSensorViewModel.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 6/14/25.
//


import SwiftUI
import Combine

/// ViewModel managing quadrant data and navigation logic for the LongRangeSensorView.
/// Maintains a 3x3 grid of adjacent quadrants and handles tap-based navigation.
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
        self.subscribeToEvents()
    }
    
    /// Return the quadrant at the row, col index or nil if none exists
    func quadrantAt(row: Int, col: Int) -> Quadrant? {
        let index = quadrantIndexAt(row: row, col: col)
        guard index >= 0 && index < adjacentQuadrants.count else { return nil }
        return adjacentQuadrants[index]
    }

    /// Handles user tap on a quadrant by calculating target location and initiating navigation.
    func handleTap(row: Int, col: Int) {
        let index = quadrantIndexAt(row: row, col: col)
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
    
    /// Subscribes to `NavigationEvent publishers via the`GameEventBus`.
    ///
    /// Each event is passed through its respective formatter, which returns a user-friendly message.
    /// If a message is returned (i.e. not nil), it is appended to the log.
    private func subscribeToEvents() {
        GameEventBus.shared.navigationPublisher
            .sink { [weak self] event in
                self?.handleNavigationEvent(event)
            }
            .store(in: &cancellables)
    }
    
    /// load adjacent quadrants if we entered a new quadrant
    private func handleNavigationEvent(_ event: NavigationEvent) {
        switch event {
        case .movedSuccessfully(let startLocation, let finalLocation, _),
             .stoppedAtEdge(let startLocation, let finalLocation, _):
            if startLocation.quadrant != finalLocation.quadrant {
                loadAdjacentQuadrants()
            }

        default:
            return // otherwise do nothing
        }
    }
    
    /// Load adjacent quadrants from current enterprise location
    private func loadAdjacentQuadrants() {
        self.adjacentQuadrants = appState.adjacentQuadrants()
    }

    /// Convert a grid coordinate to flat array index
    private func quadrantIndexAt(row: Int, col: Int) -> Int {
        return col + row * 3
    }
}
