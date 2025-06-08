//
//  MessageView.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 5/30/25.
//

import SwiftUI

/*
 Displays a mesage
 */
struct MessageView: View {
    @Binding var message: String
    @EnvironmentObject var model: AppState
    
    var body: some View {
        HStack {
            Spacer()
            Text(message)
            Spacer()
        }
        
    }
}

#Preview {
    MessageView(message: .constant("Hello, World!"))
        .environmentObject(AppState())
        .preferredColorScheme(.dark)
}
