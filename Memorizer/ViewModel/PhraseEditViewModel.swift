//
//  PhraseEditViewModel.swift
//  Memorizer

import Combine
import CombineExt
import Foundation

class PhraseEditViewModel: ObservableObject {
    private let phrasesRepo: PhrasesRepository

    enum PhraseEditError: Error {
        case textEmpty
        case saveFailed
    }

    // Input
    let save = PassthroughSubject<Void, Never>()

    @Published var text: String = ""
    @Published var addedContexts: [Context] = []

    // Output
    @Published var saveErrorDescription: String? // To be handled
    @Published var textValid: Bool = true
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

        let isTextValid = $text.map { !$0.isEmpty }
        
        let clearEmptyTextError = isTextValid.filter { $0 }

        save.withLatestFrom(isTextValid)
            .merge(with: clearEmptyTextError)
            .assign(to: &$textValid)

        let saveResult = save.withLatestFrom(phraseToSave)
            .flatMap { [weak self] phrase in
                let publisher  = self?.addOrUpdate(phrase: phrase) ?? Empty<Void,Error>(completeImmediately: true).eraseToAnyPublisher()
                return publisher
                    .map { _ in
                        Result<Void, Error>.success(())
                    }
                    .catch { error in
                        Just(Result<Void, Error>.failure(error))
                    }
            }
            .share()

        saveResult
            .compactMap { try? $0.get() }
            .map{ _ in true }
            .assign(to: &$done)

        saveResult
            .compactMap { $0.getError()?.localizedDescription }
            .assign(to: &$saveErrorDescription)

    }

    private func addOrUpdate(phrase: Phrase) -> AnyPublisher<Void, Error> {
        if let phraseToEdit = phraseToEdit {
            let newPhrase = Phrase(id: phraseToEdit.id, text: phrase.text, contexts: phrase.contexts, familiarity: phraseToEdit.familiarity)
            return phrasesRepo.update(phrase: newPhrase)
        }
        return phrasesRepo.add(phrase: phrase)
    }


    func add(context: Context) {
        if !context.sentence.isEmpty {
            addedContexts.append(context)
        }
    }
}

extension Result {
    func getError() -> Error? {
        if case let .failure(error) = self {
            return error
        }
        return nil
    }
}
