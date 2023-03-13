//
//  PhraseEdit+Components.swift
//  Memorizer

import Foundation
import SwiftUI

extension PhraseEditView {
    struct ContextRowView: View {
        let context: Context
        let removable: Bool
        var onRemove: (()->())? = nil
        
        var body: some View {
            HStack {
                Spacer()
                Text(context.sentence)
                Spacer()
                if removable {
                    Button {
                        onRemove?()
                    } label: {
                        Image(systemName: "xmark.bin.fill")
                    }
                    .padding(15)
                }
            }
            .padding(.vertical)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
        }
        
        func onRemove(_ action: @escaping (()->()) ) -> some View {
            var mutableSelf = self
            mutableSelf.onRemove = action
            return mutableSelf
        }
    }

    struct AddContextView: View {
        var onSaved: (Context) -> Void

        @State private var text: String = ""

        var body: some View {
            VStack {
                Text("Add Context")
                TextField("Text", text: $text)
                    .padding(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10.0)
                            .stroke(.gray, lineWidth: 1)
                    ).padding(.top, 20)
                Button("Save") {
                    onSaved(Context(sentence: text))
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
        }
    }
}
