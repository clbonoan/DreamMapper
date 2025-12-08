//
//  AuraBubble.swift
//  DreamMapper
//
//  Created by Christine Bonoan on 12/6/25.
//  This is a reusable visual that will be used in the dream map; creates the aura color bubbles (circles)

import SwiftUI

struct AuraBubble: View {
    let color: Color
    @State private var isPulsing = false
    var body: some View {
        Circle()
            .fill(
                RadialGradient(
                    gradient: Gradient(colors: [
                        color.opacity(0.9),   // center
                        color.opacity(0.0)    // edges fade out
                    ]),
                    center: .center,
                    startRadius: 0,
                    endRadius: 150
                )
            )
            //.frame(width: 240, height: 240)
            .blur(radius: 35)
            .scaleEffect(isPulsing ? 1.8 : 1.3)  // pulsing in & out
             .animation(
                .easeInOut(duration: 1.5)
                     .repeatForever(autoreverses: true),
                 value: isPulsing
             )
             .onAppear {
                 isPulsing = true
             }
    }
}

#Preview {
    AuraBubble(color: .purple)
}


