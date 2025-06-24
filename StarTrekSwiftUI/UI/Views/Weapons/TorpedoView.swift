//
//  TorpedoView.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 5/29/25.
//
//  Copyright (c) 2025 Kevin Lynch
//  This file is licensed under the MIT license
//

import SwiftUI

///A single torpedo tube view used in the main TorpedoView
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

///The display for showing how many torpedoes remain, as well as firing a torepedo on a set course
struct TorpedoView: View {
    @ObservedObject var appState: AppState
    private let commandExecutor: CommandExecutor
    
    // Computed binding for torpedoCourse
    private var torpedoCourseBinding: Binding<Course> {
        Binding<Course>(
            get: { appState.enterprise.torpedoCourse },
            set: { newValue in
                appState.updateEnterprise { $0.torpedoCourse = newValue }
            }
        )
    }
    
    init(appState: AppState) {
        self.appState = appState
        self.commandExecutor = CommandExecutor(appState: appState)
    }
    
    var body: some View {
        GeometryReader {geo in
            VStack {
                //Photon tubes
                Spacer()
                Text("Photon")
                Text("Tubes")
                ForEach((1...Enterprise.torpedoCapacity).reversed(), id: \.self) { index in
                    HStack {
                        Spacer()
                        TorpedoTubeView(isOn: index <= appState.enterprise.torpedoes)
                        Spacer()
                    }
                }
                
                //Course stepper
                Stepper("Course", onIncrement: {
                    let newCourse = Course(degrees: appState.enterprise.torpedoCourse.degrees + 0.1)
                    appState.updateEnterprise {$0.torpedoCourse = newCourse }
                }, onDecrement: {
                    let newCourse = Course(degrees: appState.enterprise.torpedoCourse.degrees - 0.1)
                    appState.updateEnterprise {$0.torpedoCourse = newCourse }                })
                
                //Compass View
                CoursePicker(course: torpedoCourseBinding)
                    .frame(width: geo.size.width, height: geo.size.width)
                
                //fire button
                Button("Fire", action: {fireTorpedo(at: appState.enterprise.torpedoCourse)})
                    .background(Color.red)
                    .disabled(appState.enterprise.torpedoes <= 0)
                    .padding(.vertical)
            }
        }
        .disabled(isDamaged())
    }
    
    // fire a photon torpedo at the given course
    func fireTorpedo(at course: Course) {
        commandExecutor.fireTorpedo(at: course)
    }
    
    // return true if torpedoControls are damaged or out of ammo
    private func isDamaged() -> Bool {
        return appState.enterprise.torpedoes <= 0 ||
        appState.enterprise.damage.isDamaged(.torpedoControl)
    }
}

#Preview {
    TorpedoView(appState: AppState())
        .environmentObject(AppState())
        .preferredColorScheme(.dark)
}
