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
            if let context = viewModel.context, let bindingToCurrentContext = Binding<Context>($viewModel.context)  {
                SentenceView(context: context)
                    .padding()

                StarsView(value: bindingToCurrentContext.familiarity, size: .large, editable: true)
            }
            Spacer()
            Button("Next") {
                viewModel.scoreCurrentSentence.send(1)
            }
        }
    }
}

struct SentenceView: View {
    let context: Context
    
    var body: some View {
        Text(context.sentence)
            .font(.title2)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(Color.gray.opacity(0.7))
            }
            .padding(30)
            .background(GradientColorsInfo.random.gradient)
            .cornerRadius(10)
    }
}

struct LessonView_Previews: PreviewProvider {
    static var previews: some View {
        LessonView(dependencies: .mock)
    }
}
