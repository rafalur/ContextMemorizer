//
//  PhraseEdit+Components.swift
//  Memorizer

import Foundation
import SwiftUI

extension PhraseEditView {
    struct ContextRowView: View {
        let context: Context
        var body: some View {
            HStack {
                Spacer()
                Text(context.sentence)
                Spacer()
            }
            .padding(.vertical)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
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
