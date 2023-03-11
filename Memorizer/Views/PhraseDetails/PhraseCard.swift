//
//  PhraseCard.swift
//  Memorizer

import Foundation
import SwiftUI

struct PhraseCard: View {
    let text: String

    @State var expanded: Bool = false

    var body: some View {
        HStack {
            Spacer()
            Text(text)
                .font(.title)
                .padding([.vertical], expanded ? 40 : 20)
                .onTapGesture {
                    withAnimation {
                        expanded.toggle()
                    }
                }
            Spacer()
        }.background(.blue.opacity(0.1))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(.blue, lineWidth: 1.5)
            )
            .padding([.horizontal], expanded ? 40 : 20)
    }
}
