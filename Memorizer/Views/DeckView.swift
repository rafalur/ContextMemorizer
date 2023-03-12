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
        .navigationDestination(for: Phrase.self) { phrase in
            PhraseView(phrase: phrase)
                .environmentObject(dependencies)
                .environmentObject(coordinator)
        }
        .navigationDestination(for: EditPhraseNavDestination.self) { editPhraseDestination in
            PhraseEditView(dependencies: dependencies, phraseToEdit: editPhraseDestination.phrase)
                .environmentObject(dependencies)
                .environmentObject(coordinator)
        }
    }

    var phrasesList: some View {
        List {
            ForEach(viewModel.phrases) { phrase in
                NavigationLink(value: phrase) {
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
            NavigationLink(value: EditPhraseNavDestination(phrase: nil)) {
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
