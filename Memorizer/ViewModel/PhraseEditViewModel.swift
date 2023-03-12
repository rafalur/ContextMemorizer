//
//  PhraseEditViewModel.swift
//  Memorizer

import Combine
import Foundation
import CombineExt

class PhraseEditViewModel: ObservableObject {
    private let phrasesRepo: PhrasesRepository

    enum PhraseEditError: Error {
        case textEmpty
    }

    // Input

    let save = PassthroughSubject<Void, Never>()

    @Published var text: String = ""
    @Published var addedContexts: [Context] = []

    // Output
    @Published var saveError: PhraseEditError?
    @Published var done: Bool = false

    private var phraseToEdit: Phrase?
    private var cancellables = [AnyCancellable]()

    init(phraseToEdit: Phrase? = nil, phrasesRepo: PhrasesRepository) {
        self.phraseToEdit = phraseToEdit
        self.phrasesRepo = phrasesRepo
        
        if let phraseToEdit = phraseToEdit {
            text = phraseToEdit.text
            addedContexts = phraseToEdit.contexts
        }
        
        let phraseToSave = Publishers.CombineLatest($text, $addedContexts)
            .filter { !$0.0.isEmpty }
            .map { Phrase(text: $0.0, contexts: $0.1, familiarity: 0) }
        
        
        let isTextValid = $text.map{ !$0.isEmpty }

        save.withLatestFrom(isTextValid)
            .filter{ !$0 }
            .map { _ in PhraseEditError.textEmpty }
            .assign(to: &$saveError)
        
        save.withLatestFrom(phraseToSave)
            .sink { [weak self] in
                self?.addOrUpdate(phrase: $0)
            }
            .store(in: &cancellables)
    }
    
    private func addOrUpdate(phrase: Phrase) {
        if let phraseToEdit = phraseToEdit {
            let newPhrase = Phrase(id: phraseToEdit.id, text: phrase.text, contexts: phrase.contexts, familiarity: phraseToEdit.familiarity)
            phrasesRepo.update(phrase: newPhrase)
        } else {
            phrasesRepo.add(phrase: phrase)
        }
        done = true
    }
    

    func add(context: Context) {
        if !context.sentence.isEmpty {
            addedContexts.append(context)
        }
    }
}
