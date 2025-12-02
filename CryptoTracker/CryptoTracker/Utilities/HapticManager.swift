//
//  HapticManager.swift
//  CryptoTracker
//
//  Created by Himanshu Namdeo on 04/11/25.
//

import SwiftUI

class HapticManager {
    
    static private let generator = UINotificationFeedbackGenerator()
    
    static func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        generator.notificationOccurred(type)
    }
}
