//
//  PhrasesRepository.swift
//  Memorizer

import Foundation
import Combine

protocol PhrasesRepository {
    var phrasesPublisher: AnyPublisher<[Phrase], Never> { get }
    
    func load()
}
