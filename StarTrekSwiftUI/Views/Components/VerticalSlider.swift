//
//  VerticalSlider.swift
//  VerticalSliderApp
//
//  Created by Kevin Lynch on 5/20/25.
//

import SwiftUI

/**
 a vertical slider.
 SwiftUI documentation says using a Slider with a rotate of 90 degrees should work, but I could not get it
 to work so I implemented my own VerticalSlider.  Like Slider you can set the color of the active track using .accentColor()
 */
struct VerticalSlider: View {
    ///the value to set
    @Binding var value: Double
    
    ///the range within that the value must value within
    var range: ClosedRange<Double> = 0...1
    
    ///the step for the slider or nil for continuous
    var step: CGFloat? = nil
    
    ///the radius for the thumb that is used to drag the slider
    private let thumbRadius:CGFloat = 10
    
    ///keeps track of the top Y position
    private let topY: CGFloat = 0
    
    init(value: Binding<Double>, in range:ClosedRange<Double> = 0...1,
         step: CGFloat? = nil
    ) {
        self._value = value //_value for Binding
        self.range = range
        self.step = step
    }
    
    var body: some View {
        GeometryReader {geo in
            let centerX = geo.size.width / 2
            let bottomY = geo.size.height
            let thumbY = thumbCenter(geo.size).y

            Canvas {ctx, size in
                // Active track: from bottom to thumb
                var activeTrack = Path()
                activeTrack.move(to: CGPoint(x: centerX, y: bottomY))
                activeTrack.addLine(to: CGPoint(x: centerX, y: thumbY))
                ctx.stroke(activeTrack, with: GraphicsContext.Shading.color(.accentColor), style: StrokeStyle(lineWidth: 4, lineCap: .round))
                
                // Gray track: from thumb to top
                var inactiveTrack = Path()
                inactiveTrack.move(to: CGPoint(x: centerX, y: thumbY))
                inactiveTrack.addLine(to: CGPoint(x: centerX, y: topY))
                ctx.stroke(inactiveTrack, with: GraphicsContext.Shading.color(.gray.opacity(0.3)), style: StrokeStyle(lineWidth: 4, lineCap: .round))
                
                //draw the thumb
                var thumbCircle = Path()
                thumbCircle.addEllipse(in: thumbRect(size: size))
                
                ctx.fill(thumbCircle, with: GraphicsContext.Shading.color(.white))
                ctx.stroke(thumbCircle, with: GraphicsContext.Shading.color(.gray.opacity(0.5)), style: StrokeStyle(lineWidth: 1))

                
            }.gesture(
                DragGesture(minimumDistance: 0, coordinateSpace: .local)
                    .onChanged { gesture in
                        let locationY = gesture.location.y
                        let proportion = max(0, min(1, 1 - locationY / bottomY))
                        var newValue = Double(proportion) * (range.upperBound - range.lowerBound) + range.lowerBound

                        if let step = step {
                            newValue = (newValue / step).rounded() * step
                        }

                        newValue = min(max(range.lowerBound, newValue), range.upperBound)
                        self.value = newValue
                    }
            )
        }
    }
    
    /*
     return a CGPoint where the thumb is
     */
    private func thumbCenter(_ size: CGSize) -> CGPoint {
        let bottomY = size.height
        let sliderRange = bottomY - topY
        var y = bottomY
        if range.upperBound > range.lowerBound {
            let proportion = value / (range.upperBound - range.lowerBound)
            y = bottomY - (proportion * sliderRange)
        }
    
        //keep the thumb wholly within our space
        y = max(thumbRadius, y);
        y = min(size.height - thumbRadius, y);
        let x = size.width / 2;
 
        return CGPoint(x: x, y: y)
    }

    /*
     return a CGRect where the thumb should be located
     */
    private func thumbRect(size: CGSize) -> CGRect {
        let center = thumbCenter(size);
        let x = center.x - thumbRadius;
        let y = center.y - thumbRadius;
        return CGRect(x: x, y: y, width: thumbRadius * 2, height : thumbRadius * 2)
    }
    
    /*
     processDrag
     */
    private func processDrag(_ value: DragGesture.Value, geometry: GeometryProxy) {
        //keep within our window
        var y = value.location.y;
        y = max(0, y);
        y = min(geometry.size.height, y);
        let percent = 1.0 - y / geometry.size.height;
        let scale = range.upperBound - range.lowerBound;
    
        self.value = range.lowerBound + percent * scale;
    }
}

/*
 an extension to handle Int inputs
 */
extension VerticalSlider {
    init(value: Binding<Int>, range: ClosedRange<Int>, step: Int = 1) {
        self._value = Binding(
            get: { Double(value.wrappedValue) },
            set: { value.wrappedValue = Int($0.rounded()) }
        )
        self.range = Double(range.lowerBound)...Double(range.upperBound)
        self.step = Double(step)
    }
}

#Preview {
    VerticalSlider(value: .constant(0.5), in: 0...100)
}

