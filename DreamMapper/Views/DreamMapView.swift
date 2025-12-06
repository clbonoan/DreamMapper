//
//  DreamMapView.swift
//  DreamMapper
//
//  Created by Christine Bonoan on 11/14/25.
//

import SwiftUI
import SwiftData

struct DreamMapView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Dream]
    
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
    DreamMapView()
        .modelContainer(for: Dream.self, inMemory: true)
}
