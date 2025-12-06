//
//  DreamListView.swift
//  DreamMapper
//
//  Created by Christine Bonoan on 11/14/25.
//  This lists all the user's analyzed dreams; user can delete them or read more details about the analysis

import SwiftUI
import SwiftData

struct DreamListView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var controller = DreamListController()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "#F4F3EE")
                    .ignoresSafeArea()
                
                // use Group to combine multiple views (DreamDetailView and DreamRowView)
                Group {
                    if controller.dreams.isEmpty {
                        ContentUnavailableView {
                            Label("No Dreams", systemImage: "zzz")
                                .font(.custom("AlegreyaSans-Medium", size: 26))
                                .foregroundColor(Color(hex: "#484848"))
                        } description: {
                            Text("Start Dreaming!")
                                .font(.custom("AlegreyaSans-Medium", size: 20))
                        }
                    } else {
                        List {
                            // show list of dreams
                            ForEach(controller.dreams) { dream in
                                NavigationLink {
                                    DreamDetailView(dream: dream)
                                } label: {
                                    DreamRowView(dream: dream)
                                }
                                // change color of row based on sentiment
                                .listRowBackground(
                                    dream.sentimentColor.opacity(0.6)
                                )
                            }
                            .onDelete(perform: controller.delete)
                        }
                        .listStyle(.insetGrouped)
                        .scrollContentBackground(.hidden)
                        .background(.clear)
                    }
                }
            }
//            .toolbar {
//                ToolbarItem(placement: .principal) {
//                    Text("My Dreams")
//                        .font(.custom("AlegreyaSans-Bold", size: 40))
//                        .foregroundColor(Color(hex: "#B6CFB6"))
//                }
//            }
        }
        .onAppear {
            controller.attachContext(modelContext)
        }
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

// row color based on analyzed dream sentiment
extension Dream {
    var sentimentColor: Color {
        switch sentiment {
        case "calm":
            return Color(hex: "#CFE8FF")   // soft blue
        case "stressed":
            return Color(hex: "#FFD0D0")   // light red
        case "mixed":
            return Color(hex: "#E5E5E5")   // light gray
        case "sad":
            return Color(hex: "#D0D8FF")   // muted blue
        case "hopeful":
            return Color(hex: "#D7F2C2")   // soft green
        case "confused":
            return Color(hex: "#E3D3FF")   // lavender
        case "angry":
            return Color(hex: "#FFB3B3")   // stronger red/pink
        case "joyful":
            return Color(hex: "#FFF2B3")   // soft yellow
        default:
            return Color(hex: "#EFEFE8")
        }
    }
}

#Preview {
    DreamListView()
        .modelContainer(for: Dream.self, inMemory: true)
}
