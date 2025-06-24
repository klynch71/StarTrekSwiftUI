//
//  VerticalSplitView.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 6/9/25.
//
//  Copyright (c) 2025 Kevin Lynch
//  This file is licensed under the MIT license
//

import SwiftUI

/// A resizable vertical split view where users can drag a handle to adjust
/// the ratio between a top and bottom view.
///
/// - Note: Top and bottom views are provided via `@ViewBuilder` closures.
/// - The drag handle includes a larger hit area for easier interaction.
/// - On macOS, the cursor changes to `resizeUpDown` when hovering over the handle.
struct VerticalSplitView<Top: View, Bottom: View>: View {
    @GestureState private var dragOffset: CGFloat = 0
    @State private var topHeightRatio: CGFloat

    let top: Top        // top view content
    let bottom: Bottom  // bottom view content

    init(topHeightRatio: CGFloat = 0.5,
         @ViewBuilder top: () -> Top,
         @ViewBuilder bottom: () -> Bottom) {
        self._topHeightRatio = State(initialValue: topHeightRatio)
        self.top = top()
        self.bottom = bottom()
    }

    var body: some View {
        GeometryReader { geometry in
            let totalHeight = geometry.size.height
            let topHeight = totalHeight * topHeightRatio
            let bottomHeight = totalHeight - topHeight

            VStack(spacing: 0) {
                top
                    .frame(height: topHeight)
                    .clipped()

                // ZStack ensures the hover area is hit-testable
                ZStack {
                    Rectangle()
                        .fill(Color.gray)
                        .frame(height: 5)

                    Color.clear
                        .contentShape(Rectangle())
                        .frame(height: 20) // Slightly larger area makes hover easier
                        .onHover { hovering in
                            #if os(macOS)
                            if hovering {
                                NSCursor.resizeUpDown.push()
                            } else {
                                NSCursor.pop()
                            }
                            #endif
                        }
                }
                .gesture(
                    DragGesture()
                        .updating($dragOffset) { value, state, _ in
                            state = value.translation.height
                        }
                        .onEnded { value in
                            let newRatio = topHeightRatio + value.translation.height / totalHeight
                            topHeightRatio = min(max(newRatio, 0.1), 0.9)
                        }
                )

                bottom
                    .frame(height: bottomHeight)
                    .clipped()
            }
        }
    }
}
