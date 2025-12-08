//
//  AuraBubble.swift
//  DreamMapper
//
//  Created by Christine Bonoan on 12/6/25.
//  This is a reusable visual that will be used in the dream map; creates the aura color bubbles (circles)

import SwiftUI

struct AuraBubble: View {
    let color: Color
        
    // state for pulsing the color bubble
    @State private var isPulsing = false
    
    var body: some View {
        Circle()
            .fill(
                RadialGradient(
                    gradient: Gradient(colors: [
                        // center
                        color.opacity(0.9),
                        // edges fade out
                        color.opacity(0.0)
                    ]),
                    center: .center,
                    startRadius: 0,
                    endRadius: 150
                )
            )
            //.frame(width: 240, height: 240)
            .blur(radius: 35)
            // pulsing in and out
            .scaleEffect(isPulsing ? 1.8 : 1.3)
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


