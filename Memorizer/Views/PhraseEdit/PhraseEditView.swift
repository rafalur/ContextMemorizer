//
//  PhraseEditView.swift
//  Memorizer

import SwiftUI

struct PhraseEditView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @EnvironmentObject private var dependencies: Dependencies
    @StateObject private var viewModel: PhraseEditViewModel

    init(dependencies: Dependencies) {
        let viewModel = PhraseEditViewModel(phrasesRepo: dependencies.phrasesRepo)
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    @State private var isAdding = false

    var body: some View {
        return VStack {
            phraseTextEdit

            Group {
                addedContexts
                if isAdding {
                    addContextView
                } else {
                    addContextButton
                }
            }.transition(AnyTransition.scale.animation(.spring()))

            Spacer()
        }
        .padding()
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button("Save") {
                    viewModel.save()
                    presentationMode.wrappedValue.dismiss()
                }
                .controlSize(.regular)
                .buttonStyle(.borderedProminent)
            }
        }.onDisappear {
            viewModel.reset()
        }
    }

    var phraseTextEdit: some View {
        let textFieldFrameColor: Color = viewModel.saveError == nil ? .gray : .red
        return TextField("Phrase", text: $viewModel.text)
            .padding(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10.0)
                    .stroke(textFieldFrameColor, lineWidth: 1)
            ).padding(.top, 20)
    }

    var addedContexts: some View {
        ForEach(viewModel.addedContexts) {
            ContextRowView(context: $0)
                .padding(.top, 5)
                .transition(AnyTransition.scale.animation(.spring()))
        }
    }

    var addContextView: some View {
        AddContextView(onSaved: { context in
            withAnimation {
                viewModel.add(context: context)
                isAdding = false
            }
        })
        .padding(.top, 20)
    }

    var addContextButton: some View {
        Button {
            isAdding.toggle()
        } label: {
            Label("Add next context", systemImage: "plus.app")
        }.padding(.top, 30)
    }
}

struct PhraseEditView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            PhraseEditView(dependencies: .mock)
        }
    }
}
