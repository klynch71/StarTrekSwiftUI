//
//  QuadrantExplorerView.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 5/24/25.
//

import SwiftUI

/// A view that displays the contents of a quadrant in KBS format,
/// where K = number of Klingons, B = number of Starbases, and S = number of Stars.
struct QuadrantExplorerView: View {
    @EnvironmentObject var appState: AppState
    let quadrant: Quadrant?
    
    var body: some View {
        Text(quadrantSummary(quadrant))
            .frame(maxWidth: .infinity, maxHeight: .infinity)  // Expand to fill parent
                .contentShape(Rectangle())       // Makes full area tappable
    }
    
    /// Returns the contents of the quadrant in KBS format
    /// or "***" if the quadrant is nil.
    func quadrantSummary(_ quadrant: Quadrant?) -> String {
        guard let quadrant = quadrant else { return "***" }
        
        let klingons = appState.objects(ofType: Klingon.self, in: quadrant)
        let starbases = appState.objects(ofType: Starbase.self, in: quadrant)
        let stars = appState.objects(ofType: Star.self, in: quadrant)
    
        return "\(klingons.count)\(starbases.count)\(stars.count)"
    }
}

#Preview {
    QuadrantExplorerView(quadrant: Quadrant(0))
        .environmentObject(AppState())
}
