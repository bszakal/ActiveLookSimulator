//
//  PreviewSimulatorManager.swift
//  ActiveLookSimulator
//
//  Created by Benjamin Szakal on 12/08/2025.
//

import Foundation
import Combine

class PreviewSimulatorManager: SimulatorManager {
    
    var decodedCommand_ = PassthroughSubject<DecodedCommand, Never>()
    var decodedCommand: AnyPublisher<DecodedCommand, Never> {
        decodedCommand_.eraseToAnyPublisher()
    }
    
    init() {}
    
}
