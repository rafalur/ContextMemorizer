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
        phrasesList
        .toolbar { toolbar }
    }
    
    @ToolbarContentBuilder
    var toolbar: some ToolbarContent {
        ToolbarItemGroup(placement: .navigationBarTrailing) {
            Button {
                viewModel.toggleSort.send()
            } label: {
                Image(systemName: "arrow.up.arrow.down")
            }
            .controlSize(.regular)
            .buttonStyle(.borderedProminent)

            Button {
                coordinator.path.append(NavigationDestinations.phraseEdit(phrase: nil))
            } label: {
                Image(systemName: "plus.app")
            }
            .controlSize(.regular)
            .buttonStyle(.borderedProminent)
        }
        
        ToolbarItemGroup(placement: .navigationBarLeading) {
            Button {
                coordinator.path.append(NavigationDestinations.learn)
            } label: {
                Text("LEARN")
            }
            .controlSize(.regular)
            .buttonStyle(.borderedProminent)
        }
    }

    var phrasesList: some View {
        List {
            Section("Phrases") {
                ForEach(viewModel.phrases) { phrase in
                    NavigationLink(value: NavigationDestinations.phraseDetails(phrase: phrase)) {
                        HStack {
                            Text(phrase.text)
                            Spacer()
                            StarsView(value: .constant(1), size: .small, editable: false)
                        }
                    }
                    .foregroundColor(.white)
                    .listRowBackground(Color.gray.opacity(0.7))
                }
            }
        }
        .scrollContentBackground(.hidden)
        .background(.clear)
    }
}

struct DeckView_Previews: PreviewProvider {
    static var previews: some View {
        DeckView(dependencies: .mock)
    }
}
