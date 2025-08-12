//
//  GlassSimulator.swift
//  ActiveLookSimulator
//
//  Created by Benjamin Szakal on 10/08/2025.
//

import Foundation
import CoreBluetooth
import Combine


protocol SimulatorManager {
    var decodedCommand: AnyPublisher<DecodedCommand, Never> { get }
    var isBluetoothActive: AnyPublisher<Bool, Never> { get }
}

class SimulatorManagerImpl: SimulatorManager {
    
    let dataInterpreter: DataInterpreter
    let activeLookSimulator: ActiveLookGlassesSimulator
    
    private var cancellables = Set<AnyCancellable>()
    
    private var decodedCommand_ = PassthroughSubject<DecodedCommand, Never>()
    public var decodedCommand: AnyPublisher<DecodedCommand, Never> {
        decodedCommand_.eraseToAnyPublisher()
    }
    
    private var isBluetoothActive_ = CurrentValueSubject<Bool, Never>(false)
    public var isBluetoothActive: AnyPublisher<Bool, Never> {
        isBluetoothActive_.eraseToAnyPublisher()
    }
    
    init(dataInterpreter: DataInterpreter, activeLookSimulator: ActiveLookGlassesSimulator) {
        self.dataInterpreter = dataInterpreter
        self.activeLookSimulator = activeLookSimulator
        self.activeLookSimulator.delegate = self
        
        subscriptions()
    }
    
    func subscriptions() {
        self.activeLookSimulator.bluetoothState
            .removeDuplicates()
            .sink { [weak self] state in
                if state == .poweredOn {
                    self?.handleBluetoothIsConnected()
                    self?.isBluetoothActive_.send(true)
                } else {
                    self?.isBluetoothActive_.send(false)
                }
            }
            .store(in: &cancellables)
    }
    
    func handleBluetoothIsConnected() {
        do {
            try self.activeLookSimulator.startSimulator()
        } catch {
            print("failed to start simulator")
        }
    }
}

extension SimulatorManagerImpl: ActiveLookGlassesSimulatorDelegate {
    func handleCommand(data: Data?) -> CBATTError.Code {
        guard let decodedCommand = self.dataInterpreter.decodeCommand(from: data ?? Data()) else {
            return .unlikelyError
        }
        
        switch decodedCommand.commandId {
        case  .grey, .shift, .color, .point, .line, .rect, .rectf, .circ, .circf, .txt, .layoutDisplay, .layoutClear:
            self.decodedCommand_.send(decodedCommand)
            return .success
        case .clear:
            return .success
        default:
            return .unlikelyError
        }
    }
}
