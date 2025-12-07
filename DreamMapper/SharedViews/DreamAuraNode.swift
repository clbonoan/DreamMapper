//
//  DreamAuraNode.swift
//  DreamMapper
//
//  Created by Christine Bonoan on 12/6/25.
//  This is the layout and positioning on the map; has one dream's aura cloud/bubble, title, and motifs.

import SwiftUI

struct DreamAuraNode: View {
    let dream: Dream
    let auraColor: Color
    
    // only allow up to 7 motif bullets to show around the title
    // the cap for motifs is 7 in the returned JSON from ollama
    private let maxMotifsShown: Int = 7
    
    var body: some View {
        ZStack {
            // background cloud
            AuraBubble(color: auraColor)
            
            //
            GeometryReader { geometry in
                let size = min(geometry.size.width, geometry.size.height)
                let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2 )
                let radius = size / 2 - 45
                
                ZStack {
                    Text(dream.title.isEmpty ? "Untitled" : dream.title)
                        .font(.custom("AlegreyaSans-Bold", size: 22))
                        .foregroundColor(Color(hex: "#484848"))
                        .multilineTextAlignment(.center)
                        .position(center)
                    
                    ForEach(Array(dream.motifs.prefix(maxMotifsShown).enumerated()),
                            id: \.element.id) { index, motif in
                        let total = max(1, min(maxMotifsShown, dream.motifs.count))
                        let angle = Angle.degrees(Double(index) / Double(total) * 360.0)
                        
                        let x = center.x + CGFloat(cos(angle.radians)) * radius
                        let y = center.y + CGFloat(sin(angle.radians)) * radius
                        
                        MotifBulletLabel(text: motif.symbol)
                            .position(x: x, y: y)
                    }
                }
            }
            .padding(24)
        }
        .frame(width: 260, height: 260)
    }
}

// helper
struct MotifBulletLabel: View {
    let text: String

    var body: some View {
        HStack(spacing: 6) {
            Circle()
                .frame(width: 5, height: 5)
                .offset(y: 1)
            Text(text)
                .font(.custom("AlegreyaSans-Regular", size: 15))
        }
        .foregroundColor(Color(hex: "#484848"))
        
    }
}

#Preview {
    let sampleDream = Dream(
        title: "Bad Dream",
        text: "I was fighting a big guy in a tunnel and hurt my ankle.",
        summary: "A confrontation dream showing stress.",
        sentiment: "stressed",
        personalInterpretation: "This dream reflects feelings of pressure or conflict.",
        whatToDoNext: [
            NextAction(text: "Reflect on current stressors"),
            NextAction(text: "Practice grounding")
        ],
        motifs: [
            Motif(symbol: "fighting", meaning: "Represents conflict."),
            Motif(symbol: "big guy", meaning: "Feeling overpowered."),
            Motif(symbol: "tunnel", meaning: "Uncertainty or transition."),
            Motif(symbol: "ankle injury", meaning: "Fear of instability.")
        ]
    )

    DreamAuraNode(
        dream: sampleDream,
        auraColor: .pink
    )

}
