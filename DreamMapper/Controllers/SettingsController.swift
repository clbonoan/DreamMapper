//
//  SettingsController.swift
//  DreamMapper
//
//  Created by Christine Bonoan on 12/6/25.
//

import SwiftUI
import SwiftData
import Combine

@MainActor
final class SettingsController: ObservableObject {
    // deletion/progress state
    @Published var isDeleting: Bool = false
    
    // confirmation alert (before deleting)
    @Published var showConfirmed: Bool = false
    
    // result alert (after attempt to delete)
    @Published var showResultAlert: Bool = false
    @Published var resultTitle: String = ""
    @Published var resultMessage: String = ""
    
    // learn more sheet state
    @Published var showAboutInfo: Bool = false
    
    private var modelContext: ModelContext?
    
    func attachContext(_ context: ModelContext) {
        modelContext = context
    }
    
    // call when user taps the "delete all data" button
    func requestDeleteAllData() {
        showConfirmed = true
    }
    
    // actually delete all dreams
    func deleteAllData() {
        guard let modelContext else {
            resultTitle = "Error"
            resultMessage = "Could not access data."
            showResultAlert = true
            return
        }
        
        isDeleting = true
        
        Task {
            do {
                // fetch all dream objects
                let dreamDescriptor = FetchDescriptor<Dream>()
                let allDreams = try modelContext.fetch(dreamDescriptor)
                
                for dream in allDreams {
                    modelContext.delete(dream)
                }
                
                // save changes
                try modelContext.save()
                
                // deletion worked
                await MainActor.run {
                    isDeleting = false
                    resultTitle = "Data Deleted"
                    resultMessage = "All dreams and their analyses have been deleted"
                    showResultAlert = true
                }
            } catch {
                // deletion didn't work
                await MainActor.run {
                    isDeleting = false
                    resultTitle = "Error"
                    resultMessage = "Failed tp delete data: \(error.localizedDescription)"
                    showResultAlert = true
                }
            }
        }
    }
    
    // learn more
    func showAbout() {
        showAboutInfo = true
    }
}
