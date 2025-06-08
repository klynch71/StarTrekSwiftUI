//
//  QuadrantExplorerView.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 5/24/25.
//

import SwiftUI

/*
 A View to show the contents of a Quadrant in
 the form KBS  where K = number of Klingons,
 B = number of StarBases, and S = number of Stars
 */
struct QuadrantExplorerView: View {
    let quadrant: Quadrant
    let hidden: Bool = false
    @EnvironmentObject var model: ModelData
    
    var body: some View {
        Text(getString(quadrant))
    }
    
    /*
     return the contents of the quadrant
     */
    func getString(_ quadrant: Quadrant) -> String {
        if hidden {
            return "***"
        }
        let objects = model.galaxyObjects.filter {GalaxyMetric.sectorQuadrant($0.sector) == quadrant};
        let klingons = objects.filter {$0 is Klingon};
        let starBases = objects.filter {$0 is StarBase}
        let stars = objects.filter {$0 is Star};
        
        return String(klingons.count) + String(starBases.count) + String(stars.count);
    }

}

#Preview {
    QuadrantExplorerView(quadrant: Quadrant(0))
        .environmentObject(ModelData())
}
