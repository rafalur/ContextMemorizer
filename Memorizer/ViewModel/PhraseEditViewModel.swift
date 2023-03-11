//
//  PhraseEditViewModel.swift
//  Memorizer

import Foundation

class PhraseEditViewModel: ObservableObject {
    var onSaved: ((Phrase) -> Void)?

    private let phrasesRepo: PhrasesRepository

    enum PhraseEditError: Error {
        case textEmpty
    }

    @Published var text: String = "" {
        didSet {
            if !text.isEmpty {
                saveError = nil
            }
        }
    }

    @Published var saveError: PhraseEditError?
    @Published var addedContexts: [Context] = []

    init(onSaved: ((Phrase) -> Void)? = nil, phrasesRepo: PhrasesRepository) {
        self.onSaved = onSaved
        self.phrasesRepo = phrasesRepo
    }

    func save() {
        guard !text.isEmpty else {
            saveError = .textEmpty
            return
        }
        onSaved?(.init(text: text, contexts: addedContexts, familiarity: 0))
        reset()
    }

    func add(context: Context) {
        if !context.sentence.isEmpty {
            addedContexts.append(context)
        }
    }

    func reset() {
        addedContexts = []
        saveError = nil
        text = ""
    }
}
