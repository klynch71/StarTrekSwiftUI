//
//  GameEventBus.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 6/21/25.
//
//  Copyright (c) 2025 Kevin Lynch
//  This file is licensed under the MIT license
//

import Combine

class GameEventBus {
    static let shared = GameEventBus()
    
    let navigationPublisher = PassthroughSubject<NavigationEvent, Never>()
    let combatPublisher = PassthroughSubject<CombatEvent, Never>()
    let damagePublisher = PassthroughSubject<DamageEvent, Never>()
}
