//
//  ScoresProvider.swift
//  Memorizer
//
//  Created by Rafal Urbaniak on 12/05/2023.
//

import Foundation

protocol ScoresProvider {
    func scoreForContext(withId: UUID) -> UInt?
}
