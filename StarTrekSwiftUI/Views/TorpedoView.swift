//
//  TorpedoView2.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 5/29/25.
//

import SwiftUI

struct TorpedoTubeView: View {
    let isOn: Bool
    
    var body: some View {
        GeometryReader {
            geo in
            let width = 2 * geo.size.width / 3
            HStack {
                Spacer()
                RoundedRectangle(cornerRadius: 4)
                    .fill(isOn ? Color.blue : Color.white.opacity(0.7))
                    .frame(maxWidth: width)
                Spacer()
            }
        }
    }
}

struct TorpedoView: View {
    @EnvironmentObject var appState: AppState
    @State var course = Course(degrees: 0)
    
    var body: some View {
        let viewModel = TorpedoViewModel(appState: appState)
        
        GeometryReader {geo in
            VStack {
                //Photon tubes
                Spacer()
                Text("Photon")
                Text("Tubes")
                ForEach((1...Enterprise.INITIAL_TORPEDOES).reversed(), id: \.self) { index in
                    HStack {
                        Spacer()
                        TorpedoTubeView(isOn: index <= appState.enterprise.torpedoes)
                        Spacer()
                    }
                }
                
                //Course stepper
                Stepper("Course", onIncrement: {
                    course = Course(degrees: course.degrees + 0.1)
                }, onDecrement: {
                    course = Course(degrees: course.degrees - 0.1)
                })
                
                //Compass View
                CourseView(course: $course)
                    .frame(width: geo.size.width, height: geo.size.width)
                
                
                //fire button
                Button("Fire", action: {viewModel.fire(at: course)})
                    .background(Color.red)
                    .disabled(appState.enterprise.torpedoes <= 0)
                    .padding(.vertical)
            }
        }
    }
}

#Preview {
    TorpedoView()
        .environmentObject(AppState())
        .preferredColorScheme(.dark)

}
