//
//  MemorizerApp.swift
//  Memorizer

import SwiftUI

@main
struct MemorizerApp: App {
    let dependencies: Dependencies = .mock

    var body: some Scene {
        WindowGroup {
            DeckView(dependencies: dependencies)
                .environmentObject(dependencies)
        }
    }
}
