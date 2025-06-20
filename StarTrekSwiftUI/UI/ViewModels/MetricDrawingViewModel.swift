//
//  MetricDrawingViewModel.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 6/19/25.
//

import Foundation
import SwiftUI
import Combine

/// ViewModel responsible for handling user interaction with grid cell selection,
/// drawing a line between two selected cells, and calculating distance and course.
class MetricDrawingViewModel: ObservableObject {
    // First selected cell (start of the line)
    @Published var selectedStart: (row: Int, col: Int)?
    
    // Second selected cell (end of the line)
    @Published var selectedEnd: (row: Int, col: Int)?
    
    // Live mouse/cursor position for showing a dynamic line
    @Published var currentMousePosition: CGPoint? = nil
    
    // Computed distance and course between the two selected cells
    @Published var navigationData: NavigationData? = nil
    
    // view model used to obtain sectors from row, col information
    private let sensorViewModel: ShortRangeSensorViewModel

    /// sensorViewModel is used to convert row, col info to sector info
    init(sensorViewModel: ShortRangeSensorViewModel) {
        self.sensorViewModel = sensorViewModel
    }

    /// Resets all state to allow a new selection to begin
    func resetSelection() {
        selectedStart = nil
        selectedEnd = nil
        currentMousePosition = nil
        navigationData = nil
    }

    /// Handles user selection of a cell
    func selectCell(row: Int, col: Int) {
        if selectedStart == nil {
            // First click sets the starting cell
            selectedStart = (row, col)
        } else if selectedEnd == nil {
            // Second click sets the end cell and triggers metric computation
            selectedEnd = (row, col)
            computeMetrics()
        } else {
            // If both are already set, reset and start over
            resetSelection()
            selectedStart = (row, col)
        }
    }

    /// Updates the live cursor/mouse position for dynamic line drawing
    func updateMousePosition(_ position: CGPoint?) {
        currentMousePosition = position
    }

    /// Calculates distance and course from the selected start and end cells
    private func computeMetrics() {
        guard let start = selectedStart, let end = selectedEnd else { return }

        let dx = Double(end.col - start.col)
        let dy = Double(end.row - start.row)

        // Euclidean distance
        let distance = sqrt(dx * dx + dy * dy)

        // Angle in degrees (0° is to the right, 90° is up, etc.)
        let angleInDegrees = atan2(dy, dx) * 180 / .pi
        
        let course = Course(degrees: angleInDegrees)
        navigationData = NavigationData(course: course, distance: distance)
    }
}
