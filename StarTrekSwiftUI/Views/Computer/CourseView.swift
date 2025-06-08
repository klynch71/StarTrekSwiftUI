//
//  CourseView.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 5/29/25.
//

import SwiftUI

struct CourseView: View {
    @Binding var course: Course
    let showCourse = true
    @State private var isDragging = false

    var body: some View {
        GeometryReader { geometry in
            let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
            
            //set radius of circle
            let min = min(geometry.size.width, geometry.size.height);
            let circleRadius = min / 2 * 0.9

            // Invert the angle back for rendering in screen coordinates
            let renderAngle = -course.radians
            let handlePosition = CGPoint(
                x: center.x + cos(CGFloat(renderAngle)) * circleRadius,
                y: center.y + sin(CGFloat(renderAngle)) * circleRadius
            )

            ZStack {
                // Circle outline
                Circle()
                    .stroke(Color.gray, lineWidth: 3)
                    .frame(width: circleRadius * 2, height: circleRadius * 2)
                    .position(center)

                // Line from center to handle
                Path { path in
                    path.move(to: center)
                    path.addLine(to: handlePosition)
                }
                .stroke(Color.blue, lineWidth: 2)
                // Handle
                Circle()
                    .fill(Color.blue)
                    .frame(width: 12, height: 12)
                    .position(handlePosition)
                
                // Angle label
                if showCourse {
                    Text(String(format: "%.1f", course.degrees))
                        .font(.headline)
                        .position(x: center.x, y: center.y)
                }
            }
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        isDragging = true
                        let dx = value.location.x - center.x
                        let dy = value.location.y - center.y

                        // Flip dy for counter-clockwise increasing angle
                        let radians = atan2(Double(-dy), Double(dx))
                        course = Course(radians: radians)
                    }
                    .onEnded { _ in
                        isDragging = false
                    }
            )
        }
    }
}

struct CourseView_Previews: PreviewProvider {
    static var previews: some View {
        CourseView(course: .constant(Course(degrees: 90)))
            .frame(width: 400, height: 400)
    }
}

