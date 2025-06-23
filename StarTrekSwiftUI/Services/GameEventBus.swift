//
//  GameEventBus.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 6/21/25.
//

import Combine

class GameEventBus {
    static let shared = GameEventBus()
    
    let navigationPublisher = PassthroughSubject<NavigationEvent, Never>()
    let combatPublisher = PassthroughSubject<CombatEvent, Never>()
    let damagePublisher = PassthroughSubject<DamageEvent, Never>()
}
