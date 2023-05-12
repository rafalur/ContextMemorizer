//
//  Dependencies.swift
//  Memorizer

import Foundation


class Dependencies: ObservableObject {
    let phrasesRepo: PhrasesRepository
    let sessionsRepo: LearningSessionsRepository


    init(phrasesRepo: PhrasesRepository, sessionsRepo: LearningSessionsRepository) {
        self.phrasesRepo = phrasesRepo
        self.sessionsRepo = sessionsRepo
    }

    static var mock: Dependencies {
        .init(phrasesRepo: MockedPhrasesRepo(), sessionsRepo: InMemoryLearningSessionRepository())
    }
    
    static var prod: Dependencies {
        .init(phrasesRepo: RealmPhrasesRepository(), sessionsRepo: InMemoryLearningSessionRepository())
    }
}


