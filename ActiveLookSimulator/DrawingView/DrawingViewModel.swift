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
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published var drawingCommands: [DrawingCommand] = []
    private(set) var color = Constants.yellowGreyLevels[8]
    
    init(manager: SimulatorManager) {
        self.manager = manager
    }
    
    private func subscriptions() {
        self.manager.decodedCommand
            .sink {[weak self] command in
                self?.handleCommand(command)
            }
            .store(in: &self.cancellables)
    }
    
    private func handleCommand(_ command: DecodedCommand) {
        guard let drawingCommand = self.convertCommandToDrawingCommand(command) else {
            return
        }
        drawingCommands.append(drawingCommand)
    }
    
    private func convertCommandToDrawingCommand(_ command: DecodedCommand) -> DrawingCommand? {
        switch command.commandId {
        case .circ:
            guard command.values.count == 3 else {
                return nil
            }
            let cgFloatValues = command.values.map { CGFloat($0) }
            return .circle(center: .init(x: cgFloatValues[0], y: cgFloatValues[1]), radius: cgFloatValues[2])
        default:
            return nil
        }
    }
}
