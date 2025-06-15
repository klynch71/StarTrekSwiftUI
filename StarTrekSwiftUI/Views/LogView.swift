//
//  LogView.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 5/22/25.
//

import SwiftUI

struct LogView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        ZStack {
            Color.black
            
            AutoScrollingView(lines: appState.log)
                .multilineTextAlignment(.center)
                .font(.system(.body, design: .monospaced))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
        }
    }
}

#Preview {
    LogView()
        .environmentObject(AppState())
}
