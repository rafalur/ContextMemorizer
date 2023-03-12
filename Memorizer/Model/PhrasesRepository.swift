//
//  PhrasesRepository.swift
//  Memorizer

import Foundation
import Combine

protocol PhrasesRepository {
    var phrasesPublisher: AnyPublisher<[Phrase], Never> { get }
    
    func load()
    func add(phrase: Phrase) -> AnyPublisher<Void, Error>
    func update(phrase: Phrase) -> AnyPublisher<Void, Error>    
}
