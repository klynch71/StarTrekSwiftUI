//
//  VerticalSlider.swift
//  VerticalSliderApp
//
//  Created by Kevin Lynch on 5/20/25.
//

import SwiftUI

/// A vertical slider that mimics SwiftUI's Slider`but oriented vertically.
/// Use `.accentColor()` to set the color of the active track.
///
/// Note: Apple's docs suggest rotating a `Slider, but this implementation works reliably across platforms and layouts.
struct VerticalSlider: View {
    /// The bound value updated by the slider.
    @Binding var value: Double
    
    /// The allowed range for the value.
    var range: ClosedRange<Double> = 0...1
    
    /// Optional step size (nil for continuous values).
    var step: CGFloat? = nil
    
    /// Radius of the draggable thumb.
    private let thumbRadius:CGFloat = 10
    
    /// The top Y-coordinate (always 0).
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
                // Active (filled) track: from bottom to current value
                var activeTrack = Path()
                activeTrack.move(to: CGPoint(x: centerX, y: bottomY))
                activeTrack.addLine(to: CGPoint(x: centerX, y: thumbY))
                ctx.stroke(activeTrack, with: .color(.accentColor), style: StrokeStyle(lineWidth: 4, lineCap: .round))
                
                // Inactive (unfilled) track: from current value to top
                var inactiveTrack = Path()
                inactiveTrack.move(to: CGPoint(x: centerX, y: thumbY))
                inactiveTrack.addLine(to: CGPoint(x: centerX, y: topY))
                ctx.stroke(inactiveTrack, with: .color(.gray.opacity(0.3)), style: StrokeStyle(lineWidth: 4, lineCap: .round))
                
                //Thumb circle
                var thumbCircle = Path()
                thumbCircle.addEllipse(in: thumbRect(size: size))
                ctx.fill(thumbCircle, with: .color(.white))
                ctx.stroke(thumbCircle, with: .color(.gray.opacity(0.5)), style: StrokeStyle(lineWidth: 1))

                
            }.gesture(
                DragGesture(minimumDistance: 0, coordinateSpace: .local)
                    .onChanged { gesture in
                        let locationY = gesture.location.y
                        let proportion = max(0, min(1, 1 - locationY / bottomY))
                        var newValue = Double(proportion) * (range.upperBound - range.lowerBound) + range.lowerBound

                        if let step = step {
                            newValue = (newValue / step).rounded() * step
                        }

                        newValue = newValue.clamped(to: range)
                        self.value = newValue
                    }
            )
        }
    }
    
    /// Calculates the center point for the thumb based on the current value.
    private func thumbCenter(_ size: CGSize) -> CGPoint {
        let bottomY = size.height
        let sliderRange = bottomY - topY
        var y = bottomY
        
        if range.upperBound > range.lowerBound {
            let proportion = value / (range.upperBound - range.lowerBound)
            y = bottomY - (proportion * sliderRange)
        }
    
        //keep the thumb wholly within our space
        y = y.clamped(to: thumbRadius...(size.height - thumbRadius))
        let x = size.width / 2
 
        return CGPoint(x: x, y: y)
    }

    /// Returns the CGRect defining the thumb's drawing area.
    private func thumbRect(size: CGSize) -> CGRect {
        let center = thumbCenter(size);
        let x = center.x - thumbRadius;
        let y = center.y - thumbRadius;
        return CGRect(x: x, y: y, width: thumbRadius * 2, height : thumbRadius * 2)
    }
}

// MARK: - Integer support

extension VerticalSlider {
    
    /// A convenience initializer for working with `Int` values.
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

