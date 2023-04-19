//
//  ContextObject.swift
//  Memorizer
//
//  Created by Rafal Urbaniak on 19/04/2023.
//

import Foundation
import RealmSwift

class ContextObject: Object {
    @Persisted(primaryKey: true) var id: UUID
    @Persisted var sentence: String
    
    convenience init(id: UUID, context: Context) {
        self.init()
        self.id = id
        self.sentence = context.sentence
    }
    
    func toContext() -> Context {
        return Context(id: id, sentence: sentence)
    }
}
