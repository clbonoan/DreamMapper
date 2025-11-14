//
//  DreamListView.swift
//  DreamMapper
//
//  Created by Christine Bonoan on 11/14/25.
//

import SwiftUI
import SwiftData

struct DreamListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "#F4F3EE")
                    .ignoresSafeArea()
                
            }
        }
        
    }
}

#Preview {
    DreamListView()
        .modelContainer(for: Item.self, inMemory: true)
}
