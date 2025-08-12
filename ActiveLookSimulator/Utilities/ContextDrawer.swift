//
//  ContextDrawer.swift
//  ActiveLookSimulator
//
//  Created by Benjamin Szakal on 12/08/2025.
//

import Foundation
import SwiftUI

protocol ContextDrawer {
    func drawOnContext(_ context: inout GraphicsContext, commandType: DrawingCommand.CommandType, color: Color)
}

struct ContextDrawerImpl: ContextDrawer {
    public func drawOnContext(_ context: inout GraphicsContext, commandType: DrawingCommand.CommandType, color: Color) {
        switch commandType {
        case .circle(let center, let radius):
            let path = Path { path in
                path.addEllipse(in: CGRect(
                    x: center.x - radius,
                    y: center.y - radius,
                    width: radius * 2,
                    height: radius * 2
                ))
            }
            context.stroke(path, with: .color(color), lineWidth: 2)
            
        case .rectangle(let topLeft, let bottomRight):
            let rect = CGRect(
                x: topLeft.x,
                y: topLeft.y,
                width: bottomRight.x - topLeft.x,
                height: bottomRight.y - topLeft.y
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
        }
    }
}
