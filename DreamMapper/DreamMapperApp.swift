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
            Motif.self
        ])
        let isPreview = ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"

        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: isPreview)

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
