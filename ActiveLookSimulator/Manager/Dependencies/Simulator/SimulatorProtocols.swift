//
//  SimulatorProtocols.swift
//  ActiveLookSimulator
//
//  Created by Benjamin Szakal on 11/08/2025.
//
import CoreBluetooth
import Combine

protocol ActiveLookGlassesSimulatorDelegate: AnyObject {
    func handleCommand(data: Data?) -> CBATTError.Code
}

protocol ActiveLookGlassesSimulator: AnyObject {
    func startSimulator() throws
    var delegate: ActiveLookGlassesSimulatorDelegate? { get set }
    var bluetoothState: AnyPublisher<CBManagerState, Never> { get }
}
