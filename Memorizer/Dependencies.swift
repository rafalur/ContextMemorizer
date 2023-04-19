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
    
    static var prod: Dependencies {
        .init(phrasesRepo: RealmPhrasesRepository())
    }
}


