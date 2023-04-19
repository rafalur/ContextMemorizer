//
//  PhraseObject.swift
//  Memorizer
//
//  Created by Rafal Urbaniak on 19/04/2023.
//

import Foundation
import RealmSwift

class PhraseObject: Object {
    @Persisted(primaryKey: true) var id: UUID
    @Persisted var text: String
    @Persisted var contexts: List<ContextObject>
    @Persisted var familiarity: Int
    
    convenience init(id: UUID, text: String, contexts: [ContextObject], familiarity: Int) {
        self.init()
        self.id = id
        self.text = text
        self.familiarity = familiarity
        self.contexts = .init()
        self.contexts.append(objectsIn: contexts)
    }
    
    convenience init(phrase: Phrase) {
        self.init(id: phrase.id, text: phrase.text, contexts: phrase.contexts.map { .init(id: $0.id, context: $0)}, familiarity: phrase.familiarity)
    }
    
    func toPhrase() -> Phrase {
        let contextsArray = Array(contexts.map { $0.toContext() })
        return .init(id: id, text: text, contexts: contextsArray, familiarity: familiarity)
    }
}
