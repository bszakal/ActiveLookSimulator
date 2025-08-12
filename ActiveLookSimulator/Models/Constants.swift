//
//  ColorLevel.swift
//  ActiveLookSimulator
//
//  Created by Benjamin Szakal on 10/08/2025.
//

import Foundation

struct Constants {
    static let yellowGreyLevels: [Int: String] = [
        0: "#101000",
        1: "#202000",
        2: "#303000",
        3: "#404000",
        4: "#505000",
        5: "#606000",
        6: "#707000",
        7: "#808000",
        8: "#909000",
        9: "#A0A000",
        10: "#B0B000",
        11: "#C0C000",
        12: "#D0D000",
        13: "#E0E000",
        14: "#F0F000",
        15: "#FFFF00"
    ]
    
    static func fontSize(for level: Int) -> CGFloat {
        switch level {
        case 0, 1:
            return 24
        case 2:
            return 35
        case 3:
            return 49
        default:
            return 24
        }
    }
}
