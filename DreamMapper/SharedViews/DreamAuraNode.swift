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
    @State private var float = false
    @State private var isExpanded = false
    @State private var orbit = false

    var body: some View {
                ZStack {
                    // CENTERED AURA BUBBLE
                    AuraBubble(color: auraColor)
                        .frame(width: 260, height: 260)
                        .opacity(0.9)

                    // DREAM TITLE
                    Text(dream.title.isEmpty ? "Untitled" : dream.title)
                        .font(.custom("AlegreyaSans-Bold", size: 24))
                        .foregroundColor(Color(hex: "#484848"))

                    ZStack{
                    ForEach(Array(dream.motifs.prefix(maxMotifsShown).enumerated()), id: \.element.id) { index, motif in
                        let count = dream.motifs.prefix(maxMotifsShown).count
                        let baseAngle = 360.0 / Double(count) * Double(index)
                        let radius: CGFloat = 100   // fixed stable orbit
                                           
                        // ORBITING TEXT LABEL
                        Text(motif.symbol)
                            .font(.custom("AlegreyaSans-Regular", size: 14))
                            .foregroundColor(Color(hex: "#484848"))
                            //.rotationEffect(.degrees(orbit ? 360 : 0))
                            .offset(
                                    x: radius * cos((baseAngle * .pi / 180)),
                                    y: radius * sin((baseAngle * .pi / 180))
                                    )
//                            .animation(
//                                        .linear(duration: 12)
//                                        .repeatForever(autoreverses: false),
//                                        value: orbit
//                                        )
                    }
                }
            }
            // canvas bigger than view
            .frame(width: 260, height: 260)
            .background(
                AuraBubble(color: auraColor)   // aura behind the dream
                    .allowsHitTesting(false)
            )
            .offset(y: float ? -4 : 4)
//            .animation(.easeInOut(duration: 3).repeatForever(),
//                       value: float)
//            .onAppear {
//                float = true
//                orbit = true
//            }
        }
    }

#Preview {
    let sampleDream = Dream(
        title: "Bad Dream",
        text: "I was fighting a big guy in a tunnel and hurt my ankle.",
        summary: "A confrontation dream showing stress.",
        sentiment: "stressed",
        personalInterpretation: "This dream reflects feelings of pressure or conflict.",
        whatToDoNext: ["Reflect on current stressors", "Practice grounding"],
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
