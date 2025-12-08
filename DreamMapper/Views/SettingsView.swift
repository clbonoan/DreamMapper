//
//  SettingsView.swift
//  DreamMapper
//
//  Created by Christine Bonoan on 11/14/25.
//  This is the settings view with the delete all dreams functionality and more info about the app.

import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var controller = SettingsController()
    
    var body: some View {
        ZStack {
            Color(hex: "#15151b")
                .ignoresSafeArea()
            
            Form {
                // option to delete analyzed dreams
                Section {
                    Button(role: .destructive) {
                        controller.requestDeleteAllData()
                    } label: {
                        Text("Delete All Dreams & Analysis")
                            .font(.custom("AlegreyaSans-Bold", size: 20))
                            .foregroundColor(Color(hex: "#484848"))
                    }
                    .disabled(controller.isDeleting)
                }
                .listRowBackground(Color(hex: "#B6CFB6"))
                
                // about section
                Section {
                    Button {
                        controller.showAbout()
                    } label: {
                        Text("Learn More")
                            .font(.custom("AlegreyaSans-Bold", size: 20))
                            .foregroundColor(Color(hex: "#484848"))
                    }
                    
                    // static info preview
                    Text("Dreamí lets you discover your dreams and explore their meanings.")
                        .font(.custom("AlegreyaSans-Light", size: 18))
                }
                .listRowBackground(Color(hex: "#B6CFB6"))
            }
            .navigationTitle("Settings")
            .scrollContentBackground(.hidden) // hide the default Form background
            .background(Color.clear)
        }
        .onAppear {
            controller.attachContext(modelContext)
        }
        
        // first confirmation for deleting data
        .alert(
            "Are you sure?",
            isPresented: $controller.showConfirmed
        ) {
            Button("Cancel", role: .cancel) { }
            Button("Delete All", role: .destructive) {
                // actual deletion
                controller.deleteAllData()
            }
        } message: {
            Text("This permanently deletes all your dreams and their analyses. \nThis action cannot be undone.")
        }
        
        // result alert (deleted or error)
        .alert(
            controller.resultTitle,
            isPresented: $controller.showResultAlert
        ) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(controller.resultMessage)
        }
        
        // learn more sheet
        .sheet(isPresented: $controller.showAboutInfo) {
            AboutDreamiView()
        }
    }
}

#Preview {
    SettingsView()
        .modelContainer(for: [Dream.self, Motif.self], inMemory: true)
}
