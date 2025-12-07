//
//  Dream.swift
//  DreamMapper
//
//  Created by Christine Bonoan on 11/14/25.
//

import Foundation
import SwiftData

@Model
final class Dream {
    var createdAt: Date
    var title: String
    var text: String
    
    // analysis fields from Ollama
    var summary: String
    var sentiment: String
    var personalInterpretation: String
    var whatToDoNext: [String]
    var moonPhase: String?
    
    // relationship: one dream has many motifs
    @Relationship(deleteRule: .cascade)
    var motifs: [Motif]
    
    init(
        title: String,
        text: String,
        summary: String,
        sentiment: String,
        personalInterpretation: String,
        whatToDoNext: [String],
        motifs: [Motif] = [],
        moonPhase: String? = nil,
    ) {
        self.createdAt = Date()
        self.title = title
        self.text = text
        self.summary = summary
        self.sentiment = sentiment
        self.personalInterpretation = personalInterpretation
        self.whatToDoNext = whatToDoNext
        self.motifs = motifs
        self.moonPhase = moonPhase
    }
}

