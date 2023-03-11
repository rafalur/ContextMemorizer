//
//  MockData.swift
//  Memorizer

import Foundation

let testPhrases: [Phrase] = [.init(text: "Jump",
                                   contexts: [
                                       .init(sentence: "Please do not jump."),
                                       .init(sentence: "The child jumps as spring."),
                                   ],
                                   familiarity: 3),
                             .init(text: "Car",
                                   contexts: [
                                       .init(sentence: "This car is very fast."),
                                       .init(sentence: "What kind of car is that?"),
                                       .init(sentence: "He owns 22 cars."),
                                   ],
                                   familiarity: 4),
                             .init(text: "Coffee",
                                   contexts: [
                                       .init(sentence: "That's my very first coffee today."),
                                       .init(sentence: "What would you say for a cup of coffee."),
                                       .init(sentence: "He owns 22 cars."),
                                   ],
                                   familiarity: 1),
                             .init(text: "Fly",
                                   contexts: [
                                       .init(sentence: "Planes fly."),
                                       .init(sentence: "I will fly to London."),
                                   ],
                                   familiarity: 5),
]
