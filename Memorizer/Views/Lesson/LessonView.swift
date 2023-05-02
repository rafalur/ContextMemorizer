//
//  LessonView.swift
//  Memorizer

import SwiftUI

struct LessonView: View {
    @EnvironmentObject var dependencies: Dependencies
    @EnvironmentObject var coordinator: Coordinator

    
    init(dependencies: Dependencies) {

    }

    var body: some View {
        Text("LESSON")
    }
}



struct LessonViewPreviews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PhraseView(dependencies: .mock, phrase: testPhrases[0])
        }
    }
}
