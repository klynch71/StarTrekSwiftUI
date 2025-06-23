//
//  LogViewModel.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 6/22/25.
//

import Combine

/// ViewModel responsible for maintaining a textual log of significant game events.
///
/// Listens to game-wide event publishers (e.g. navigation, combat, damage) and appends
/// user-friendly messages to a published log using dedicated formatters.
class LogViewModel: ObservableObject {
    
    /// game state
    private let appState: AppState
    
    /// Used to hold Combine subscriptions and automatically cancel them on deinit.
    private var cancellables = Set<AnyCancellable>()
    
    /// Sets up event subscriptions and begins listening for relevant game events.
    init(appState: AppState) {
        self.appState = appState
        subscribeToEvents()
    }
    
    /// Subscribes to `NavigationEvent`, `CombatEvent`, and `DamageEvent` publishers via the`GameEventBus`.
    ///
    /// Each event is passed through its respective formatter, which returns a user-friendly message.
    /// If a message is returned (i.e. not nil), it is appended to the log.
    private func subscribeToEvents() {
        //log navigation events
        GameEventBus.shared.navigationPublisher
            .compactMap { NavigationEventFormatter.message(for: $0) }
                .sink { [weak self] message in
                self?.appState.addLogEntry(message)
            }
            .store(in: &cancellables)
        
        // log combat events
        GameEventBus.shared.combatPublisher
            .compactMap { CombatEventFormatter.message(for: $0) }
                .sink { [weak self] message in
                self?.appState.addLogEntry(message)
            }
            .store(in: &cancellables)
        
        // log damage events
        GameEventBus.shared.damagePublisher
            .compactMap { DamageEventFormatter.message(for: $0) }
                .sink { [weak self] message in
                self?.appState.addLogEntry(message)
            }
            .store(in: &cancellables)

    }
}
