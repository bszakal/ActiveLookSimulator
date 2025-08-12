//
//  ContextDrawer.swift
//  ActiveLookSimulator
//
//  Created by Benjamin Szakal on 12/08/2025.
//

import Foundation
import SwiftUI

protocol ContextDrawer {
    func drawOnContext(_ context: inout GraphicsContext, commandType: DrawingCommand.CommandType, color: Color, shift: CGSize)
}

struct ContextDrawerImpl: ContextDrawer {
    public func drawOnContext(_ context: inout GraphicsContext, commandType: DrawingCommand.CommandType, color: Color, shift: CGSize) {
        context.translateBy(x: shift.width, y: shift.height)
        switch commandType {
        case .circle(let center, let radius):
            let path = Path { path in
                path.addEllipse(in: CGRect(
                    x: center.x - radius,
                    y: center.y - radius,
                    width: (radius-1) * 2,
                    height: (radius-1) * 2
                ))
            }
            context.stroke(path, with: .color(color), lineWidth: 2)
            
        case .rectangle(let topLeft, let bottomRight):
            let rect = CGRect(
                x: topLeft.x + 1,
                y: topLeft.y + 1,
                width: (bottomRight.x - topLeft.x) - 1,
                height: (bottomRight.y - topLeft.y) - 1
            )
            let path = Path(rect)
            context.stroke(path, with: .color(color), lineWidth: 2)
            
        case .text(let position, let text, let rotation, let fontSize, let textcolor):
            
            let swiftUIColor = Color(hex: Constants.yellowGreyLevels[textcolor] ?? "#000000") ?? Color.black
            let swiftSize = Font.system(size: CGFloat(Constants.fontSize(for: fontSize)))
            
            guard let textRotation = TextRotation(rawValue: rotation) else {
                return
            }
            
            
            let angle = textRotation.rotationDegrees
            
            if textRotation.isLeftToRight || angle != 0 {
                context.translateBy(x: position.x, y: position.y)
            }
            
            if textRotation.isLeftToRight == false {
                context.scaleBy(x: -1, y: 1)
            }
            
            context.rotate(by: Angle(degrees: textRotation.rotationDegrees))
            
            context.draw(Text(text).font(swiftSize).foregroundColor(swiftUIColor),
                         at: textRotation.rotationDegrees == 0 ? position : .zero,
                         anchor: .center)
            
        case .filledCircle(let center, let radius):
            let path = Path { path in
                path.addEllipse(in: CGRect(
                    x: center.x - radius,
                    y: center.y - radius,
                    width: radius * 2,
                    height: radius * 2
                ))
            }
            context.fill(path, with: .color(color))
            
        case .filledRectangle(let topLeft, let bottomRight):
            let rect = CGRect(
                x: topLeft.x,
                y: topLeft.y,
                width: bottomRight.x - topLeft.x,
                height: bottomRight.y - topLeft.y
            )
            let path = Path(rect)
            context.fill(path, with: .color(color))
            
        case .point(let position):
            let path = Path { path in
                path.addRect(CGRect(x: position.x, y: position.y, width: 1, height: 1))
            }
            context.fill(path, with: .color(color))
            
        case .line(let start, let end):
            let path = Path { path in
                path.move(to: start)
                path.addLine(to: end)
            }
            context.stroke(path, with: .color(color), lineWidth: 2)
            
        case .setGreyLevel(_):
            // State command - handled by view model, no direct drawing
            break
            
        case .setShift(_):
            // State command - handled by view model, no direct drawing
            break
            
        case .setColor(_):
            // State command - handled by view model, no direct drawing
            break
        }
    }
}
