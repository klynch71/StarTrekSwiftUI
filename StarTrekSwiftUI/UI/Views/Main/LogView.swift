//
//  LogView.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 5/22/25.
//
//  Copyright (c) 2025 Kevin Lynch
//  This file is licensed under the MIT license
//

import SwiftUI

/// an autoscrolling log view
struct LogView: View {
    private var appState: AppState
    private var viewModel: LogViewModel
    
    init(appState: AppState) {
        self.appState = appState
        self.viewModel = LogViewModel(appState: appState)
    }
    
    var body: some View {
        ZStack {
            Color.black
            
           AutoScrollingView(lines: appState.log)
                .font(.system(.body, design: .monospaced))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
        }
    }
}

#Preview {
    LogView(appState: AppState())
        
}
