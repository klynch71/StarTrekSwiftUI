//
//  AutoScrollingVIew.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 6/10/25.
//

import SwiftUI

/// A vertically scrolling view that displays an array of strings (such as a log),
/// automatically scrolling to the most recent line at the bottom when new lines are added.
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
                guard newCount > 0 else { return }
                    // Smoothly scroll to the latest line when new content is added
                    withAnimation(.easeOut(duration: 0.25)) {
                        proxy.scrollTo(newCount - 1, anchor: .bottom)
                    }
            }
        }
    }
}
