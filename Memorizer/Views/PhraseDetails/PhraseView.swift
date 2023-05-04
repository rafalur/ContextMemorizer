//
//  ContentView.swift
//  Memorizer

import SwiftUI

struct PhraseView: View {
    @EnvironmentObject var dependencies: Dependencies
    @EnvironmentObject var coordinator: Coordinator

    @StateObject var viewModel: PhraseDetailsViewModel
    
    init(dependencies: Dependencies, phrase: Phrase) {
        let viewModel = PhraseDetailsViewModel(phrase: phrase, phrasesRepo: dependencies.phrasesRepo)
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack {
            PhraseCard(text: viewModel.phrase.text).padding(.vertical, 30)
            List {
                ForEach(viewModel.phrase.contexts) {
                    ContextItemView(context: $0)
                }
            }
        }
        .toolbar { toolbar }
    }

    @ToolbarContentBuilder
    var toolbar: some ToolbarContent {
        ToolbarItemGroup(placement: .navigationBarTrailing) {
            Button("Practice ") {
                
            }
            .controlSize(.regular)
            .buttonStyle(.borderedProminent)
            
            Button("Edit") {
                coordinator.path.append(NavigationDestinations.phraseEdit(phrase: viewModel.phrase))
            }
            .controlSize(.regular)
            .buttonStyle(.borderedProminent)
        }
    }
}

struct ContextItemView: View {
    let context: Context

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(context.sentence)
            StarsView(value: .constant(3), size: .medium, editable: false)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PhraseView(dependencies: .mock, phrase: testPhrases[0])
        }
    }
}
