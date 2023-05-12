//
//  SessionsBasedScoresProvider.swift
//  Memorizer
//
//  Created by Rafal Urbaniak on 12/05/2023.
//

import Foundation

class SessionsBasedScoresProvider: ScoresProvider {
    private let sessionsRepo: LearningSessionsRepository
    
    init(sessionsRepo: LearningSessionsRepository) {
        self.sessionsRepo = sessionsRepo
    }
    
    func scoreForContext(withId id: UUID) -> UInt? {
        let scores = sessionsRepo.allSessions.flatMap { session in
            session.contextRevisions.filter { $0.contextId == id }
        }
        .map { $0.score }
        
        guard scores.count > 0 else { return nil }
        
        let sumArray = scores.reduce(0, +)

        let average = sumArray / UInt(scores.count)
        
        return average
    }
}
