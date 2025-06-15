//
//  DamagedSystemView.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 6/4/25.
//

import SwiftUI

struct DamagedSystemView: View {
    let message: String
    var body: some View {
        ZStack {
            Image("LCARS")
                .resizable()
                .opacity(0.2)
            
            Text(message)
                .font(.title)
        }
    }
}

#Preview {
    DamagedSystemView(message: "Damaged")
        .preferredColorScheme(.dark)
}
