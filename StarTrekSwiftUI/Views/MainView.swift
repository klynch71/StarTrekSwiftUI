//
//  MainView.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 5/24/25.
//

import SwiftUI

struct MainView: View {
    let selection: WindowType
    var body: some View {

        switch(selection) {
        case .initial:
            InitialView()
        case .navigation:
            NavigationView()
        case .shortRangeSensors:
            ShortRangeSensorView()
        case .longRangeSensors:
            LongRangeSensorView()
        case .log:
            LogView()
        case .computer:
            ComputerView()
        }
    }
}

#Preview {
    MainView(selection: .computer)
}
