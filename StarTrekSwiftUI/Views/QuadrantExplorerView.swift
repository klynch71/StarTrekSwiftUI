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
 B = number of Starbases, and S = number of Stars
 */
struct QuadrantExplorerView: View {
    @EnvironmentObject var appState: AppState
    let quadrant: Quadrant?
    
    var body: some View {
        Text(getString(quadrant))
            .frame(maxWidth: .infinity, maxHeight: .infinity)  // Expand to fill parent
                .contentShape(Rectangle())       // Makes full area tappable
    }
    
    /*
     return the contents of the quadrant
     */
    func getString(_ quadrant: Quadrant?) -> String {
        guard let quadrant = quadrant else { return "***" }
        
        let klingons = appState.objects(ofType: Klingon.self, in: quadrant)
        let Starbases = appState.objects(ofType: Starbase.self, in: quadrant)
        let stars = appState.objects(ofType: Star.self, in: quadrant)
    
        return String(klingons.count) + String(Starbases.count) + String(stars.count);
    }
}

#Preview {
    QuadrantExplorerView(quadrant: Quadrant(0))
        .environmentObject(AppState())
}
