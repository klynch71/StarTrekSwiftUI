//
//  ControlView.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 5/12/25.
//

import SwiftUI

struct ControlView: View {
    @EnvironmentObject var model: AppState
    @Binding var selection: WindowType
    
    var body: some View {
        HStack {
            Button("Short Range Scan", action: shortRangeSensors)
            Spacer()
            Button("Long Range Scan", action: longRangeSensors)
            Spacer()
            Button("Damage Report", action: incEnergy)
            Spacer()
            Button("Computer", action: {selection = .computer})
            Spacer()
            Button("Status", action: incEnergy)
            Spacer()
            Button("Log", action: {selection = .log})
            Spacer()
        }
    }
    
    func shortRangeSensors() {
        if let quadrant = model.enterprise.location.quadrant {
            model.enterprise.exploredSpace.insert(quadrant)
        }
        selection = .shortRangeSensors
    }
    
    func longRangeSensors() {
        //perform the scan  and update the explored space before
        //switching Views.  This prevents updating the model while
        //rendering the view
        let quadrants = Galaxy.adjacentQuadrants(to: model.enterprise.location)
        let validQudrants = quadrants.compactMap {$0}
        model.enterprise.exploredSpace.formUnion(validQudrants)
        
        //switch to long range sensor view
        selection = .longRangeSensors
        
    }
    
    func moveenterprise() {
        let numSectors = Galaxy.quadrants.count * Quadrant.SECTORS_PER_QUADRENT;
        let randomNum = Int.random(in: 0..<numSectors);
        model.moveEnterprise(Sector(randomNum))
    }
    
    func reset() {
        GameSetup.reset(model);
    }
    
    func incEnergy() {
        model.enterprise.energy += 100;
    }
}

#Preview {
    ControlView(selection: .constant(.initial))
        .environmentObject(AppState())
}
