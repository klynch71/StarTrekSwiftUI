//
//  NavigationView.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 5/24/25.
//

import SwiftUI

/// A view for moving the Enterprise based on speed and course
struct NavigationView: View {
    @ObservedObject var appState: AppState
    let commandExecutor: CommandExecutor
    
    // Computed binding for warpFactor
    private var warpFactorBinding: Binding<Double> {
        Binding<Double>(
            get: { appState.enterprise.warpFactor },
            set: { newValue in
                appState.updateEnterprise { $0.warpFactor = newValue }
            }
        )
    }
    
    // Computed binding for navigationCourse
    private var navigationCourseBinding: Binding<Course> {
        Binding<Course>(
            get: { appState.enterprise.navigationCourse },
            set: { newValue in
                appState.updateEnterprise { $0.navigationCourse = newValue }
            }
        )
    }
    
    /// Initializes the view with the app state and screen binding
    /// - Parameters:
    ///   - appState: The global application state
    ///   - selection: Binding to the currently selected main screen
    init(appState: AppState) {
        self.appState = appState
        self.commandExecutor = CommandExecutor(appState: appState)
    }
    
    var body: some View {
        
        GeometryReader { geo in
            VStack {
                Text("Warp")
                    .padding(.top)
                Text("Factor")
                
                // Fine-tune warp factor using a stepper.
                Stepper(String(format: "%.1f", warpFactorBinding.wrappedValue), value: warpFactorBinding, in: 0...Enterprise.maxWarp, step: 0.1)
                        
                // Vertical Slider for setting warp factor.
                VerticalSlider(value: warpFactorBinding, in: 0...Enterprise.maxWarp, step: 0.1)
                
                Spacer()
                
                // Fine-tune navigation course using a stepper.
                Stepper("Course", onIncrement: {
                    let newCourse = Course(degrees: appState.enterprise.navigationCourse.degrees + 0.1)
                    appState.updateEnterprise {$0.navigationCourse = newCourse }
                }, onDecrement: {
                    let newCourse = Course(degrees: appState.enterprise.navigationCourse.degrees - 0.1)
                    appState.updateEnterprise {$0.navigationCourse = newCourse }
                })
                
                //  control for setting navigation course.
                CoursePicker(course: navigationCourseBinding)
                    .frame(width: geo.size.width,
                           height: geo.size.width)
                
                Button("Engage", action: engage)
                    .padding(.vertical)
            }
            .disabled(appState.enterprise.damage.isDamaged(.engines))
        }
    }
    
    /// Engage warp engines using the current course and warp factor.
    private func engage() {
        commandExecutor.navigate()
    }
}

#Preview {
    NavigationView(appState: AppState())
        .environmentObject(AppState())
        .preferredColorScheme(.dark)
}
