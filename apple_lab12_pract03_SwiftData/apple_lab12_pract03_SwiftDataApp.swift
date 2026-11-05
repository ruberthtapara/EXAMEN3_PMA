//
//  apple_lab12_pract03_SwiftDataApp.swift
//  apple_lab12_pract03_SwiftData
//
//  Created by Ruberth Edgardo on 5/11/26.
//

import SwiftUI
import SwiftData

@main
struct apple_lab12_pract03_SwiftDataApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Teacher.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            let storeURL = modelConfiguration.url
            try? FileManager.default.removeItem(at: storeURL)
            if let newContainer = try? ModelContainer(for: schema, configurations: [modelConfiguration]) {
                return newContainer
            }
            let memoryConfig = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
            if let memoryContainer = try? ModelContainer(for: schema, configurations: [memoryConfig]) {
                return memoryContainer
            }
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
