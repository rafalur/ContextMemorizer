//
//  Dependencies.swift
//  Memorizer

import Foundation


class Dependencies: ObservableObject {
    let phrasesRepo: PhrasesRepository
    let sessionsRepo: LearningSessionsRepository
    let scoresProvider: ScoresProvider

    init(phrasesRepo: PhrasesRepository, sessionsRepo: LearningSessionsRepository, scoresProvider: ScoresProvider) {
        self.phrasesRepo = phrasesRepo
        self.sessionsRepo = sessionsRepo
        self.scoresProvider = scoresProvider
    }

    static let mock: Dependencies = {
        let phrasesRepository = MockedPhrasesRepo()
        let sessionsRepository = InMemoryLearningSessionRepository()
        let scoresProvider = SessionsBasedScoresProvider(sessionsRepo: sessionsRepository)
        return .init(phrasesRepo: phrasesRepository,
                     sessionsRepo: sessionsRepository,
                     scoresProvider: scoresProvider)
    }()
    
    static let prod: Dependencies = {
        let phrasesRepository = RealmPhrasesRepository()
        let sessionsRepository = InMemoryLearningSessionRepository()
        let scoresProvider = SessionsBasedScoresProvider(sessionsRepo: sessionsRepository)
        return .init(phrasesRepo: phrasesRepository,
                     sessionsRepo: sessionsRepository,
                     scoresProvider: scoresProvider)
    }()
}


