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
                SentenceView(text: context.sentence)
                    .padding(30)
                    .background(gradient(forUUID: context.id))
                    .cornerRadius(10)
                    .padding()

                StarsView(value: bindingToCurrentContext.familiarity, size: .large, editable: true)
            }
            Spacer()
            Button("Next") {
                viewModel.scoreCurrentSentence.send(1)
            }
        }
    }
    
    
    func gradient(forUUID uuid: UUID) -> LinearGradient {
        let numberOfColors = Int.random(in: 2...5)
        
        var colors = [Color]()
        for _ in 1...numberOfColors {
            colors.append(Color(uiColor: .random))
        }
        
        print("colors: \(colors)")
        
        let startPoint = UnitPoint(x: .random(in: 0...1), y: .random(in: 0...1))
        let endPoint = UnitPoint(x: .random(in: 0...1), y: .random(in: 0...1))
        
        return LinearGradient(colors: colors, startPoint: startPoint, endPoint: endPoint)
    }
}

extension UIColor {
    static var random: UIColor {
        return UIColor(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1),
            alpha: 1.0
        )
    }
}

struct SentenceView: View {
    let text: String

    var body: some View {
            Text(text)
            .font(.title2)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background { RoundedRectangle(cornerRadius: 10).foregroundColor(Color.gray.opacity(0.7)) }
    }
}

struct LessonView_Previews: PreviewProvider {
    static var previews: some View {
        LessonView(dependencies: .mock)
    }
}
