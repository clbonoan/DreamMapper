//
//  DreamMapperApp.swift
//  DreamMapper
//
//  Created by Christine Bonoan on 11/13/25.
//

import SwiftUI
import SwiftData

@main
struct DreamMapperApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Dream.self,
            Motif.self,
            NextAction.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            HomeView()
        }
        .modelContainer(sharedModelContainer)
    }
}
