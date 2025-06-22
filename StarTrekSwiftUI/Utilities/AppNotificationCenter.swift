//
//  AppNotificationCenter.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 6/14/25.
//

import Foundation
import Combine

/// Central hub for app-wide notifications
class AppNotificationCenter {
    static let shared = AppNotificationCenter()

    private init() {} // singleton

    // MARK: - Notification Names
    enum Name {
        static let quadrantDataDidChange = Notification.Name("quadrantDataDidChange")
        
    }

    // MARK: - Posting
    func postQuadrantDataDidChange() {
        NotificationCenter.default.post(name: Name.quadrantDataDidChange, object: nil)
    }

    // MARK: - Publishers
    var quadrantDataDidChangePublisher: AnyPublisher<Void, Never> {
        NotificationCenter.default
            .publisher(for: Name.quadrantDataDidChange)
            .map { _ in () }
            .eraseToAnyPublisher()
    }
}
