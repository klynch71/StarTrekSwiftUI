//
//  VerticalSplitView.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 6/9/25.
//

import SwiftUI

/*
 A split screen view where the user can drag a bar to change the percentage of top view vs bottom view
 */
struct VerticalSplitView<Top: View, Bottom: View>: View {
    @GestureState private var dragOffset: CGFloat = 0
    @State private var topHeightRatio: CGFloat

    let top: Top
    let bottom: Bottom

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
