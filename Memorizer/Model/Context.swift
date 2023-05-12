//
//  Context.swift
//  Memorizer
//
//  Created by Rafal Urbaniak on 12/05/2023.
//

import Foundation

struct Context: Identifiable, Equatable, Hashable {
    let id: UUID
    var sentence: String
    
    init(id: UUID = .init(), sentence: String) {
        self.id = id
        self.sentence = sentence
    }
}
