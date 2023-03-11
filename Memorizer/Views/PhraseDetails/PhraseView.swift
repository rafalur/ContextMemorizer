//
//  ContentView.swift
//  Memorizer

import SwiftUI

struct PhraseView: View {
    let phrase: Phrase // at the moment the view is static so skipping the VM for now

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
            EditButton()
        }
    }
}

private extension PhraseView {
    struct EditButton: View {
        @EnvironmentObject var dependencies: Dependencies
        @State var selectedTag: String?

        let editLinkTag = "editLinkTag"

        var body: some View {
            Button("Edit") {
                selectedTag = editLinkTag
            }
            .controlSize(.regular)
            .buttonStyle(.borderedProminent)
            .background(
                // TODO: use non-deprecated version
                NavigationLink(
                    destination: PhraseEditView(dependencies: dependencies),
                    tag: editLinkTag,
                    selection: $selectedTag,
                    label: { EmptyView() }
                )
            )
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
