//
//  NavigationView.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 5/24/25.
//

import SwiftUI

struct NavigationView: View {
    @State private var speed: Double = 0.0
    @State private var course = Course(degrees: 0)

    var body: some View {
        GeometryReader { geo in
            VStack {
                Text("Warp")
                    .padding(.top)
                Text("Factor:")
                //Warp stepper
                Stepper(String(format: "%.1f", speed), onIncrement: {
                    if speed <= 7.9 {
                        speed = speed + 0.1
                    }
                }, onDecrement: {
                    if speed >= 0.1 {
                        speed = speed - 0.1
                    }
                    
                })
               // Text(String(format: "%.1f", speed))
                
                VerticalSlider(value: $speed, in: 0...8, step: 0.1)
                Spacer()
                
                //Course stepper
                Stepper("Course", onIncrement: {
                    course = Course(degrees: course.degrees + 0.1)
                }, onDecrement: {
                    course = Course(degrees: course.degrees - 0.1)
                })
                
                //Course viewer
                CourseView(course: $course)
                    .frame(width: geo.size.width,
                           height: geo.size.width)
                
                Button("Engage", action: engage)
                    .padding(.vertical)
            }
            
        }
    }
    
    /*
     engage warp engines
     */
    func engage() {
        
    }
}

#Preview {
    NavigationView()
}
