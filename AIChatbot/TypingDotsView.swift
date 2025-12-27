//
//  TypingIndicatorView.swift
//  AIChatbot
//
//  Created by Suraj Sharma on 27/12/25.
//

import SwiftUI

struct TypingDotsView: View {
    @State private var animate = false

    var body: some View {
        HStack(spacing: 6) {
            Circle()
                .frame(width: 8, height: 8)
                .opacity(animate ? 0.3 : 1)

            Circle()
                .frame(width: 8, height: 8)
                .opacity(animate ? 0.3 : 1)
                .animation(.easeInOut(duration: 0.6).repeatForever().delay(0.2), value: animate)

            Circle()
                .frame(width: 8, height: 8)
                .opacity(animate ? 0.3 : 1)
                .animation(.easeInOut(duration: 0.6).repeatForever().delay(0.4), value: animate)
        }
        .foregroundColor(.gray)
        .onAppear {
            animate = true
        }
    }
}

