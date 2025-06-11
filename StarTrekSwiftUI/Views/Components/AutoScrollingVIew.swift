//
//  AutoScrollingVIew.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 6/10/25.
//

import SwiftUI

/*
 A view for displaying text, like a log, that will automatically scroll to show the most recently
 added text the bottom
 */
struct AutoScrollingView: View {
    let lines: [String]
    
    private let lineSpacing: CGFloat = 4

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.vertical) {
                LazyVStack(alignment: .leading, spacing: lineSpacing) {
                    ForEach(Array(lines.enumerated()), id: \.offset) { index, line in
                        Text(line)
                            .id(index)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .padding(.horizontal)
            }
            .onChange(of: lines.count) { oldCount, newCount in
                if newCount > 0 {
                    withAnimation(.easeOut(duration: 0.25)) {
                        proxy.scrollTo(newCount - 1, anchor: .bottom)
                    }
                }
            }
        }
    }
}
