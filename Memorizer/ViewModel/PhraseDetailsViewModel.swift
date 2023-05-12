//
//  PhraseDetailsViewModel.swift
//  Memorizer

import Foundation

import Combine
import CombineExt
import Foundation

struct ContextItem: Identifiable {
    let id: UUID
    let contextText: String
    let score: UInt
}

class PhraseDetailsViewModel: ObservableObject {
    private let phrasesRepo: PhrasesRepository
    private let scoresProvider: ScoresProvider

    @Published var phraseText: String
    @Published var contextItems = [ContextItem]()
    
    @Published var phrase: Phrase
    
    init(phrase: Phrase, phrasesRepo: PhrasesRepository, scoresProvider: ScoresProvider) {
        self.phraseText = phrase.text
        self.phrasesRepo = phrasesRepo
        self.scoresProvider = scoresProvider
        self.phrase = phrase

        setupBindings(initalPhrase: phrase)
    }
    
    private func setupBindings(initalPhrase: Phrase) {
        let phraseUpdated = phrasesRepo.phrasesPublisher
            .compactMap { phrases in
                phrases.first { $0.id == initalPhrase.id }
            }
        
        let phrasePublisher = Just(initalPhrase)
            .eraseToAnyPublisher()
            .merge(with: phraseUpdated)
        
        phrasePublisher.assign(to: &$phrase)
    
        phrasePublisher.map{ $0.text }
            .assign(to: &$phraseText)
        
        phrasePublisher.map{ [weak self] phrase in
            phrase.contexts.compactMap { self?.contextItem(fromContext: $0) }
        }
            .assign(to: &$contextItems)
    }
    
    func contextItem(fromContext context: Context) -> ContextItem {
        let score = scoresProvider.scoreForContext(withId: context.id) ?? 0
        return .init(id: context.id, contextText: context.sentence, score: score)
    }
}
