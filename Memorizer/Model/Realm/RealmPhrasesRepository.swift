//
//  RealmPhrasesRepository.swift
//  Memorizer
//
//  Created by Rafal Urbaniak on 16/04/2023.
//

import Foundation
import RealmSwift
import Combine
import CombineExt

class RealmPhrasesRepository: PhrasesRepository {
    @Published var phrases: [Phrase]
    
    let realm = try! Realm()
    var token: NotificationToken? = nil
    
    let phrasesResults: Results<PhraseObject>
    
    var phrasesPublisher: AnyPublisher<[Phrase], Never> {
        $phrases.eraseToAnyPublisher()
    }
    
    init() {
        phrasesResults = realm.objects(PhraseObject.self)
        phrases = phrasesResults.map { $0.toPhrase() }
        token = phrasesResults.observe { [weak self] _ in
            self?.handlePhrasesUpdated()
        }
    }

    func add(phrase: Phrase) -> AnyPublisher<Void, Error> {
        return save(phrase: phrase, wasExisting: false)
    }
    
    func update(phrase: Phrase) -> AnyPublisher<Void, Error> {
        return save(phrase: phrase, wasExisting: true)
    }
    
    private func save(phrase: Phrase, wasExisting: Bool) -> AnyPublisher<Void, Error> {
        do {
            let phraseToWrite = PhraseObject(phrase: phrase)

            try realm.write {
                realm.add(phraseToWrite, update: wasExisting ? .modified : .error)
            }
        
            return Just(())
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: error)
                .eraseToAnyPublisher()
        }
    }
    
    private func handlePhrasesUpdated() {
        phrases = phrasesResults.map { $0.toPhrase() }
    }
}

