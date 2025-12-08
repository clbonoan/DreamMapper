//
//  DreamDetailView.swift
//  DreamMapper
//
//  Created by Christine Bonoan on 11/14/25.
//  This view lets users see the dream analysis details in readable text format.

import SwiftUI
import SwiftData

struct DreamDetailView: View {
    @StateObject private var controller: DreamDetailController
    
    init(dream: Dream) {
        _controller = StateObject(wrappedValue: DreamDetailController(dream: dream))
    }
    
    var body: some View {
        ZStack {
            Color(hex: "#15151b")
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // separated sections for dream details
                    DreamHeaderSection(dream: controller.dream)
                    Divider()
                        .overlay(Color(hex: "#B6CFB6"))
                    
                    DreamMoonPhaseSection(
                        moonPhase: controller.dream.moonPhase ?? "Unknown",
                        fontOffset: controller.fontOffset
                    )
                    Divider()
                        .overlay(Color(hex: "#B6CFB6"))
                    
                    DreamOriginalTextSection(
                        text: controller.dream.text,
                        fontOffset: controller.fontOffset)
                    Divider()
                        .overlay(Color(hex: "#B6CFB6"))
                    
                    DreamSummarySection(
                        summary: controller.dream.summary,
                        fontOffset: controller.fontOffset)
                    Divider()
                        .overlay(Color(hex: "#B6CFB6"))
                    
                    DreamMotifsSection(
                        motifs: controller.dream.motifs,
                        fontOffset: controller.fontOffset)
                    Divider()
                        .overlay(Color(hex: "#B6CFB6"))
                    
                    DreamInterpretationSection(
                        text: controller.dream.personalInterpretation,
                        fontOffset: controller.fontOffset)
                    Divider()
                        .overlay(Color(hex: "#B6CFB6"))
                    
                    DreamWhatToDoNextSection(
                        items: controller.dream.whatToDoNext,
                        fontOffset: controller.fontOffset)
                    Divider()
                        .overlay(Color(hex: "#B6CFB6"))
                    
                    DreamSentimentSection(
                        sentiment: controller.dream.sentiment,
                        fontOffset: controller.fontOffset)
                    
                    Spacer(minLength: 20)
                }
                .padding()
            }
            .toolbar {
                // title of view
//                ToolbarItem(placement: .principal) {
//                    Text("Dream Details")
//                        .font(.custom("AlegreyaSans-Bold", size: 40))
//                        .foregroundColor(Color(hex: "#B6CFB6"))
//                }
                
                // minus button for font decrease
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        controller.decreaseFont()
                    } label: {
                        Image(systemName: "minus.magnifyingglass")
                            .foregroundColor(Color(hex: "#484848"))
                    }
                }
                
                // plus button for font increase
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        controller.increaseFont()
                    } label: {
                        Image(systemName: "plus.magnifyingglass")
                            .foregroundColor(Color(hex: "#484848"))
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(.clear)
        }
    }
}

// separated for type-check restraints
struct DreamHeaderSection: View {
    let dream: Dream
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(dream.title.isEmpty ? "Untitled Dream" : dream.title)
                .font(.custom("AlegreyaSans-Bold", size: 28))
                .foregroundColor(Color(hex: "F4F3EE"))
            
            Text(dream.createdAt, style: .date)
                .font(.custom("AlegreyaSans-Regular", size: 14))
                .foregroundStyle(.white)
        }
    }
}

struct DreamMoonPhaseSection: View {
    let moonPhase: String
    let fontOffset: CGFloat
    
    private func moonEmoji(for phase: String) -> String {
        let p = phase.lowercased()

        switch true {
        case p.contains("new"): return "🌑"
        case p.contains("waxing crescent"): return "🌒"
        case p.contains("first quarter"): return "🌓"
        case p.contains("waxing gibbous"): return "🌔"
        case p.contains("full"): return "🌕"
        case p.contains("waning gibbous"): return "🌖"
        case p.contains("last quarter"): return "🌗"
        case p.contains("waning crescent"): return "🌘"
        default: return "🌙"
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {

            Text("Moon Phase")
                .font(.custom("AlegreyaSans-Medium", size: 17 + fontOffset))
                .foregroundColor(Color(hex: "F4F3EE"))

            HStack(spacing: 8) {
                Text(moonEmoji(for: moonPhase))
                    .font(.system(size: 28))     // big emoji icon

                Text(moonPhase)
                    .font(.custom("AlegreyaSans-Regular", size: 16 + fontOffset))
                    .foregroundStyle(.white)
            }
        }
    }
}
    
struct DreamOriginalTextSection: View {
    let text: String
    let fontOffset: CGFloat
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Original Dream Entry")
                .font(.custom("AlegreyaSans-Medium", size: 17 + fontOffset))
                .foregroundColor(Color(hex: "F4F3EE"))
            
            Text(text)
                .font(.custom("AlegreyaSans-Regular", size: 16 + fontOffset))
                .foregroundColor(Color(hex: "F4F3EE"))
        }
    }
}

struct DreamSummarySection: View {
    let summary: String
    let fontOffset: CGFloat
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Summary")
                .font(.custom("AlegreyaSans-Medium", size: 17 + fontOffset))
                .foregroundColor(Color(hex: "F4F3EE"))
            
            Text(summary)
                .font(.custom("AlegreyaSans-Regular", size: 16 + fontOffset))
                .foregroundColor(Color(hex: "F4F3EE"))
        }
    }
}

struct DreamMotifsSection: View {
    let motifs: [Motif]
    let fontOffset: CGFloat
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Motifs")
                .font(.custom("AlegreyaSans-Medium", size: 17 + fontOffset))
                .foregroundColor(Color(hex: "F4F3EE"))
            
            if motifs.isEmpty {
                Text("No motifs available.")
                    .foregroundStyle(.white)
            } else {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(motifs) { motif in
                        VStack(alignment: .leading, spacing: 2) {
                            Text(motif.symbol)
                                .font(.custom("AlegreyaSans-Regular", size: 15 + fontOffset))
                                .foregroundColor(Color(hex: "F4F3EE"))
                                .bold()
                            Text(motif.meaning)
                                .font(.custom("AlegreyaSans-Regular", size: 13 + fontOffset))
                                .foregroundColor(Color(hex: "F4F3EE"))
                        }
                    }
                }
            }
        }
    }
}

struct DreamInterpretationSection: View {
    let text: String
    let fontOffset: CGFloat
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Personal Interpretation")
                .font(.custom("AlegreyaSans-Medium", size: 17 + fontOffset))
                .foregroundColor(Color(hex: "F4F3EE"))
            
            Text(text)
                .font(.custom("AlegreyaSans-Regular", size: 16 + fontOffset))
                .foregroundColor(Color(hex: "F4F3EE"))
        }
    }
}

struct DreamWhatToDoNextSection: View {
    let items: [String]
    let fontOffset: CGFloat
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("What To Do Next")
                .font(.custom("AlegreyaSans-Medium", size: 17 + fontOffset))
                .foregroundColor(Color(hex: "F4F3EE"))
            
            if items.isEmpty {
                Text("No suggestions available.")
                    .foregroundStyle(.white)
            } else {
                VStack(alignment: .leading, spacing: 6) {
                    ForEach(Array(items.enumerated()), id: \.offset) { _, item in
                        HStack(alignment: .top, spacing: 4) {
                            Text("-")
                            Text(item)
                                .font(.custom("AlegreyaSans-Regular", size: 16 + fontOffset))
                                .foregroundColor(Color(hex: "F4F3EE"))
                        }
                    }
                }
            }
        }
    }
}

struct DreamSentimentSection: View {
    let sentiment: String
    let fontOffset: CGFloat
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Overall Sentiment")
                .font(.custom("AlegreyaSans-Medium", size: 17 + fontOffset))
                .foregroundColor(Color(hex: "F4F3EE"))
            
            Text(sentiment.capitalized)
                .font(.custom("AlegreyaSans-Regular", size: 16 + fontOffset))
                .foregroundColor(Color(hex: "F4F3EE"))
        }
    }
}

#Preview {
    // sample motifs
    let sampleMotifs = [
        Motif(symbol: "fighting", meaning: "Represents conflict or inner struggle."),
        Motif(symbol: "tunnel", meaning: "Suggests transition or uncertainty."),
        Motif(symbol: "ankle injury", meaning: "Fear of instability or losing balance."),
        Motif(symbol: "chase", meaning: "Avoidance of a problem or emotion.")
    ]

    // sample dream model
    let sampleDream = Dream(
        title: "Running Through a Tunnel",
        text: "I was running through a long tunnel while someone chased me. I felt scared but eventually found an exit into bright sunlight.",
        summary: "A stressful dream about being chased that shifts into relief and clarity at the end.",
        sentiment: "stressed",
        personalInterpretation: "This dream may reflect feeling pressure in your waking life, but also a sense that a way out or resolution is possible.",
        whatToDoNext: [
            "Journal about current sources of stress.",
            "Notice if you are avoiding a hard conversation.",
            "Do a short grounding exercise before bed."
        ],
        motifs: sampleMotifs,
        moonPhase: "Waxing Crescent"
    )

    return NavigationStack {
        DreamDetailView(dream: sampleDream)
    }
    .modelContainer(for: [Dream.self, Motif.self], inMemory: true)
}
