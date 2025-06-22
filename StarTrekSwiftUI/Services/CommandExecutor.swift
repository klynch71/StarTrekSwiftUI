//
//  CommandExecutor.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 6/13/25.
//

import Foundation

/// A service that centralizes the execution of game commands,
/// ensuring consistent side effects such as time advancement,
/// damage application or repair, ship status updates, and game status checks.
struct CommandExecutor {
    let appState: AppState
    let timeService: TimeService
    let damageControl: DamageControl
    let shipStatusService: ShipStatusService
    let gameStatusChecker: GameStatusChecker
    
    let combatViewModel: CombatViewModel
    let navigationViewModel: NavigationViewModel

    /// Initializes a new `CommandExecutor`.
    ///
    /// - Parameter appState: The shared application state for the game.
    init(appState: AppState) {
        self.appState = appState
        self.timeService = TimeService(appState: appState)
        self.damageControl = DamageControl(appState: appState)
        self.shipStatusService = ShipStatusService(appState: appState)
        self.gameStatusChecker = GameStatusChecker(appState: appState)
        
        self.combatViewModel = CombatViewModel(appState: appState)
        self.navigationViewModel = NavigationViewModel(appState: appState)
    }
    
    //Mark - Commands
    
    /// Move the Enterprise at current course and speed
    func navigate() {
        navigationViewModel.engageWarpEngines()
        applyStandardPostCommandEffects()
    }
    
    /// Employ short range sensors
    func shortRangeSensors() {
        let sensors = Sensors(appState:  appState)
        sensors.shortRangeScan()
        applyStandardPostCommandEffects(sensorsOn: true)
    }
    
    /// Employ long range sensors
    func longRangeSensors() {
        let sensors = Sensors(appState:  appState)
        sensors.longRangeScan()
        applyStandardPostCommandEffects(sensorsOn: true)
    }

    /// perform Damage report
    func damageReport() {
        applyStandardPostCommandEffects()
    }
    
    /// employ Computer
    func computer() {
        applyStandardPostCommandEffects(system: .computer)
    }
    
    /// Fire phasers at all enemies in the quadrant. Enemies that survive will fire back.
    func firePhasers(phaserEnergy: Int) {
        combatViewModel.firePhasers(phaserEnergy: phaserEnergy)
        applyStandardPostCommandEffects()
    }
    
    /// Fire a phton torepedo on the given course. Enemies that survive will fire back.
    func fireTorpedo(at course: Course) {
        combatViewModel.fireTorpedo(at: course)
        applyStandardPostCommandEffects()
    }
    
    //Mark - Post command effects

    /// Applies common side effects that occur after executing a command:
    /// - Checks for game-over conditions.
    /// - Advances time if docked.
    /// - Applies damage or repairs and logs a message if applicable.
    /// - Parameter system: An optional ship system to damage. If `nil`, a random system is chosen
    private func applyStandardPostCommandEffects(system: ShipSystem? = nil, sensorsOn: Bool = false) {
        gameStatusChecker.check()

        guard appState.gameStatus == .inProgress else { return }

        //There is a time penalty for using a command while docked
        timeService.advanceIfDocked()

        damageControl.handleDamageOrRepair(system: system) 
        
        if !sensorsOn {
            appState.updateEnterprise {$0.sensorStatus = .allOff}
        }
        
        shipStatusService.setShipConditions()
    }
}

