//
//  NotificationViewModel.swift
//  Meal App
//
//  Created by Isuru Ariyarathna on 2024-11-05.
//

import SwiftUI
import Combine

class NotificationViewModel: ObservableObject {
    @Published var isVisible: Bool = false
    @Published var message: String = ""
    
    func showNotification(with message: String, duration: TimeInterval = 3.0) {
        self.message = message
        withAnimation {
            self.isVisible = true
        }
        
        // hide
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            withAnimation {
                self.isVisible = false
            }
        }
    }
}
