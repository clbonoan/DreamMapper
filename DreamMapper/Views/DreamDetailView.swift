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
            Color(hex: "#F4F3EE")
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // separated sections for dream details
                    DreamHeaderSection(dream: controller.dream)
                    Divider()
                    
                    DreamMoonPhaseSection(
                        moonPhase: controller.dream.moonPhase ?? "Unknown",
                        fontOffset: controller.fontOffset
                    )
                    Divider()
                    
                    DreamOriginalTextSection(
                        text: controller.dream.text,
                        fontOffset: controller.fontOffset)
                    Divider()
                    
                    DreamSummarySection(
                        summary: controller.dream.summary,
                        fontOffset: controller.fontOffset)
                    Divider()
                    
                    DreamMotifsSection(
                        motifs: controller.dream.motifs,
                        fontOffset: controller.fontOffset)
                    Divider()
                    
                    DreamInterpretationSection(
                        text: controller.dream.personalInterpretation,
                        fontOffset: controller.fontOffset)
                    Divider()
                    
                    DreamWhatToDoNextSection(
                        items: controller.dream.whatToDoNext,
                        fontOffset: controller.fontOffset)
                    Divider()
                    
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
            
            Text(dream.createdAt, style: .date)
                .font(.custom("AlegreyaSans-Regular", size: 14))
                .foregroundStyle(.secondary)
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

            HStack(spacing: 8) {
                Text(moonEmoji(for: moonPhase))
                    .font(.system(size: 28))     // big emoji icon

                Text(moonPhase)
                    .font(.custom("AlegreyaSans-Regular", size: 16 + fontOffset))
                    .foregroundStyle(.primary)
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
            
            Text(text)
                .font(.custom("AlegreyaSans-Regular", size: 16 + fontOffset))
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
            
            Text(summary)
                .font(.custom("AlegreyaSans-Regular", size: 16 + fontOffset))
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
            
            if motifs.isEmpty {
                Text("No motifs available.")
                    .foregroundStyle(.secondary)
            } else {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(motifs) { motif in
                        VStack(alignment: .leading, spacing: 2) {
                            Text(motif.symbol)
                                .font(.custom("AlegreyaSans-Regular", size: 15 + fontOffset))
                                .bold()
                            Text(motif.meaning)
                                .font(.custom("AlegreyaSans-Regular", size: 13 + fontOffset))
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
            
            Text(text)
                .font(.custom("AlegreyaSans-Regular", size: 16 + fontOffset))
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
            
            if items.isEmpty {
                Text("No suggestions available.")
                    .foregroundStyle(.secondary)
            } else {
                VStack(alignment: .leading, spacing: 6) {
                    ForEach(Array(items.enumerated()), id: \.offset) { _, item in
                        HStack(alignment: .top, spacing: 4) {
                            Text("-")
                            Text(item)
                                .font(.custom("AlegreyaSans-Regular", size: 16 + fontOffset))
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
            
            Text(sentiment.capitalized)
                .font(.custom("AlegreyaSans-Regular", size: 16 + fontOffset))
        }
    }
}


