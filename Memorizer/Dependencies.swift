//
//  Dependencies.swift
//  Memorizer

import Foundation

class Dependencies: ObservableObject {
    let phrasesRepo: PhrasesRepository

    init(phrasesRepo: PhrasesRepository) {
        self.phrasesRepo = phrasesRepo
    }

    static var mock: Dependencies {
        .init(phrasesRepo: MockedPhrasesRepo())
    }
}

struct MockedPhrasesRepo: PhrasesRepository {
    private let phrases: [Phrase]

    init(initialPhrases: [Phrase] = testPhrases) {
        phrases = initialPhrases
    }

    func allPhrases(_ completion: @escaping (Result<[Phrase], Error>) -> Void) {
        completion(.success(phrases))
    }
}
