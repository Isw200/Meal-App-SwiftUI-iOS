//
//  NotificationView.swift
//  Meal App
//
//  Created by Isuru Ariyarathna on 2024-11-05.
//

import SwiftUI

struct NotificationView: View {
    let message: String
        
    var body: some View {
        HStack {
            Image(systemName: "bell.fill")
                .foregroundColor(.white)
                .padding(.leading, 10)
            Text(message)
                .foregroundColor(.white)
                .font(.body)
                .padding(.vertical, 10)
                .padding(.horizontal, 10)
        }
        .frame(maxWidth: 260)
        .background(Color.black.opacity(0.8))
        .cornerRadius(15)
        .padding()
        .transition(.move(edge: .bottom).combined(with: .opacity))
        .shadow(radius: 5)
        .padding(.bottom, 60)
    }
}

#Preview {
    NotificationView(message: "Removed from favouities")
}
