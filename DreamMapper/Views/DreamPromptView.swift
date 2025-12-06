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
    
    @StateObject private var controller = DreamPromptController()
    
    // variable for focusing cursor in text box
    @FocusState private var isTextFocused: Bool
    
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
                            TextField("Title", text: $controller.dreamTitle)
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
                            TextEditor(text: $controller.dreamText)
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
                            
                            if controller.dreamText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                Text("type your dream here...")
                                    .foregroundColor(.secondary)
                                    .padding(.horizontal, 15)
                                    .padding(.vertical, 20)
                            }
                        }
                        
                        // analyze button for sending dream
                        Button {
                            // hide keyboard
                            isTextFocused = false
                            controller.analyzeDream()
                        } label: {
                            if controller.isAnalyzing {
                                // show rotating wheel when analyzing is in progress
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
                        .disabled(!controller.canAnalyze)
                        
                        // show summary preview
                        if !controller.analysisPreview.isEmpty {
                            Text(controller.analysisPreview)
                                .font(.footnote)
                                .foregroundColor(.black)
                                .multilineTextAlignment(.leading)
                                .padding(.top, 6)
                        }
                        
                        // test ollama button
                        Button("Test Ollama Connection") {
                            controller.testOllamaConnection()
                        }
                        .font(.custom("AlegreyaSans-Regular", size: 14))
                        .padding(.vertical, 10)
                        .padding(.horizontal, 16)
                        .background(Color.black.opacity(0.08), in: Capsule())
                        .foregroundColor(.black)
                        .padding(.top, 6)
                        
                        if !controller.pingOutput.isEmpty {
                            Text(controller.pingOutput)
                                .font(.footnote)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .padding(.top, 4)
                        }
                    }
                    Spacer()
                }
                .padding(.horizontal, 24)
                .alert(controller.alertTitle, isPresented: $controller.showAlert) {
                    Button("ok", role: .cancel) {}
                } message: {
                    Text(controller.alertMessage)
                }
            }
        }
        .onAppear {
            controller.attachContext(modelContext)
        }
        .onChange(of: controller.shouldRefocusEditor) {
            if controller.shouldRefocusEditor {
                isTextFocused = true
                controller.shouldRefocusEditor = false
            }
        }
    }
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
        .modelContainer(for: Dream.self, inMemory: true)
}
