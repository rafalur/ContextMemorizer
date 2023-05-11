//
//  GradientColorInfo.swift
//  Memorizer
//
//  Created by Rafal Urbaniak on 11/05/2023.
//

import Foundation
import SwiftUI

struct GradientColorsInfo {
    let colors: [Color]
    let startPoint: UnitPoint
    let endpoint: UnitPoint
    
    var gradient: LinearGradient {
        LinearGradient(colors: colors, startPoint: startPoint, endPoint: endpoint)
    }
    
    static var random: GradientColorsInfo {
        let numberOfColors = Int.random(in: 2...5)
        
        var colors = [Color]()
        for _ in 1...numberOfColors {
            colors.append(Color(uiColor: .random))
        }
        
        return .init(colors: colors, startPoint: .random, endpoint: .random)
    }
}


extension UnitPoint {
    static var random: UnitPoint {
        UnitPoint(x: .random(in: 0...1), y: .random(in: 0...1))
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
