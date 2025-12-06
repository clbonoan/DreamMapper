//
//  DreamAuraCard.swift
//  DreamMapper
//
//  Created by Christine Bonoan on 12/6/25.
//  This is the uI for title + motifs list that will be used by DreamAuraNode.

import SwiftUI

struct DreamAuraCard: View {
    let dream: Dream
    // only allow up to 7 motif bullets to show around the title
    // the cap for motifs is 7 in the returned JSON from ollama
    let maxMotifsShown: Int = 7
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(dream.title.isEmpty ? "Untitled" : dream.title)
                .font(.custom("AlegreyaSans-Bold", size: 22))
                .foregroundColor(Color(hex: "#484848"))
            
            ForEach(dream.motifs.prefix(maxMotifsShown)) { motif in
                HStack(alignment: .top, spacing: 6) {
                    Circle()
                        .frame(width: 5, height: 5)
                        .offset(y: 6)
                    Text(motif.symbol)
                        .font(.custom("AlegreyaSans-Regular", size: 16))
                        .lineLimit(1)
                }
            }
        }
        .padding(14)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .shadow(radius: 6, y: 3)
    }
}
