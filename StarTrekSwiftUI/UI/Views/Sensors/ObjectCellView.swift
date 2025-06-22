//
//  ObjectCellView.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 6/14/25.
//

import SwiftUI

///Displays a Galaxy object or a black empty View if there is no object
struct ObjectCellView: View {
    let object: (any Locatable)?
    
    var body: some View {
        
        ZStack {
            // black background
            Rectangle()
                .fill(Color.clear)
                .background(Color.black)
            
            // show image for galaxy object if we have one
            if let object = self.object {
                Image(object.name)
                    .resizable()
                    .scaledToFit()
            }
        }
    }
}

#Preview {
    ObjectCellView(object: Starbase(id: UUID(), location: GalaxyLocation.random()))
        .preferredColorScheme(.dark)
}
