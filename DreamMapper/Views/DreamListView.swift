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
    @Query(sort: \Dream.createdAt, order: .reverse)
    private var dreams: [Dream]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "#F4F3EE")
                    .ignoresSafeArea()
                
                // use Group to combine multiple views (DreamDetailView and DreamRowView)
                Group {
                    if dreams.isEmpty {
                        ContentUnavailableView {
                            Label("No Dreams", systemImage: "tray")
                                .font(.custom("AlegreyaSans-Medium", size: 26))
                                .foregroundColor(Color(hex: "#484848"))
                        } description: {
                            Text("Start Dreaming!")
                                .font(.custom("AlegreyaSans-Medium", size: 20))
                        }
                    } else {
                        List {
                            // show list of dreams
                            ForEach(dreams) { dream in
                                NavigationLink {
                                    DreamDetailView(dream: dream)
                                } label: {
                                    DreamRowView(dream: dream)
                                }
                            }
                            .onDelete(perform: delete)
                        }
                        .listStyle(.insetGrouped)
                        .scrollContentBackground(.hidden)
                        .background(.clear)
                        .listRowBackground(Color.clear)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("My Dreams")
                        .font(.custom("AlegreyaSans-Bold", size: 40))
                        .foregroundColor(Color(hex: "#B6CFB6"))
                }
            }
        }
    }
    // allow user to delete their dream (default is swiping left on item)
    private func delete(at offsets: IndexSet) {
        for i in offsets { modelContext.delete(dreams[i]) }
        try? modelContext.save()
    }
}

// single row per dream in the list
private struct DreamRowView: View {
    let dream: Dream
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(dream.title.isEmpty ? "Untitled Dream" : dream.title)
                .font(.custom("AlegreyaSans-Bold", size: 17))
            
            Text(motifsPreview)
                .font(.custom("AlegreyaSans-Light", size: 15))
                .foregroundStyle(.secondary)
                .lineLimit(1)
        }
    }
    
    private var motifsPreview: String {
        let symbols = dream.motifs.map { $0.symbol }.filter { !$0.isEmpty }
        if symbols.isEmpty {
            return "Motifs: (none)"
        }
        
        // only show 4 motifs in the preview before user clicks the dream
        let maxShown = 4
        let shown = symbols.prefix(maxShown)
        var text = "Motifs: " + shown.joined(separator: ", ")
        if symbols.count > maxShown {
            text += " +"
        }
        return text
    }
}

#Preview {
    DreamListView()
        .modelContainer(for: Dream.self, inMemory: true)
}
