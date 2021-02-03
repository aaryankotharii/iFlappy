//
//  RandomGenerator.swift
//  iFlappy
//
//  Created by Aaryan Kothari on 03/02/21.
//

import Foundation
import CoreGraphics

public extension CGFloat {
    
    static func random() -> CGFloat {
        let randomFloat = Float(arc4random())
        let max : Float = 0xFFFFFFFF
        return CGFloat(randomFloat/max)
    }
    
    static func random(min min : CGFloat, max: CGFloat) -> CGFloat {
        return CGFloat.random() * (max - min) + min
    }
}
