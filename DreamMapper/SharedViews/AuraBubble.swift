//
//  AuraBubble.swift
//  DreamMapper
//
//  Created by Christine Bonoan on 12/6/25.
//  This is a reusable visual that will be used in the dream map; creates the aura color bubbles (circles)

import SwiftUI

struct AuraBubble: View {
    let color: Color
    
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
                    endRadius: 120
                )
            )
            .frame(width: 240, height: 240)
            .blur(radius: 35)
            .blendMode(.screen)
    }
}

#Preview {
    AuraBubble(color: .blue)
}


