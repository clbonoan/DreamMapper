//
//  DreamListController.swift
//  DreamMapper
//
//  Created by Christine Bonoan on 12/6/25.
//  NOTE: THIS IS NOT BEING USED ANYMORE BECAUSE WE WANT LIFE UPDATE FETCHING WITH @Query

import SwiftUI
import SwiftData
import Combine

@MainActor
final class DreamListController: ObservableObject {
    // UI binding
    // private(set) lets views read dreams but this class can modify
    @Published private(set) var dreams: [Dream] = []
    
    private var modelContext: ModelContext?
    
    // attach SwiftData context from the view
    func attachContext(_ context: ModelContext) {
        // only set once to prevent reattaching if it is already set
        guard modelContext == nil else { return }
        modelContext = context
        // load initial dream list
        loadDreams()
    }
    
    // load all dreams from SwiftData into the dreams array
    func loadDreams() {
        guard let modelContext else { return }
        
        // fetch dreams by createdAt descending
        let descriptor = FetchDescriptor<Dream>(
            sortBy: [SortDescriptor(\Dream.createdAt, order: .reverse)]
        )
        
        dreams = (try? modelContext.fetch(descriptor)) ?? []
    }
    
    // let user delete their dream (default is swiping left on item)
    func delete(at offsets: IndexSet) {
        guard let modelContext else { return }
        
        // delete each dream
        for index in offsets {
            let dream = dreams[index]
            modelContext.delete(dream)
        }
        
        // save state to persistent data store
        try? modelContext.save()
        // update local array to sync UI
        dreams.remove(atOffsets: offsets)
    }
}
