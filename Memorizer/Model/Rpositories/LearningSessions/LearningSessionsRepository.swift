//
//  LearningSessionsRepository.swift
//  Memorizer
//
//  Created by Rafal Urbaniak on 12/05/2023.
//

import Foundation

import Combine

protocol LearningSessionsRepository {
    var sessionsPublisher: AnyPublisher<[LearningSession], Never> { get }
    
    func add(session: LearningSession) -> AnyPublisher<Void, Error>
}
