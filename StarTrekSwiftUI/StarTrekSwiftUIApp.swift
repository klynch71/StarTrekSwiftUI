//
//  StarTrekSwiftUIApp.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 5/10/25.
//
//  Copyright (c) 2025 Kevin Lynch
//  This file is licensed under the MIT license
//

import SwiftUI

///An implementation of the 1978 Super Star Trek game originally written in Basic.
///A graphical UI is used rather than the original keyboard input system, but the game mechanics are essenstially the same as the old version.
@main
struct StarTrekSwiftUIApp: App {
    @StateObject private var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
                .preferredColorScheme(.dark)
        }
    }
}
