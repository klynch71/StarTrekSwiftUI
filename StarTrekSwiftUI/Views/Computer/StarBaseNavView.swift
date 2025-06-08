//
//  StarBaseNavView.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 5/21/25.
//

import SwiftUI

struct StarBaseNavView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        ZStack {
            //computer background
            Image("LCARS")
                .resizable()
                .opacity(0.2)
        }
    }
}

#Preview {
    StarBaseNavView()
        .environmentObject(AppState())
        .preferredColorScheme(.dark)
}
