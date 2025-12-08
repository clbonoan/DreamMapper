//
//  DreamListController.swift
//  DreamMapper
//
//  Created by Christine Bonoan on 12/6/25.
//  NOTE: THIS IS NOT BEING USED ANYMORE BECAUSE WE WANT LIFE UPDATE FETCHING

import SwiftUI
import SwiftData
import Combine

@MainActor
final class DreamListController: ObservableObject {
    @Published private(set) var dreams: [Dream] = []
    
    private var modelContext: ModelContext?
    
    // attach SwiftData context from the view
    func attachContext(_ context: ModelContext) {
        // only set once
        guard modelContext == nil else { return }
        modelContext = context
        loadDreams()
    }
    
    func loadDreams() {
        guard let modelContext else { return }
        
        let descriptor = FetchDescriptor<Dream>(
            sortBy: [SortDescriptor(\Dream.createdAt, order: .reverse)]
        )
        
        dreams = (try? modelContext.fetch(descriptor)) ?? []
    }
    
    // let user delete their dream (default is swiping left on item)
    func delete(at offsets: IndexSet) {
        guard let modelContext else { return }
        
        for index in offsets {
            let dream = dreams[index]
            modelContext.delete(dream)
        }
        
        try? modelContext.save()
        dreams.remove(atOffsets: offsets)
    }
}
