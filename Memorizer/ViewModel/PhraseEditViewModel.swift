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
    let removeContext = PassthroughSubject<Context, Never>()
    let addContext = PassthroughSubject<Context, Never>()

    @Published var text: String = ""
    @Published var addedContexts: [Context] = []

    // Output
    @Published var saveErrorDescription: String? // To be handled
    @Published var textValid: Bool = true
    @Published var done: Bool = false
    @Published var savingInProgress: Bool = false
    @Published var saveAllowed: Bool = false


    private var phraseToEdit: Phrase?
    private var cancellables = [AnyCancellable]()

    init(phraseToEdit: Phrase? = nil, phrasesRepo: PhrasesRepository) {
        self.phraseToEdit = phraseToEdit
        self.phrasesRepo = phrasesRepo

        if let phraseToEdit = phraseToEdit {
            text = phraseToEdit.text
            addedContexts = phraseToEdit.contexts
        }
        
        setupBindings()
    }
    
    private func setupBindings() {
        // Add/Remove contexts
        removeContext.sink { [weak self] context in
            self?.remove(context: context)
        }.store(in: &cancellables)

        addContext.sink { [weak self] context in
            self?.add(context: context)
        }.store(in: &cancellables)
        
        // Phrase saving
        let phraseToSave = Publishers.CombineLatest($text, $addedContexts)
            .map { components -> Phrase? in
                guard !components.0.isEmpty else { return nil }
                return Phrase(text: components.0, contexts: components.1)
            }
        
        phraseToSave.map { [phraseToEdit] in
            guard let phraseToEdit = phraseToEdit else { return true }
            return !($0?.sameValue(as: phraseToEdit) ?? false)
        }
        .assign(to: &$saveAllowed)

        let isTextValid = $text.map { !$0.isEmpty }

        let clearEmptyTextError = isTextValid.filter { $0 }

        save.withLatestFrom(isTextValid)
            .merge(with: clearEmptyTextError)
            .assign(to: &$textValid)

        let phraseReadyToSave = save.withLatestFrom(phraseToSave).compactMap { $0 }

        let saveResult = phraseReadyToSave
            .flatMap { [weak self] phrase in
                // TODO: cleanup
                let publisher = self?.addOrUpdate(phrase: phrase) ?? Empty<Void, Error>(completeImmediately: true).eraseToAnyPublisher()
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
            .map { _ in true }
            .assign(to: &$done)

        saveResult
            .compactMap { $0.getError()?.localizedDescription }
            .assign(to: &$saveErrorDescription)

        // Show saving (progress) indicator
        let showSavingIndicator = phraseReadyToSave.map { _ in true }
            .merge(with: saveResult.map { _ in false })

        showSavingIndicator.assign(to: &$savingInProgress)
        
        // Disable save button in case nothing changed or saving in progress
        phraseToSave.map { [phraseToEdit] in
            guard let phraseToEdit = phraseToEdit else { return true }
            return !($0?.sameValue(as: phraseToEdit) ?? false)
        }
        .merge(with: showSavingIndicator.toggle()) // to disable button also while saving in progress
        .assign(to: &$saveAllowed)
    }

    private func addOrUpdate(phrase: Phrase) -> AnyPublisher<Void, Error> {
        if let phraseToEdit = phraseToEdit {
            let newPhrase = Phrase(id: phraseToEdit.id, text: phrase.text, contexts: phrase.contexts)
            return phrasesRepo.update(phrase: newPhrase)
        }
        return phrasesRepo.add(phrase: phrase)
    }

    private func add(context: Context) {
        if !context.sentence.isEmpty {
            addedContexts.append(context)
        }
    }
    
    private func remove(context: Context) {
        if let index = addedContexts.firstIndex(of: context) {
            addedContexts.remove(at: index)
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
