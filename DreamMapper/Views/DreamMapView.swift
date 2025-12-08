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
    @State private var showNodes = false
    @State private var zoomScale: CGFloat = 1.0
    
    // match DreamAuraNode frame size
    private let nodeSize: CGFloat = 280
    // palette of aura colors to choose from
    private let auraPalette: [Color] = [
        Color(hex: "#FF968A"),  // pink-red
        Color(hex: "#C6DEF1"),  // blue
        Color(hex: "#F3B0C3"),  // pink
        Color(hex: "#FFFFB5"),  // yellow
        Color(hex: "#FFC8A2"),  // orange
        Color(hex: "#CBAACB"),  // purple
        Color(hex: "#97C1A9")  // green
    ]
    
    // spacing and layout config for grid of nodes
    private let baseSpacing: CGFloat = 60
    private let columns: Int = 4
    private var spacing: CGFloat {
        nodeSize + baseSpacing
    }
    
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
//                Color(hex: "#F4F3EE")
                Color(hex: "#15151b")
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
                            .scaleEffect(showNodes ? 1 : 0.5)
                            .opacity(showNodes ? 1 : 0)
                            // moves dreams around the map
                            .animation(
                                .spring(response: 1.5, dampingFraction: 0.7)
                                .delay(Double(index) * 0.02),
                                value: showNodes
                            )
                                    
                        }
                    }
                    //.scaleEffect(zoomScale)
                    //.animation(.easeInOut, value: zoomScale)
                    // this makes the content larger than the screen, so you can scroll around
                    .frame(width: canvasSize.width, height: canvasSize.height)
                    
                }
                .gesture(
                    MagnificationGesture()
                        .onChanged { amount in zoomScale = amount }
                )
            }
            .onAppear {
                showNodes = true
            }
            .navigationBarTitle("Dream Map")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    // deterministic, non-overlapping node positions
//    private func randomPosition(in canvas: CGSize) -> CGPoint {
//        CGPoint(
//            x: CGFloat.random(in: 100...(canvas.width - 100)),
//            y: CGFloat.random(in: 100...(canvas.height - 100))
//        )
//    }
    
    private func positionForIndex(_ index: Int) -> CGPoint {
        let row = index / columns
        let col = index % columns

        let startX: CGFloat = 100 + spacing / 2
        let startY: CGFloat = 100 + spacing / 2

        var x = startX + CGFloat(col) * spacing
        var y = startY + CGFloat(row) * spacing

        // small movement based on placement
        let jitter: CGFloat = 16
        x += CGFloat((index * 37) % Int(jitter)) - jitter / 2
        y += CGFloat((index * 53) % Int(jitter)) - jitter / 2

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
        .modelContainer(for: [Dream.self, Motif.self], inMemory: true)
}
