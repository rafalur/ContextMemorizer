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
}
