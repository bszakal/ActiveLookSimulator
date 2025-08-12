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
            
        case .txt:
            guard command.values.count == 5, let text = command.textValue else {
                return nil
            }
            let x = command.values[0]
            let y = command.values[1]
            let rotation = command.values[2]
            let fontSize = command.values[3]
            let color = command.values[4]
            return DrawingCommand(commandType: .text(
                position: .init(x: CGFloat(x), y: CGFloat(y)),
                text: text,
                rotation: rotation,
                fontSize: fontSize,
                color: color
            ))
            
        case .circf:
            guard command.values.count == 3 else {
                return nil
            }
            let x = command.values[0]
            let y = command.values[1]
            let radius = command.values[2]
            return DrawingCommand(commandType: .filledCircle(center: .init(x: CGFloat(x), y: CGFloat(y)), radius: CGFloat(radius)))
            
        case .rectf:
            guard command.values.count == 4 else {
                return nil
            }
            let x0 = command.values[0]
            let y0 = command.values[1]
            let x1 = command.values[2]
            let y1 = command.values[3]
            return DrawingCommand(commandType: .filledRectangle(topLeft: .init(x: CGFloat(x0), y: CGFloat(y0)),
                                                               bottomRight: .init(x: CGFloat(x1), y: CGFloat(y1))))
            
        case .point:
            guard command.values.count == 2 else {
                return nil
            }
            let x = command.values[0]
            let y = command.values[1]
            return DrawingCommand(commandType: .point(position: .init(x: CGFloat(x), y: CGFloat(y))))
            
        case .line:
            guard command.values.count == 4 else {
                return nil
            }
            let x0 = command.values[0]
            let y0 = command.values[1]
            let x1 = command.values[2]
            let y1 = command.values[3]
            return DrawingCommand(commandType: .line(start: .init(x: CGFloat(x0), y: CGFloat(y0)),
                                                    end: .init(x: CGFloat(x1), y: CGFloat(y1))))
            
        case .grey:
            guard command.values.count == 1 else {
                return nil
            }
            let level = command.values[0]
            return DrawingCommand(commandType: .setGreyLevel(level: level))
            
        case .shift:
            guard command.values.count == 2 else {
                return nil
            }
            let x = command.values[0]
            let y = command.values[1]
            return DrawingCommand(commandType: .setShift(offset: .init(width: CGFloat(x), height: CGFloat(y))))
            
        case .color:
            guard command.values.count == 1 else {
                return nil
            }
            let color = command.values[0]
            return DrawingCommand(commandType: .setColor(color: color))
            
        default:
            return nil
        }
    }
    
    func convertCommandToLog(_ command: DecodedCommand) -> CommandLog {
        
        let invalidCommand = CommandLog(title: "Invalid Command", parameters: [], commandId: .unknown)
        
        switch command.commandId {
        case .circ:
            guard command.values.count == 3 else { return invalidCommand }
            let params = [
                CommandLog.CommandParameter(parameterName: "x", value: command.values[0]),
                CommandLog.CommandParameter(parameterName: "y", value: command.values[1]),
                CommandLog.CommandParameter(parameterName: "r", value: command.values[2])
            ]
            return CommandLog(title: "Draw Circle", parameters: params, commandId: command.commandId)
            
        case .circf:
            guard command.values.count == 3 else { return invalidCommand }
            let params = [
                CommandLog.CommandParameter(parameterName: "x", value: command.values[0]),
                CommandLog.CommandParameter(parameterName: "y", value: command.values[1]),
                CommandLog.CommandParameter(parameterName: "r", value: command.values[2])
            ]
            return CommandLog(title: "Draw Filled Circle", parameters: params, commandId: command.commandId)
            
        case .rect:
            guard command.values.count == 4 else { return invalidCommand }
            let params = [
                CommandLog.CommandParameter(parameterName: "x0", value: command.values[0]),
                CommandLog.CommandParameter(parameterName: "y0", value: command.values[1]),
                CommandLog.CommandParameter(parameterName: "x1", value: command.values[2]),
                CommandLog.CommandParameter(parameterName: "y1", value: command.values[3])
            ]
            return CommandLog(title: "Draw Rectangle", parameters: params, commandId: command.commandId)
            
        case .rectf:
            guard command.values.count == 4 else { return invalidCommand }
            let params = [
                CommandLog.CommandParameter(parameterName: "x0", value: command.values[0]),
                CommandLog.CommandParameter(parameterName: "y0", value: command.values[1]),
                CommandLog.CommandParameter(parameterName: "x1", value: command.values[2]),
                CommandLog.CommandParameter(parameterName: "y1", value: command.values[3])
            ]
            return CommandLog(title: "Draw Filled Rectangle", parameters: params, commandId: command.commandId)
            
        case .line:
            guard command.values.count == 4 else { return invalidCommand }
            let params = [
                CommandLog.CommandParameter(parameterName: "x0", value: command.values[0]),
                CommandLog.CommandParameter(parameterName: "y0", value: command.values[1]),
                CommandLog.CommandParameter(parameterName: "x1", value: command.values[2]),
                CommandLog.CommandParameter(parameterName: "y1", value: command.values[3])
            ]
            return CommandLog(title: "Draw Line", parameters: params, commandId: command.commandId)
            
        case .point:
            guard command.values.count == 2 else { return invalidCommand }
            let params = [
                CommandLog.CommandParameter(parameterName: "x", value: command.values[0]),
                CommandLog.CommandParameter(parameterName: "y", value: command.values[1])
            ]
            return CommandLog(title: "Draw Point", parameters: params, commandId: command.commandId)
            
        case .txt:
            guard command.values.count == 5, let text = command.textValue else { return invalidCommand }
            let params = [
                CommandLog.CommandParameter(parameterName: "x", value: command.values[0]),
                CommandLog.CommandParameter(parameterName: "y", value: command.values[1]),
                CommandLog.CommandParameter(parameterName: "rotation", value: command.values[2]),
                CommandLog.CommandParameter(parameterName: "fontSize", value: command.values[3]),
                CommandLog.CommandParameter(parameterName: "color", value: command.values[4]),
                CommandLog.CommandParameter(parameterName: "text", value: text)
            ]
            return CommandLog(title: "Draw Text", parameters: params, commandId: command.commandId)
            
        case .grey:
            guard command.values.count == 1 else { return invalidCommand }
            let params = [
                CommandLog.CommandParameter(parameterName: "level", value: command.values[0])
            ]
            return CommandLog(title: "Set Grey Level", parameters: params, commandId: command.commandId)
            
        case .shift:
            guard command.values.count == 2 else { return invalidCommand }
            let params = [
                CommandLog.CommandParameter(parameterName: "x", value: command.values[0]),
                CommandLog.CommandParameter(parameterName: "y", value: command.values[1])
            ]
            return CommandLog(title: "Set Shift Offset", parameters: params, commandId: command.commandId)
            
        case .color:
            guard command.values.count == 1 else { return invalidCommand }
            let params = [
                CommandLog.CommandParameter(parameterName: "color", value: command.values[0])
            ]
            return CommandLog(title: "Set Color", parameters: params, commandId: command.commandId)
            
        default:
            return CommandLog(title: "Unknown Command", parameters: [], commandId: command.commandId)
        }
    }
}
