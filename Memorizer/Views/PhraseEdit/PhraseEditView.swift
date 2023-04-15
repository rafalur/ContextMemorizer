//
//  PhraseEditView.swift
//  Memorizer

import SwiftUI

struct PhraseEditView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @EnvironmentObject private var dependencies: Dependencies
    @StateObject private var viewModel: PhraseEditViewModel

    init(dependencies: Dependencies, phraseToEdit: Phrase? = nil) {
        let viewModel = PhraseEditViewModel(phraseToEdit: phraseToEdit, phrasesRepo: dependencies.phrasesRepo)
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    @State private var isAdding = false

    var body: some View {
        VStack {
            phraseTextEdit
            contextViewsGroup
            .transition(AnyTransition.scale.animation(.spring()))
            
            Spacer()
        }
        .padding()
        .padding(.top, 20)
        .toolbar { toolbarContent }
        .onChange(of: viewModel.done) { done in
            if done {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
    
    var toolbarContent: some ToolbarContent {
        ToolbarItemGroup(placement: .navigationBarTrailing) {
            Button {
                viewModel.save.send()
                    } label: {
                        if viewModel.savingInProgress {
                            ProgressView()
                        } else {
                            Text("Save")
                        }
                    }
            .disabled(!viewModel.saveAllowed)
            .controlSize(.regular)
            .buttonStyle(.borderedProminent)
        }
    }

    var phraseTextEdit: some View {
        let textFieldFrameColor: Color = viewModel.textValid ? .gray : .red
        return TextField("Phrase", text: $viewModel.text)
            .padding(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10.0)
                    .stroke(textFieldFrameColor, lineWidth: 1)
            )
    }
    
    var contextViewsGroup: some View {
        Group {
            contexts
            if isAdding {
                addContextView
                    .padding(.top, 20)
            } else {
                addContextButton
                    .padding(.top, 30)
            }
        }
    }

    var contexts: some View {
        ForEach($viewModel.addedContexts) { context in
            ContextRowView(context: context, editable: true)
                .onRemove {
                    withAnimation(.easeIn) {
                        viewModel.removeContext.send(context.wrappedValue)
                    }
                }
                .padding(.top, 5)
                .transition(AnyTransition.asymmetric(
                    insertion: .move(edge: .trailing),
                    removal: .move(edge: .leading)
                ).combined(with: .opacity))
        }
    }

    var addContextView: some View {
        AddContextView(onSaved: { context in
            withAnimation {
                viewModel.addContext.send(context)
                isAdding = false
            }
        })
    }

    var addContextButton: some View {
        Button {
            isAdding.toggle()
        } label: {
            Label("Add next context", systemImage: "plus.app")
        }
    }
}

struct PhraseEditView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            PhraseEditView(dependencies: .mock, phraseToEdit: .init(text: "Test", contexts: [.init(sentence: "Seneaa")], familiarity: 3))
        }
    }
}
