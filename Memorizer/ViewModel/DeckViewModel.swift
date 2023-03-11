//
//  DeckViewModel.swift
//  Memorizer

import Foundation

class DeckViewModel: ObservableObject {
    enum Sorting {
        case familiarityAscending
        case familiarityDescending

        mutating func toggle() {
            self = self == .familiarityAscending ? .familiarityDescending : .familiarityAscending
        }
    }

    private let phrasesRepo: PhrasesRepository

    @Published var phrases: [Phrase] = []

    var sortingType: Sorting = .familiarityAscending {
        didSet {
            sortPhrases()
        }
    }

    init(phrasesRepo: PhrasesRepository) {
        self.phrasesRepo = phrasesRepo

        fetchPhrases()
    }

    private func fetchPhrases() {
        phrasesRepo.allPhrases { [weak self] result in
            switch result {
            case let .success(phrases):
                self?.phrases = phrases
            case let .failure(error):
                print("Fetching phrases failure: \(error.localizedDescription)")
            }
        }
    }

    private func sortPhrases() {
        switch sortingType {
        case .familiarityAscending:
            phrases.sort { $0.familiarity > $1.familiarity }
        case .familiarityDescending:
            phrases.sort { $0.familiarity < $1.familiarity }
        }
    }

    func sort() {
        sortingType.toggle()
    }

    func add(phrase: Phrase) {
        phrases.append(phrase)
    }
}
