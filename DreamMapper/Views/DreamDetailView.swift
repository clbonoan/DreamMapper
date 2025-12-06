//
//  DreamDetailView.swift
//  DreamMapper
//
//  Created by Christine Bonoan on 11/14/25.
//  This view lets users see the dream analysis details in readable text format.

import SwiftUI
import SwiftData

struct DreamDetailView: View {
    @StateObject private var fontScaler = FontScaler()
    let dream: Dream
    
    var body: some View {
        ZStack {
            Color(hex: "#F4F3EE")
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // separated sections for dream details
                    DreamHeaderSection(dream: dream)
                    Divider()
                    
                    DreamOriginalTextSection(text: dream.text, fontOffset: fontScaler.offset)
                    Divider()
                    
                    DreamSummarySection(summary: dream.summary, fontOffset: fontScaler.offset)
                    Divider()
                    
                    DreamMotifsSection(motifs: dream.motifs, fontOffset: fontScaler.offset)
                    Divider()
                    
                    DreamInterpretationSection(text: dream.personalInterpretation, fontOffset: fontScaler.offset)
                    Divider()
                    
                    DreamWhatToDoNextSection(items: dream.whatToDoNext, fontOffset: fontScaler.offset)
                    Divider()
                    
                    DreamSentimentSection(sentiment: dream.sentiment, fontOffset: fontScaler.offset)
                    
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
                        fontScaler.offset = max(fontScaler.offset - 1, -5)
                    } label: {
                        Image(systemName: "minus.magnifyingglass")
                            .foregroundColor(Color(hex: "#484848"))
                    }
                }
                
                // plus button for font increase
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        fontScaler.offset = min(fontScaler.offset + 1, 5)
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

