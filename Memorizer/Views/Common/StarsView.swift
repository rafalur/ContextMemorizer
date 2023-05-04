//
//  StarsView.swift
//  Memorizer

import Foundation
import SwiftUI

struct StarsView: View {
    enum Size {
        case small
        case medium
        case large
    }
    
    @Binding var value: Int
    
    let size: Size
    let editable: Bool 
    
    private var imageScale: Image.Scale {
        switch size {
        case .small:
            return .small
        case .medium:
            return .medium
        case .large:
            return .large
        }
    }
    
    private let numberOfStars: Int = 5
    
    var body: some View {
        HStack(spacing: 2) {
            ForEach(1...numberOfStars, id: \.self) { index in
                Image(systemName: index <= value ? "star.fill" : "star")
                    .foregroundColor(.blue)
                    .allowsHitTesting(editable) // to disable tap recongizer while not editable
                    .onTapGesture {
                        value = index
                    }.imageScale(imageScale)
            }
        }
    }
}
