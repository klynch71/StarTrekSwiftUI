//
//  GalacticRecordViewModel.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 6/17/25.
//

import Combine

/// ViewModel managing quadrant data and navigation logic for the GalacticRecordView.
/// Maintains an array of the Galaxy and is exploerd contents.
class GalacticRecordViewModel {
    /// quadrants that have been explored
    @Published var exploredQuadrants = Set<Quadrant> ()

    private let appState: AppState
    private var cancellables = Set<AnyCancellable>()

    init(appState: AppState) {
        self.appState = appState
        self.loadExploredQuadrants()
        self.subscribeToEvents()
    }
    
    /// Returns the quadrant at the specified position if it has been explored,
    /// or nil if it's out of bounds or not yet explored.
    func quadrantAt(row: Int, col: Int) -> Quadrant? {
        let index = row * Galaxy.quadrantCols + col
        guard index >= 0 && index < Galaxy.quadrants.count else {
            return nil
        }
        let quadrant = Galaxy.quadrants[index]
        let explored = appState.enterprise.exploredSpace.contains(quadrant)
        return explored ? quadrant : nil
    }
    
    /// Subscribes to `NavigationEvent publishers via the`GameEventBus and calls
    /// handleNavigationEvent
    private func subscribeToEvents() {
        GameEventBus.shared.navigationPublisher
            .sink { [weak self] event in
                self?.handleNavigationEvent(event)
            }
            .store(in: &cancellables)
    }
    
    /// load explored quadrants if we entered a new quadrant
    private func handleNavigationEvent(_ event: NavigationEvent) {
        switch event {
        case .movedSuccessfully(let startLocation, let finalLocation, _),
             .stoppedAtEdge(let startLocation, let finalLocation, _):
            if startLocation.quadrant != finalLocation.quadrant {
                loadExploredQuadrants()
            }

        default:
            return // otherwise do nothing
        }
    }
    
    /// Load explored quadrants from the enterprise
    private func loadExploredQuadrants() {
        self.exploredQuadrants = appState.enterprise.exploredSpace
    }
    
}
