//
//  PhrasesRepository.swift
//  Memorizer

import Foundation

protocol PhrasesRepository {
    func allPhrases(_ completion: @escaping (Result<[Phrase], Error>) -> Void)
}
