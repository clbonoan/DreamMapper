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
    let phaseDelay: Double
    
    // customize initializer to add phaseDelay
    init(dream: Dream, auraColor: Color, phaseDelay: Double = 0) {
        self.dream = dream
        self.auraColor = auraColor
        self.phaseDelay = phaseDelay
    }
    
    // only allow up to 7 motif bullets to show around the title
    // the cap for motifs is 7 in the returned JSON from ollama
    private let maxMotifsShown: Int = 7
    @State private var float = false
    @State private var isExpanded = false
    @State private var orbit = false
    // to show meanings for dream title and motifs
    @State private var selectedMotif: Motif? = nil
    @State private var showMotifPopup = false
    @State private var showSummary = false
    @State private var selectedTitle: Dream? = nil

    var body: some View {
        ZStack {
            // centered aura bubble
            AuraBubble(color: auraColor)
                .frame(width: 260, height: 260)
                .opacity(0.9)

            // dream title
            Text(dream.title.isEmpty ? "Untitled" : dream.title)
                .font(.custom("AlegreyaSans-Bold", size: 24))
                .foregroundColor(Color(hex: "#484848"))
                // display dream summary when you click the title
                .onTapGesture {
                    showSummary = true
                }

            ZStack{
            ForEach(Array(dream.motifs.prefix(maxMotifsShown).enumerated()), id: \.element.id) { index, motif in
                let count = dream.motifs.prefix(maxMotifsShown).count
                let baseAngle = 360.0 / Double(count) * Double(index)
                // fixed stable orbit; this is spacing between the title and motifs
                let radius: CGFloat = 115
                                   
                // orbiting motif text
                Text(motif.symbol)
                    .font(.custom("AlegreyaSans-Regular", size: 14))
                    .foregroundColor(Color(hex: "#484848"))
                    //.rotationEffect(.degrees(orbit ? 360 : 0))
                    // change where the motifs are placed respective to the title
                    .offset(
                        x: radius * cos((baseAngle * .pi / 180)),
                        y: radius * sin((baseAngle * .pi / 180))
                    )
                    // display motif meaning when you click the motif
                    .onTapGesture {
                        selectedMotif = motif
                        showMotifPopup = true
                    }
                    .animation(
                        .linear(duration: 5)
                        .repeatForever(autoreverses: false),
                        value: orbit
                    )
            }
        }
    }
    // sizing the node
    .frame(width: 260, height: 260)
    .background(
        // aura behind the dream
        AuraBubble(color: auraColor, phaseDelay: phaseDelay)
            .allowsHitTesting(false)
    )
        
    // click motif functionaility
    .alert("Motif: \(selectedMotif?.symbol ?? "")", isPresented: $showMotifPopup) {
        Button("Close", role: .cancel) { }
    } message: {
        Text(selectedMotif?.meaning ?? "")
    }
        
    // click dream title functionality
    .alert("Interpretation for \(dream.title)", isPresented: $showSummary) {
        Button("Close", role: .cancel) { }
    } message: {
        Text(dream.personalInterpretation)
            .font(.custom("AlegreyaSans-Regular", size: 16))
    }
        
    .offset(y: float ? -4 : 4)
    .animation(.easeInOut(duration: 2).repeatForever(), value: float)
    .onAppear {
        float = true
        orbit = true
    }
    }
}

#Preview {
    // sample dream to see what output looks like
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
