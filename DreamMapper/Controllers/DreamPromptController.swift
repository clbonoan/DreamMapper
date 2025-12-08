//
//  DreamPromptController.swift
//  DreamMapper
//
//  Created by Christine Bonoan on 12/6/25.
//

import SwiftUI
import SwiftData
import Combine

@MainActor
final class DreamPromptController: ObservableObject {
    // user input
    @Published var dreamTitle: String = ""
    @Published var dreamText: String = ""
    
    // analysis progress and results state
    @Published var isAnalyzing: Bool = false
    @Published var analysisPreview: String = ""
    
    // test Ollama connectivity
    @Published var pingOutput: String = ""
    
    // alerts
    @Published var showAlert: Bool = false
    @Published var alertTitle: String = ""
    @Published var alertMessage: String = ""
    
    // for view to know when to refocus the editor after a successful analysis
    @Published var shouldRefocusEditor: Bool = false
    
    private let minChars = 8
    private let ollama = OllamaClient()
    private var modelContext: ModelContext?
    private let moon = MoonClient()
    
    init() {}
    
    // attach SwiftData context from the view
    func attachContext(_ context: ModelContext) {
        modelContext = context
    }
    
    // when analyze button should be enabled
    var canAnalyze: Bool {
        let trimmed = dreamText.trimmingCharacters(in: .whitespacesAndNewlines)
        return !isAnalyzing && trimmed.count >= minChars
    }
    
    // send dream to backend and save result to SwiftData
    func analyzeDream() {
        guard canAnalyze else { return }
        guard let modelContext else { return }
        
        let text = dreamText.trimmingCharacters(in: .whitespacesAndNewlines)
        let title = dreamTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        
        isAnalyzing = true
        analysisPreview = ""
        
        Task {
            do {
                // call backend to analyze dream
                let out = try await ollama.generateAnalysis(text: text, title: title)
                let moonPhase = out.moonPhase
                // convert motifs from DTO -> SwiftData models
                let motifModels = out.motifs.map { motifDTO in
                    Motif(symbol: motifDTO.symbol, meaning: motifDTO.meaning)
                }

                // create and save Dream model locally
                let dream = Dream(
                    title: title.isEmpty ? "Untitled dream" : title,
                    text: text,
                    summary: out.summary,
                    sentiment: out.sentiment,
                    personalInterpretation: out.personalInterpretation,
                    whatToDoNext: out.whatToDoNext,
                    motifs: motifModels,
                    moonPhase: moonPhase
                )
                
                // insert into SwiftData and save
                modelContext.insert(dream)
                do {
                    try modelContext.save()
                } catch {
                    print("failed to save dream: \(error)")
                }
                
                // show preview on screen to see if it worked
                let motifsText = out.motifs.map { motif in
                    "- \(motif.symbol): \(motif.meaning)"
                }.joined(separator: "\n")
                
                // print in console to check output
                print("TITLE:", title)
                print("SUMMARY:", out.summary)
                print("MOTIFS:", out.motifs)
                print("MOON PHASE:", moonPhase)
                
                // preview on screen
                await MainActor.run {
                    analysisPreview = """
                    Summary:
                    \(out.summary)

                    Motifs:
                    \(motifsText.isEmpty ? "(none)" : motifsText)
                    """
                
                    // clear inputs after successful return
                    dreamTitle = ""
                    dreamText = ""
                    alertTitle = "Success"
                    alertMessage = "✨Your dream has been analyzed and saved✨"
                    showAlert = true
                    // move focus back to editor when done
                    shouldRefocusEditor = true
                }
            } catch {
                // handle backend or decode issues
                await MainActor.run {
                    analysisPreview = "Analysis failed: \(error.localizedDescription)"
                    alertTitle = "Error"
                    alertMessage = error.localizedDescription + "\nPlease try again."
                    showAlert = true
                }
            }
            
            // if it is clearing inputs, that means it's done analyzing
            await MainActor.run {
                isAnalyzing = false
            }
        }
    }
    
    // check if ollama is directly connected (for debugging)
    func testOllamaConnection() {
        pingOutput = ""
        Task {
            do {
                let models = try await ollama.pingModels()
                await MainActor.run {
                    pingOutput = "Ollama is reachable\nModels: \(models.joined(separator: ", "))"
                }
            } catch {
                await MainActor.run {
                    pingOutput = "Could not reach Ollama \n\(error.localizedDescription)"
                }
            }
        }
    }
}
