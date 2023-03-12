//
//  MockedPhrasesRepository.swift
//  Memorizer

import Foundation
import Combine

class MockedPhrasesRepo: PhrasesRepository {
    @Published var phrases: [Phrase]
    
    var phrasesPublisher: AnyPublisher<[Phrase], Never> {
        $phrases.eraseToAnyPublisher()
    }
    
    init(initialPhrases: [Phrase] = testPhrases) {
        phrases = initialPhrases
    }
    
    func load() {
        
    }

    func add(phrase: Phrase) {
        phrases.append(phrase)
    }
    
    func update(phrase: Phrase) {
        if let index = phrases.firstIndex(where: { $0.id == phrase.id }) {
            phrases.remove(at: index)
            phrases.append(phrase)
        }
    }
}
