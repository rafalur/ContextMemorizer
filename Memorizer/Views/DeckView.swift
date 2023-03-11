//
//  DeckView.swift
//  Memorizer

import SwiftUI

struct DeckView: View {
    @EnvironmentObject private var dependencies: Dependencies
    @StateObject private var viewModel: DeckViewModel

    init(dependencies: Dependencies) {
        let viewModel = DeckViewModel(phrasesRepo: dependencies.phrasesRepo)
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationView {
            VStack {
                phrasesList
                buttonsBar
            }
        }
    }

    var phrasesList: some View {
        List {
            ForEach(viewModel.phrases) { phrase in
                NavigationLink(destination: PhraseView(phrase: phrase)) {
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
                viewModel.sort()
            }
            Spacer()
            NavigationLink(destination: PhraseEditView(dependencies: dependencies)) {
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
