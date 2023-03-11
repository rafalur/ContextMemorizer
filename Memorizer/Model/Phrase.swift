//
//  Phrase.swift
//  Memorizer

import Foundation

struct Phrase: Identifiable {
    let id: UUID = .init()
    let text: String
    let contexts: [Context]
    let familiarity: Int
}

struct Context: Identifiable {
    let id: UUID = .init()
    let sentence: String
}
