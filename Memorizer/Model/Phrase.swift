//
//  Phrase.swift
//  Memorizer

import Foundation

struct Phrase: Identifiable, Equatable, Hashable {
    let id: UUID
    let text: String
    let contexts: [Context]
    let familiarity: Int
    
    init(id: UUID = .init(), text: String, contexts: [Context], familiarity: Int) {
        self.id = id
        self.text = text
        self.contexts = contexts
        self.familiarity = familiarity
    }
    
    func sameValue(as other: Phrase) -> Bool {
        return other.text == text && other.contexts == contexts && other.familiarity == familiarity
    }
}

struct Context: Identifiable, Equatable, Hashable {
    let id: UUID = .init()
    var sentence: String
}
