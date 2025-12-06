//
//  AboutDreamiView.swift
//  DreamMapper
//
//  Created by Christine Bonoan on 12/6/25.
//  This contains the info for the "learn more" button in SettingsView.

import SwiftUI

struct AboutDreamiView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("What is Dreamí?")
                        .font(.custom("AlegreyaSans-Bold", size: 26))
                        .padding()
                        .padding(.bottom, -40)
                    Text(
                        """
                        Dreamí is your personal companion for your dream life. It helps you capture what happened in your dreams, then uses AI to summarize them, highlight symbols (we call them motifs), and reflect the overall emotional tone.
                        """
                    )
                        .font(.custom("AlegreyaSans-Regular", size: 18))
                        .padding()
                    
                    Divider()
                    
                    Text("How it works")
                        .font(.custom("AlegreyaSans-Bold", size: 22))
                        .padding()
                        .padding(.bottom, -40)
                    
                    Text(
                        """
                        - Write a title and description of your dream
                        - Dreamí sends your text to a local AI model (via Ollama) for analysis
                        - The app generates a summary, extracts motifs, provides further insight, and gives an overall sentiment
                        - Your analyzed dream is saved so you can revisit it in the list, details, and map views
                        """
                    )
                        .font(.custom("AlegreyaSans-Regular", size: 18))
                        .padding()
                    
                    Divider()
                    
                    Text("What gets stored")
                        .font(.custom("AlegreyaSans-Bold", size: 22))
                        .padding()
                        .padding(.bottom, -40)
                    
                    Text(
                        """
                        Dreamí saves:
                        - your original dream text
                        - the AI-generated summary
                        - extracted motifs and their meanings
                        - a personal interpretation
                        - "what to do next" suggestions
                        - a sentiment label
                        """
                    )
                        .font(.custom("AlegreyaSans-Regular", size: 18))
                        .padding()
                    
                    Divider()
                    
                    Text("Privacy and data")
                        .font(.custom("AlegreyaSans-Bold", size: 22))
                        .padding()
                        .padding(.bottom, -40)
                    
                    Text(
                        """
                        Your dreams are stored locally using SwiftData on your device. You can delete everything at any time from the Settings page using "Delete All Dreams & Analysis."
                        """
                    )
                        .font(.custom("AlegreyaSans-Regular", size: 18))
                        .padding()
                }
                .padding(10)
            }
            .background(Color(hex: "#EFEFE8"))
            .navigationTitle("About Dreamí")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .background(Color(hex: "#EFEFE8"))
    }
}

#Preview {
    AboutDreamiView()
}

