//
//  LessonViewModel.swift
//  Memorizer
//
//  Created by Rafal Urbaniak on 02/05/2023.
//

import Foundation

import Combine
import CombineExt
import Foundation



class LessonViewModel: ObservableObject {
    private let phrasesRepo: PhrasesRepository

    // Input
    let scoreCurrentSentence = PassthroughSubject<UInt8, Never>()
    
    @Published var context: Context?
    
    private var contexts: [Context] = []
    private var cancellables = [AnyCancellable]()

    init(phrasesRepo: PhrasesRepository) {
        self.phrasesRepo = phrasesRepo
        
        phrasesRepo.phrasesPublisher.first()
            .sink { [weak self] phrases in
                let allContexts = phrases.flatMap{ phrase in phrase.contexts }
                self?.contexts = allContexts
                self?.context = allContexts.first
            }
            .store(in: &cancellables)
        
        setupBindings()
    }
    
    private func setupBindings() {
        scoreCurrentSentence.sink{ [weak self] _ in
            guard let self = self else { return }
            let indexOfCurrentContext = self.contexts.firstIndex { $0.id == self.context?.id }
            guard let indexOfCurrentContext = indexOfCurrentContext else { return }
            guard indexOfCurrentContext < self.contexts.count - 1 else { return }
            self.context = self.contexts[indexOfCurrentContext + 1]
            
        }
        .store(in: &cancellables)
    }
}
