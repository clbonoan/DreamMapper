//
//  DreamPromptView.swift
//  DreamMapper
//
//  Created by Christine Bonoan on 11/18/25.
//

import SwiftUI
import SwiftData

struct DreamPromptView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "#F4F3EE")
                    .ignoresSafeArea()
                VStack {
                    Text("tell us what happened and find out\nwhat your dream means")
                        .font(.custom("AlegreyaSans-Regular", size: 22))
                        .multilineTextAlignment(.center)
                    
                }
            }
        }
    }
}

#Preview {
    DreamPromptView()
        .modelContainer(for: Item.self, inMemory: true)
}
