//
//  StarsView.swift
//  Memorizer

import Foundation
import SwiftUI

struct StarsView: View {
    enum Size {
        case small
        case large
    }

    let value: Int
    let size: Size

    var body: some View {
        HStack(spacing: 1) {
            ForEach(1 ... 5, id: \.self) { index in
                let imageName = index <= value ? "star.fill" : "star"
                let imageScale = size == .small ? Image.Scale.small : .large
                Image(systemName: imageName).foregroundColor(.blue).imageScale(imageScale)
            }
        }
    }
}
