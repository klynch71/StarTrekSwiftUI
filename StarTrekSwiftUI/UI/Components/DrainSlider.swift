//
//  DrainSlider.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 6/7/25.
//
//  Copyright (c) 2025 Kevin Lynch
//  This file is licensed under the MIT license
//

import SwiftUI

/**
 A DrainSlider is a slider intended to work with other DrainSliders .  Each DrainSlider is competing for a share of a single resource: totalResource.  The limits of each slider is limted by what the other sliders do.  For example if you have a totalResource = 1000, and you have two DrainSliders, the first of which is set at 750, the second will only be able to go to 250.
 
 Example usage:
 
 struct SampleView: VIew {
     private let totalResource: Int = 1000
     private var drain1: Int = 0
     private var drain2: Int = 0
     private var drain3: Int = 0
     private let step: Int = 1
 
    HStack: {
        //Control for setting value of drain1
        DrainSlider(
            drain: $drain1,
            totalResource: totalResources,
            competingDrains: { [drain2, drain3] },
            label: "Drain 1",
            step: 1
         )
 
         //Control for setting value of drain2
         DrainSlider(
             drain: $drain2,
             totalResource: totalResources,
             competingDrains: { [drain1, drain3] },
             label: "Drain 2",
             step: 1
        )
 
        //Control for setting value of drain1
        DrainSlider(
             drain: $drain3,
             totalResource: totalResources,
             competingDrains: { [drain1, drain2] },
             label: "Drain 3",
             step: 1
         )

       } //HStack
 
 }
 
 */
struct DrainSlider: View {
    /// The name of this  drain
    private var label: String
    
    /// The specific drain this slider is controlling
    private var drain: Binding<Int>
    
    /// Total resource available (ie; energy, budget, etc)
    private let totalResource: Int
    
    /// All other drains competing for the resource
    private let competingDrains: () -> [Int]
    
    ///The minimum step for changing the drain value
    private let step: Int = 1

    init(drain: Binding<Int>,
         totalResource: Int,
         competingDrains: @escaping () -> [Int],
         label: String)
    {
        // Clamp drain to what's left after others consume energy
        self.drain = drain.clamped {
            max(0, totalResource - competingDrains().reduce(0, +))
        }
        self.totalResource = totalResource
        self.competingDrains = competingDrains
        self.label = label
    }

    var body: some View {
        let maxValue = max(0, totalResource - competingDrains().reduce(0, +))
        
        VStack {
            //label on top
            Text(label)
                .padding(.top)
                .frame(alignment: .center)
            
            //fine-tune stepper
            Stepper(String("\(drain.wrappedValue)"), value: drain, in: 0...maxValue, step: step)
            
            //Vertical Slider
            VerticalSlider(value: Binding(
                get: { Double(drain.wrappedValue) },
                set: { drain.wrappedValue = Int($0.rounded())}
            ), in: 0...Double(maxValue), step: 1)
        }
    }
}
