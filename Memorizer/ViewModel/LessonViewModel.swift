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

fileprivate typealias ScoreForContextId = (UInt, UUID)

class LessonViewModel: ObservableObject {
    private let phrasesRepo: PhrasesRepository
    private let sessionsRepo: LearningSessionsRepository

    // Input
    let save = PassthroughSubject<Void, Never>()
    
    @Published var context: Context?
    @Published var currentScore: UInt = 0
    @Published var done: Bool = false

    private var contexts: [Context] = []
    private var cancellables = [AnyCancellable]()

    init(phrasesRepo: PhrasesRepository, sessionsRepo: LearningSessionsRepository) {
        self.phrasesRepo = phrasesRepo
        self.sessionsRepo = sessionsRepo
        
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
        
        let scorePublisher = $currentScore
            .removeDuplicates()
            .filter { $0 > 0 }
        
        let switchToNextContext = scorePublisher
            .delay(for: 1, scheduler: RunLoop.main)
        
        switchToNextContext
            .map { _ in 0 }
            .assign(to: &$currentScore)
        
        let allScoresPerContext = scorePublisher.withLatestFrom($context.compactMap{ $0 } ) { ($0, $1.id) }
            .scan([ScoreForContextId]()) { return $0 + [$1] }
        
        save.withLatestFrom(allScoresPerContext)
            .compactMap { [weak self] scores in self?.session(fromScoresPerId: scores) }
            .flatMap { [weak self] session in
                self?.sessionsRepo.add(session: session) ?? Empty<Void, Error>(completeImmediately: true).eraseToAnyPublisher()
            }
            .map { _ in true }
            .catch { _ in
                return Just(true)
            }
            .assign(to: &$done)

        switchToNextContext.sink{ [weak self] _ in
            guard let self = self else { return }
            let indexOfCurrentContext = self.contexts.firstIndex { $0.id == self.context?.id }
            guard let indexOfCurrentContext = indexOfCurrentContext else { return }
            guard indexOfCurrentContext < self.contexts.count - 1 else { return }
            self.context = self.contexts[indexOfCurrentContext + 1]
            
        }
        .store(in: &cancellables)
    }
    
    private func session(fromScoresPerId scores: [ScoreForContextId]) -> LearningSession {
        let revisions = scores.map { ContextRevision(contextId: $0.1, score: $0.0) }
        return .init(startDate: Date(), contextRevisions: revisions)
    }
}
