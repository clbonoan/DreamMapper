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
    
    var body: some View {
        ZStack {
            // background cloud
            AuraBubble(color: auraColor)
            
            // card with title + motifs
            DreamAuraCard(dream: dream)
        }
    }
}

