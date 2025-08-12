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
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published var drawingCommands: [DrawingCommand] = []
    private(set) var color = Color(hex: Constants.yellowGreyLevels[8] ?? "#000000") ?? Color.black
    
    init(manager: SimulatorManager, converter: DrawingCommandConverter) {
        self.manager = manager
        self.converter = converter
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
