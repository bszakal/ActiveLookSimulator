//
//  LogViewModel.swift
//  ActiveLookSimulator
//
//  Created by Benjamin Szakal on 12/08/2025.
//

import Foundation
import Combine

class LogViewModel: ObservableObject {
    
    let manager: SimulatorManager
    let converter: DrawingCommandConverter
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published var logs: [CommandLog] = []
    
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
            .store(in: &cancellables)
    }
    
    private func handleCommand(_ command: DecodedCommand) {
        let log = self.converter.convertCommandToLog(command)
        
        if self.logs.isEmpty {
            self.logs.append(log)
        } else {
            self.logs.insert(log, at: 0)
        }
    }
}
