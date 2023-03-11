//
//  DeckViewModel.swift
//  Memorizer

import Combine
import Foundation

class DeckViewModel: ObservableObject {
    enum Sorting {
        case familiarityAscending
        case familiarityDescending

        mutating func toggle() {
            self = self == .familiarityAscending ? .familiarityDescending : .familiarityAscending
        }
    }

    // Input
    let toggleSort = PassthroughSubject<Void, Never>()

    // Output
    @Published var phrases: [Phrase] = []
    @Published var sortingType: Sorting = .familiarityAscending // not used yet

    private let phrasesRepo: PhrasesRepository
    private var cancellables = [AnyCancellable]()

    init(phrasesRepo: PhrasesRepository) {
        self.phrasesRepo = phrasesRepo
        
        toggleSort.sink { [weak self] in
            self?.sortingType.toggle()
        }
        .store(in: &cancellables)

        $sortingType
            .combineLatest(phrasesRepo.phrasesPublisher)
            .map { $0.1.sortByFamiliarity(ascending: $0.0 == .familiarityAscending)}
            .removeDuplicates()
            .assign(to: &$phrases)
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
