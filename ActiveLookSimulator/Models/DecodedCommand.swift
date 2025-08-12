//
//  DecodedCommand.swift
//  ActiveLookSimulator
//
//  Created by Benjamin Szakal on 10/08/2025.
//

import Foundation
import SwiftUI

struct DecodedCommand {
    let commandId: CommandId
    let values: [Int]
    let textValue: String?
    let queryId: UInt8?
}

struct DrawingCommand: Identifiable {
    let id = UUID()
    let commandType: CommandType
    var color: Color?
    var shift: CGSize?
    
    enum CommandType {
        case circle(center: CGPoint, radius: CGFloat)
        case rectangle(topLeft: CGPoint, bottomRight: CGPoint)
        case text(position: CGPoint, text: String, rotation: Int, fontSize: Int, color: Int)
        case filledCircle(center: CGPoint, radius: CGFloat)
        case filledRectangle(topLeft: CGPoint, bottomRight: CGPoint)
        case point(position: CGPoint)
        case line(start: CGPoint, end: CGPoint)
        case setGreyLevel(level: Int)
        case setShift(offset: CGSize)
        case setColor(color: Int)
    }
    
}
