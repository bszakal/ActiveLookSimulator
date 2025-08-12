//
//  DrawingCommandConverter.swift
//  ActiveLookSimulator
//
//  Created by Benjamin Szakal on 12/08/2025.
//

import Foundation

struct DrawingCommandConverter {
    
    func convertCommandToDrawingCommand(_ command: DecodedCommand) -> DrawingCommand? {
        switch command.commandId {
        case .circ:
            guard command.values.count == 3 else {
                return nil
            }
            let x = command.values[0]
            let y = command.values[1]
            let radius = command.values[2]
            return DrawingCommand(commandType: .circle(center: .init(x: CGFloat(x), y: CGFloat(y)), radius: CGFloat(radius)))
            
        case .rect:
            guard command.values.count == 4 else {
                return nil
            }
            let x0 = command.values[0]
            let y0 = command.values[1]
            let x1 = command.values[2]
            let y1 = command.values[3]
            return DrawingCommand(commandType: .rectangle(topLeft: .init(x: CGFloat(x0), y: CGFloat(y0)),
                                                          bottomRight: .init(x: CGFloat(x1), y: CGFloat(y1))))
            
        default:
            return nil
        }
    }
    
    func convertCommandToLog(_ command: DecodedCommand) -> CommandLog {
        
        let invalidCommand = CommandLog(title: "InvalidCommand", parameters: [], commandId: .unknown)
        
        switch command.commandId {
        case .circ:
            guard command.values.count == 3 else {
                return invalidCommand
            }
            
            let xParam = CommandLog.CommandParameter(parameterName: "x", value: command.values[0])
            let yParam = CommandLog.CommandParameter(parameterName: "y", value: command.values[1])
            let radiusParam = CommandLog.CommandParameter(parameterName: "r", value: command.values[2])
            
            return CommandLog(title: "Draw Circle", parameters: [xParam, yParam, radiusParam], commandId: command.commandId)
            
        default:
            return CommandLog(title: "Unknown", parameters: [], commandId: .unknown)
        }
    
    }
}
