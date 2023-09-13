//
//  HapticManager.swift
//  CryptoApp
//
//  Created by NamaN  on 13/09/23.
//

import Foundation
import SwiftUI

class HapticManager {
    
    static private let generator = UINotificationFeedbackGenerator()
    
    static func notification(type : UINotificationFeedbackGenerator.FeedbackType){
        generator.notificationOccurred(type)
    }
}
