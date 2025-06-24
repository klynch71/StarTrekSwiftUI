//
//  InitialView.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 5/24/25.
//
//  Copyright (c) 2025 Kevin Lynch
//  This file is licensed under the MIT license
//

import SwiftUI

///The Initlal game screen
struct InitialView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
    
        ZStack {
            Color.black
            
            Image("EnterpriseLarge")
                .resizable()
                .scaledToFit()
                .opacity(0.6)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    InitialView()
}
