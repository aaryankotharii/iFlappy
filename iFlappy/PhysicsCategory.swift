//
//  PhysicsCategory.swift
//  iFlappy
//
//  Created by Aaryan Kothari on 02/02/21.
//

import Foundation

struct PhysicsCategory {
    static let Bird : UInt32 = 0x1 << 1
    static let Ground : UInt32 = 0x1 << 2
    static let Wall : UInt32 = 0x1 << 3
}
