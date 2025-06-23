//
//  LongRangeSensorView.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 5/21/25.
//

import SwiftUI

 /// Scan adjacent quadrants to where the Enterprise is currently located.
struct LongRangeSensorView: View {
    @ObservedObject var appState: AppState
    @State var viewModel: LongRangeSensorViewModel
    
    init(appState: AppState) {
        self.appState = appState
        self.viewModel = LongRangeSensorViewModel(appState: appState)
    }

    var body: some View {
        GridWithLines(rows: 3, columns: 3, lineColor: .gray, lineWidth: 1) { row, col in
            QuadrantExplorerView(quadrant: viewModel.quadrantAt(row: row, col:col))
                .onTapGesture {
                    viewModel.handleTap(row: row, col: col)
                }
        }
    }
}

#Preview {
    LongRangeSensorView(appState: AppState())
        .environmentObject(AppState())
}
