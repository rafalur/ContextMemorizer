//
//  DeckViewModel.swift
//  Memorizer

import Foundation
import Combine

class DeckViewModel: ObservableObject {
    enum Sorting {
        case familiarityAscending
        case familiarityDescending

        mutating func toggle() {
            self = self == .familiarityAscending ? .familiarityDescending : .familiarityAscending
        }
    }

    private let phrasesRepo: PhrasesRepository
    
    private var cancellables = [AnyCancellable]()

    @Published var phrases: [Phrase] = []

    var sortingType: Sorting = .familiarityAscending
        

    init(phrasesRepo: PhrasesRepository) {
        self.phrasesRepo = phrasesRepo
        
        phrasesRepo.phrasesPublisher
            .map { [sortingType] in $0.sortByFamiliarity(ascending: sortingType == .familiarityAscending) }
            .assign(to: \.phrases, on: self)
        .store(in: &cancellables)
    }

    func sort() {
        sortingType.toggle()
    }

    func add(phrase: Phrase) {
        phrases.append(phrase)
    }
}

fileprivate extension Array where Element == Phrase {
    func sortByFamiliarity(ascending: Bool) -> [Phrase] {
        if ascending {
            return sorted { $0.familiarity > $1.familiarity }
        }
        return sorted { $0.familiarity < $1.familiarity }
    }
}
