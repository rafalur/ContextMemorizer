//
//  NavigationDestinations.swift
//  Memorizer


import Foundation

enum NavigationDestinations: Hashable {
    case phraseDetails(phrase: Phrase)
    case phraseEdit(phrase: Phrase?)
}
