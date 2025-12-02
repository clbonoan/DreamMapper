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
    
    // variables for typing title, dream, and focusing cursor in text box
    @State private var dreamTitle = ""
    @State private var dreamText = ""
    @FocusState private var isTextFocused: Bool
    
    // action button for submitting text
    @State private var isSubmitted = false
    
    // test Ollama button
    @State private var pingOutput: String = ""
    private let ollama = OllamaClient()
    
    //
    @State private var isAnalyzing = false
    @State private var analysisPreview: String = ""
    
    private let minChars = 8
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "#F4F3EE")
                    .ignoresSafeArea()
                VStack {
                    ClockView()
                        .padding(.top, 20)
                        .padding(.bottom, 50)
                    
                    
                    VStack(spacing: 15) {
                        Text("share what happened in your dream\nand find out what it means")
                            .font(.custom("AlegreyaSans-Medium", size: 22))
                            .multilineTextAlignment(.center)
                        
                        // text field for dream title
                        ZStack(alignment: .topLeading) {
                            TextField("Title", text: $dreamTitle)
                                .font(.custom("AlegreyaSans-Regular", size: 20))
                                .textInputAutocapitalization(.words)
                                .disableAutocorrection(true)
                                .padding(12)
                                .frame(height: 40)
                                //.gesture(DragGesture())
                                .background(Color(hex: "#E8EFE8"), in: RoundedRectangle(cornerRadius: 15))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(Color.black.opacity(0.4), lineWidth: 1)
                                )
                        }
                        
                        // text editor for dream input
                        ZStack(alignment: .topLeading) {
                            TextEditor(text: $dreamText)
                                .font(.custom("AlegreyaSans-Regular", size: 18))
                                .focused($isTextFocused)
                                .padding(12)
                                .frame(height: 300)
                                .scrollIndicators(.visible) // allow user to drag to see entire entry
                                .gesture(DragGesture())
                                .background(Color(hex: "#E8EFE8"), in: RoundedRectangle(cornerRadius: 15))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(Color.black.opacity(0.4), lineWidth: 1)
                                )
                                .scrollContentBackground(.hidden)
                            
                            if dreamText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                Text("type your dream here...")
                                    .foregroundColor(.secondary)
                                    .padding(.horizontal, 15)
                                    .padding(.vertical, 20)
                            }
                        }
                        
                        // placeholder button for sending dream
                        Button {
                            // saveDream()
                            // hide keyboard
                            isTextFocused = false
                            
                            // validation dream entry
                            let text = dreamText.trimmingCharacters(in: .whitespacesAndNewlines)
                            let title = dreamTitle.trimmingCharacters(in: .whitespacesAndNewlines)
                            guard text.count >= 8 else { return }
                            
                            // load analysis preview
                            isAnalyzing = true
                            analysisPreview = ""
                            
                            // call ollama
                            Task {
                                do {
                                    let out = try await ollama.generateAnalysis(text: text, title: title)
                                    // show preview on screen to see if it worked
                                    analysisPreview = """
                                    Summary: \(out.summary)
                                    Motifs: \(out.motifs.map { "- \($0.symbol): \($0.meaning)" }.joined(separator: "\n"))
                                    """
                                } catch {
                                    analysisPreview = "Analysis failed: \(error.localizedDescription)"
                                }
                                isAnalyzing = false
//                                    let raw = try await ollama.debugGenerateRaw(text: text, title: dreamTitle)
//                                    analysisPreview = "RAW:\n\(raw)"
//                                } catch {
//                                    analysisPreview = "Analysis failed: \(error.localizedDescription)"
//                                }
//                                isAnalyzing = false
                            }
                        } label: {
                            if isAnalyzing {
                                ProgressView()
                                    .padding(.vertical, 12)
                                    .padding(.horizontal, 20)
                            } else {
                                Label("Analyze Dream", systemImage: "wand.and.stars")
                                    .font(.custom("AlegreyaSans-Regular", size: 14))
                                    .padding(.vertical, 12)
                                    .padding(.horizontal, 20)
                            }
                        }
                        .background(Color(hex: "#B6CFB6"), in: Capsule())
                        .foregroundColor(.black)
                        .padding(.top, 6)
                        .disabled(isAnalyzing || dreamText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                        
                        // show summary preview
                        if !analysisPreview.isEmpty {
                            Text(analysisPreview)
                                .font(.footnote)
                                .foregroundColor(.black)
                                .multilineTextAlignment(.leading)
                                .padding(.top, 6)
                        }
                        
                        Button("Test Ollama Connection") {
                            Task {
                                do {
                                    let models = try await ollama.pingModels()
                                    pingOutput = "Ollama is reachable\nModels: \(models.joined(separator: ", "))"
                                } catch {
                                    pingOutput = "Could not reach Ollama \n\(error.localizedDescription)"
                                }
                            }
                        }
                        .font(.custom("AlegreyaSans-Regular", size: 14))
                        .padding(.vertical, 10)
                        .padding(.horizontal, 16)
                        .background(Color.black.opacity(0.08), in: Capsule())
                        .foregroundColor(.black)
                        .padding(.top, 6)
                        
                        if !pingOutput.isEmpty {
                            Text(pingOutput)
                                .font(.footnote)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .padding(.top, 4)
                        }


                    }
                    Spacer()
                }
                .padding(.horizontal, 24)
            }
        }
    }
    
    // function to save user's dream
//    private func saveDream() {
//        
//    }
    
}

// separate view to manage the live updating clock
struct ClockView: View {
    // timelineView updates every second
    var body: some View {
        TimelineView(.periodic(from: .now, by: 1)) { context in
            Text(context.date, format: .dateTime.weekday(.abbreviated).month(.abbreviated).day().hour().minute().second())
                .font(.custom("AlegreyaSans-Thin", size: 20))
                .foregroundColor(.black)
                .padding(10)
                .background(Color(hex: "#B6CFB6"))
                .cornerRadius(10)
                // use monospaced digits to prevent UI issues when the time changes
                .monospacedDigit()
        }
    }
}

#Preview {
    DreamPromptView()
        .modelContainer(for: Item.self, inMemory: true)
}
