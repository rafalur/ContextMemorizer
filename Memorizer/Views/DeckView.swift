//
//  DeckView.swift
//  Memorizer

import SwiftUI

struct DeckView: View {
    @EnvironmentObject var coordinator: Coordinator
    @EnvironmentObject private var dependencies: Dependencies
    @StateObject private var viewModel: DeckViewModel

    init(dependencies: Dependencies) {
        let viewModel = DeckViewModel(phrasesRepo: dependencies.phrasesRepo)
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack {
            phrasesList
            buttonsBar
        }
    }

    var phrasesList: some View {
        List {
            ForEach(viewModel.phrases) { phrase in
                NavigationLink(value: NavigationDestinations.phraseDetails(phrase: phrase)) {
                    HStack {
                        Text(phrase.text)
                        Spacer()
                        StarsView(value: phrase.familiarity, size: .small)
                    }
                }
                .foregroundColor(.white)
                .listRowBackground(Color.green.opacity(0.5))
            }
        }
        .scrollContentBackground(.hidden)
        .background(.clear)
    }

    var buttonsBar: some View {
        HStack {
            Button("Sort by familiarity") {
                viewModel.toggleSort.send()
            }
            Spacer()
            NavigationLink(value: NavigationDestinations.phraseEdit(phrase: nil)) {
                Text("Add phrase")
            }

        }.padding()
    }
}

struct DeckView_Previews: PreviewProvider {
    static var previews: some View {
        DeckView(dependencies: .mock)
    }
}
