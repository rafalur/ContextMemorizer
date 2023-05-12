//
//  Phrase.swift
//  Memorizer

import Foundation

struct Phrase: Identifiable, Equatable, Hashable {
    let id: UUID
    let text: String
    let contexts: [Context]
    
    init(id: UUID = .init(), text: String, contexts: [Context]) {
        self.id = id
        self.text = text
        self.contexts = contexts
    }
    
    func sameValue(as other: Phrase) -> Bool {
        return other.text == text && other.contexts == contexts
    }
}

struct Context: Identifiable, Equatable, Hashable {
    let id: UUID
    var sentence: String
    
    init(id: UUID = .init(), sentence: String) {
        self.id = id
        self.sentence = sentence
    }
}
