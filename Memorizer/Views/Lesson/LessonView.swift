//
//  LessonView.swift
//  Memorizer

import SwiftUI

struct LessonView: View {
    @EnvironmentObject var dependencies: Dependencies
    @EnvironmentObject var coordinator: Coordinator

    @StateObject var viewModel: LessonViewModel

    
    init(dependencies: Dependencies) {
        let viewModel = LessonViewModel(phrasesRepo: dependencies.phrasesRepo)
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack {
            if let context = viewModel.context {
                SentenceView(text: context.sentence).padding()
            }
            Spacer()
            Button("Next") {
                viewModel.scoreCurrentSentence.send(1)
            }
        }
    }
}

struct SentenceView: View {
    let text: String

    var body: some View {
            Text(text)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background { RoundedRectangle(cornerRadius: 5).foregroundColor(Color.gray.opacity(0.7)) }
    }
}

struct LessonViewPreviews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PhraseView(dependencies: .mock, phrase: testPhrases[0])
        }
    }
}
