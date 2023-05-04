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
    let id: UUID
    var sentence: String
    var familiarity: Int
    
    init(id: UUID = .init(), sentence: String, familiarity: Int = 0) {
        self.id = id
        self.sentence = sentence
        self.familiarity = familiarity
    }
}
