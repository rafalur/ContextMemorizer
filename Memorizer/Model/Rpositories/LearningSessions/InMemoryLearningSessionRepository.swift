//
//  InMemoryLearningSessionRepository.swift
//  Memorizer
//
//  Created by Rafal Urbaniak on 12/05/2023.
//

import Foundation
import Combine

class InMemoryLearningSessionRepository: LearningSessionsRepository {
    @Published var sessions: [LearningSession] = [LearningSession]()
    
    var sessionsPublisher: AnyPublisher<[LearningSession], Never> {
        $sessions.eraseToAnyPublisher()
    }
    

    func add(session: LearningSession) -> AnyPublisher<Void, Error> {
        
        print("add session: \(session)")
        sessions.append(session)

        return Just(())
            .delay(for: 1, scheduler: RunLoop.main)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        
    }

}
