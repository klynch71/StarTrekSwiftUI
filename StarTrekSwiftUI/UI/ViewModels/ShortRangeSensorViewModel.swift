//
//  ShortRangeSensorViewModel.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 6/17/25.
//

import Combine

/// A view model that provides data and interaction logic for the `ShortRangeSensorView`.
/// It interprets the current quadrant's sectors and handles user interaction like navigation.
class ShortRangeSensorViewModel: ObservableObject {
    /// The shared application state, including the enterprise and galaxy data.
    let appState: AppState
    
    // The galaxy objects in the enterprise quadrant.
    @Published var quadrantObjects: [any Locatable] = []

    /// Handles the logic for setting course and speed for navigation.
    private let navViewModel: NavigationViewModel
    
    /// Used to hold Combine subscriptions and automatically cancel them on deinit.
    private var cancellables = Set<AnyCancellable>()

    /// Initializes the view model with shared application state and subscribe to combatEvents
    /// - Parameter appState: The global app state used to read and update navigation and galaxy data.
    init(appState: AppState) {
        self.appState = appState
        self.navViewModel = NavigationViewModel(appState: appState)
        self.loadQuadrantObjects()
        self.subscribeToEvents()
    }

    /// Returns the object (e.g., Enterprise, enemy, or star) located in the specified sector.
    /// - Parameters:
    ///   - row: The row index of the grid.
    ///   - col: The column index of the grid.
    /// - Returns: A `Locatable` object at the location, or `nil` if the sector is empty.
    func objectAt(row: Int, col: Int) -> (any Locatable)? {
        guard let sector = sectorAt(row: row, col: col) else { return nil }

        // Check if the Enterprise is in the sector
        if appState.enterprise.location.sector == sector {
            return appState.enterprise
        }

        // Otherwise, find the first other object located in that sector
        return quadrantObjects.first(where: { $0.location.sector == sector })
    }

    /// Handles a tap gesture on a specific sector. Calculates the navigation course from the current
    /// location to the tapped sector and updates the enterprise's course and speed.
    /// - Parameters:
    ///   - row: The tapped row index.
    ///   - col: The tapped column index.
    func handleTap(row: Int, col: Int) {
        guard let tappedSector = sectorAt(row: row, col: col) else { return }

        let destination = GalaxyLocation(sector: tappedSector)
        let navData = appState.enterprise.location.navigate(to: destination)

        navViewModel.setCourseAndSpeed(navData: navData)
    }
    
    /// Returns the `Sector` at the specified grid coordinates within the current quadrant.
    /// - Parameters:
    ///   - row: The row index of the grid.
    ///   - col: The column index of the grid.
    /// - Returns: The sector if it exists; otherwise, `nil`.
    private func sectorAt(row: Int, col: Int) -> Sector? {
        let sectors = appState.enterprise.location.quadrant.sectors
        let index = row * Galaxy.sectorCols + col
        return sectors[safe: index]
    }
    
    /// Subscribes to `CombatEvent publishers via the`GameEventBus`.
    ///
    /// Reload the quadrantObjects if a GalaxyObject has been destroyed.
    private func subscribeToEvents() {
        GameEventBus.shared.combatPublisher
            .sink { [weak self] event in
                self?.handleCombatEvent(event)
            }
            .store(in: &cancellables)
    }
    
    /// reload quadrantObjects if a combatEvent results in a destroyed outcome
    private func handleCombatEvent(_ event: CombatEvent) {
        if event.effect == .destroyed {
            loadQuadrantObjects()
        }
    }
    
    /// load the galaxy objects in the current Quadrant
    private func loadQuadrantObjects() {
        self.quadrantObjects = appState.objects(in: appState.enterprise.location.quadrant)
    }
}
