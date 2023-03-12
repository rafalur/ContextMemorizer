//
//  PhraseDetailsViewModel.swift
//  Memorizer

import Foundation

import Combine
import CombineExt
import Foundation

class PhraseDetailsViewModel: ObservableObject {
    private let phrasesRepo: PhrasesRepository

    @Published var phrase: Phrase

    init(phrase: Phrase, phrasesRepo: PhrasesRepository) {
        self.phrase = phrase
        self.phrasesRepo = phrasesRepo

        phrasesRepo.phrasesPublisher
            .compactMap { phrases in
                phrases.first { $0.id == phrase.id }
            }
            .assign(to: &$phrase)
    }
}
