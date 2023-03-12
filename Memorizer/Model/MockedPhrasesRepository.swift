//
//  MockedPhrasesRepository.swift
//  Memorizer

import Foundation
import Combine

struct DummyError: Error {}

class MockedPhrasesRepo: PhrasesRepository {
    @Published var phrases: [Phrase]
    
    var phrasesPublisher: AnyPublisher<[Phrase], Never> {
        $phrases.eraseToAnyPublisher()
    }
    
    init(initialPhrases: [Phrase] = testPhrases) {
        phrases = initialPhrases
    }

    func add(phrase: Phrase) -> AnyPublisher<Void, Error> {
        phrases.append(phrase)

        return Just(())
            .delay(for: 1, scheduler: RunLoop.main)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()    }
    
    func update(phrase: Phrase) -> AnyPublisher<Void, Error> {
        if let index = phrases.firstIndex(where: { $0.id == phrase.id }) {
            phrases.remove(at: index)
            phrases.append(phrase)
            
            return Just(())
                .delay(for: 1, scheduler: RunLoop.main)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        
        return Fail(error: DummyError()).eraseToAnyPublisher()
    }
}
