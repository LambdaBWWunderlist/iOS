//
//  UIColorExtension.swift
//  Wunderlist
//
//  Created by Dahna on 6/22/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    enum NamedColor: String {
        case accentBlue
        case actionBlue
        case borderGray
        case buttonOrange
        case deselectedBlue
    }
    
    private static func color(named: NamedColor) -> UIColor {
        guard let color = UIColor(named: named.rawValue) else { return .black }
        return color
    }
    
    static var accentBlue: UIColor {
        color(named: .accentBlue)
    }
    
    static var actionBlue: UIColor {
        color(named: .actionBlue)
    }
    
    static var borderGray: UIColor {
        color(named: .borderGray)
    }
    
    static var buttonOrange: UIColor {
        color(named: .buttonOrange)
    }
    
    static var deselectedBlue: UIColor {
        color(named: .deselectedBlue)
    }
}


