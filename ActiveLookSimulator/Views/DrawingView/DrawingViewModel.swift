//
//  DrawingViewModel.swift
//  ActiveLookSimulator
//
//  Created by Benjamin Szakal on 10/08/2025.
//

import Foundation
import SwiftUI
import Combine

class DrawingViewModel: ObservableObject {
    
    let manager: SimulatorManager
    private let converter: DrawingCommandConverter
    private let contextDrawer: ContextDrawer
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published var drawingCommands: [DrawingCommand] = []
    private var shift: CGSize = CGSize(width: 0, height: 0)
    
    private(set) var color = Color(hex: Constants.yellowGreyLevels[8] ?? "#000000") ?? Color.black
    
    init(manager: SimulatorManager, converter: DrawingCommandConverter, contextDrawer: ContextDrawer) {
        self.manager = manager
        self.converter = converter
        self.contextDrawer = contextDrawer
        subscriptions()
    }
    
    private func subscriptions() {
        self.manager.decodedCommand
            .sink {[weak self] command in
                self?.handleCommand(command)
            }
            .store(in: &self.cancellables)
    }
    
    private func handleCommand(_ command: DecodedCommand) {
        guard var drawingCommand = self.converter.convertCommandToDrawingCommand(command) else {
            return
        }
        drawingCommand.color = self.color
        drawingCommand.shift = self.shift
        
        switch drawingCommand.commandType{
        case .setColor(let color):
            self.color = Color(hex: Constants.yellowGreyLevels[color] ?? "#000000") ?? Color.black
        case .setGreyLevel(let level):
            self.color = Color(hex: Constants.yellowGreyLevels[level] ?? "#000000") ?? Color.black
        case .setShift(offset: let offset):
            self.shift = offset
        default:
            drawingCommands.append(drawingCommand)
        }
    }
}

extension DrawingViewModel {
    public func contextDrawer(_ context: inout GraphicsContext, command: DrawingCommand) {
        
        switch command.commandType{
        case .setColor, .setShift, .setGreyLevel:
            return
        default:
            self.contextDrawer.drawOnContext(&context, commandType: command.commandType, color: command.color ?? .black, shift: command.shift ?? .zero)
        }
    }
}
