//
//  TextRotation.swift
//  ActiveLookSimulator
//
//  Created by Benjamin Szakal on 12/08/2025.
//

import Foundation

enum TextRotation: Int {
    case bottomRL = 0
    case bottomLR = 1
    case leftBT = 2
    case leftTB = 3
    case topLR = 4
    case topRL = 5
    case rightTB = 6
    case rightBT = 7
    
    var rotationDegrees: Double {
        switch self {
        case .bottomRL:
            return 180
        case .bottomLR:
            return 180
        case .leftBT:
            return 90
        case .leftTB:
            return 90
        case .topLR:
            return 0
        case .topRL:
            return 0
        case .rightTB:
            return 270
        case .rightBT:
            return 270
        }
    }
    
    var isLeftToRight: Bool {
        switch self {
        case .bottomRL, .topLR, .leftTB, .rightTB:
            return false
        default:
            return true
        }
    }
}
