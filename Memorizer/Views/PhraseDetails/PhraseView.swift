//
//  ContentView.swift
//  Memorizer

import SwiftUI

struct EditPhraseNavDestination: Hashable {
    let phrase: Phrase?
}

struct PhraseView: View {
    @EnvironmentObject var dependencies: Dependencies
    @EnvironmentObject var coordinator: Coordinator

    let phrase: Phrase // at the moment the view is static so skipping the VM for now

    @State var selectedTag: String?
    @State private var isShowingSecondView: Bool = false

    var body: some View {
        VStack {
            PhraseCard(text: phrase.text).padding(.vertical, 30)
            List {
                ForEach(phrase.contexts) {
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
                coordinator.path.append(EditPhraseNavDestination(phrase: phrase))
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
            StarsView(value: 3, size: .large)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PhraseView(phrase: testPhrases[0])
        }
        PhraseView(phrase: testPhrases[1])
    }
}
