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
        guard let drawingCommand = self.converter.convertCommandToDrawingCommand(command) else {
            return
        }
        drawingCommands.append(drawingCommand)
    }

}

extension DrawingViewModel {
    public func contextDrawer(_ context: inout GraphicsContext, commandType: DrawingCommand.CommandType) {
        self.contextDrawer.drawOnContext(&context, commandType: commandType, color: self.color)
    }
}
