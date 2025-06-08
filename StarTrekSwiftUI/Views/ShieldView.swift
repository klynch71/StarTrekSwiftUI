//
//  ShieldView.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 5/19/25.
//

import SwiftUI

struct ShieldView: View {
    @Binding var shields: Double
    let maxRange: Double
    var body: some View {
        VStack {
            Text("Shields:")
                .padding(.top)
                .frame(alignment: .center)
            Text(String(Int(shields)))
                .frame(alignment: .center)
            VerticalSlider(
                value: $shields,
                in: 0...maxRange,
                step: 1.0
            )
            .frame(minWidth: 40, minHeight:200)
            .padding(.bottom, 60)
        }
    }
}

#Preview {
    ShieldView(shields: .constant(50), maxRange: 100)
}
