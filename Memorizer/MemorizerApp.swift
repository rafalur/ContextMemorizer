//
//  MemorizerApp.swift
//  Memorizer

import SwiftUI

class Coordinator: ObservableObject {
    @Published var path = NavigationPath()
}

@main
struct MemorizerApp: App {
    let dependencies: Dependencies = .mock
    
    @StateObject var coordinator = Coordinator()

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $coordinator.path) {
                DeckView(dependencies: dependencies)
                    .environmentObject(dependencies)
                    .environmentObject(coordinator)
                    .navigationDestination(for: NavigationDestinations.self) { value in
                        switch value {
                            case .phraseDetails(let phrase):
                                PhraseView(dependencies: dependencies, phrase: phrase)
                                    .environmentObject(dependencies)
                                    .environmentObject(coordinator)
                            case .phraseEdit(let phrase):
                                PhraseEditView(dependencies: dependencies, phraseToEdit: phrase)
                                    .environmentObject(dependencies)
                                    .environmentObject(coordinator)
                            case .learn:
                            LessonView(dependencies: dependencies)
                        }
                    }
            }
            .environmentObject(coordinator)
        }
    }
}
