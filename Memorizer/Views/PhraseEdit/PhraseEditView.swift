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
        .onChange(of: viewModel.done) { done in
            if done {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }

    var phraseTextEdit: some View {
        let textFieldFrameColor: Color = viewModel.textValid ? .gray : .red
        return TextField("Phrase", text: $viewModel.text)
            .padding(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10.0)
                    .stroke(textFieldFrameColor, lineWidth: 1)
            ).padding(.top, 20)
    }

    var addedContexts: some View {
        ForEach(viewModel.addedContexts) { context in
            ContextRowView(context: context, removable: true)
                .onRemove {
                    withAnimation(.easeIn) {
                        viewModel.removeContext.send(context)
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
