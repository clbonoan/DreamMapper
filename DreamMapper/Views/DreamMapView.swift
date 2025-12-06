//
//  DreamMapView.swift
//  DreamMapper
//
//  Created by Christine Bonoan on 11/14/25.
//  This is a scrollable view with all the aura nodes scattered in a grid-like pattern.

import SwiftUI
import SwiftData

struct DreamMapView: View {
    @Query(sort: \Dream.createdAt, order: .reverse)
    private var dreams: [Dream]
    
    // palette of aura colors to choose from
    private let auraPalette: [Color] = [
        Color(hex: "#FF968A"),  // pink-red
        Color(hex: "#ABDEE6"),  // blue
        Color(hex: "#F3B0C3"),  // pink
        Color(hex: "#FFFFB5"),  // yellow
        Color(hex: "#FFC8A2"),  // orange
        Color(hex: "#CBAACB"),  // purple
        Color(hex: "#97CIA9")  // green
    ]
    
    // spacing and layout config for grid of nodes
    private let spacing: CGFloat = 260
    private let columns: Int = 4
    
    // canvas (view) grows with number of dreams
    private var canvasSize: CGSize {
        let count = max(dreams.count, 1)
        let rows = (count - 1) / columns + 1
        
        let width = max(800, CGFloat(columns) * spacing + 200)
        let height = max(800, CGFloat(rows) * spacing + 200)
        
        return CGSize(width: width, height: height)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "#F4F3EE")
                    .ignoresSafeArea()
                
                // canvas you can move through left/right/up/down
                ScrollView([.horizontal, .vertical]) {
                    ZStack {
                        // give 1 aura bubble/node per dream
                        ForEach(Array(dreams.enumerated()), id: \.element.id) { index, dream in
                            DreamAuraNode(
                                dream: dream,
                                auraColor: colorForDream(dream, index: index)
                            )
                            .position(positionForIndex(index))
                        }
                    }
                    // this makes the content larger than the screen, so you can scroll around
                    .frame(width: canvasSize.width, height: canvasSize.height)
                }
            }
            .navigationBarTitle("Dream Map")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    // deterministic node positions so nodes don't move to different spots every reload
    private func positionForIndex(_ index: Int) -> CGPoint {
        let row = index / columns
        let col = index % columns
        
        let x = 150 + CGFloat(col) * spacing
        let y = 150 + CGFloat(row) * spacing
        
        return CGPoint(x: x, y: y)
    }
    
    // choose a color per dream
    private func colorForDream(_ dream: Dream, index: Int) -> Color {
        guard !auraPalette.isEmpty else { return .pink }
        
        // stable hash based on title and createdAt
        let hash = dream.title.hashValue ^ dream.createdAt.hashValue
        let safeIndex = abs(hash) % auraPalette.count
        return auraPalette[safeIndex]
    }
}

#Preview {
    DreamMapView()
        .modelContainer(for: Dream.self, inMemory: true)
}
