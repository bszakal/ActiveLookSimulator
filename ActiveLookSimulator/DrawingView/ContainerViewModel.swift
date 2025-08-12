//
//  ContainerViewModel.swift
//  ActiveLookSimulator
//
//  Created by Benjamin Szakal on 12/08/2025.
//

import Foundation
import CoreBluetooth

class ContainerViewModel: ObservableObject {
    
    let manager: SimulatorManager
    let drawingViewModel: DrawingViewModel
    let logViewModel: LogViewModel
    
    init() {
        let activeLookGlassesSimulatorImpl = ActiveLookGlassesSimulatorImpl(bluetoothService: BluetoothServiceImpl(peripheralManager: CBPeripheralManager()))
        let commandConverter = DrawingCommandConverter()
        
        let manager = SimulatorManagerImpl(dataInterpreter: DataInterpreterImpl(),
                                           activeLookSimulator: activeLookGlassesSimulatorImpl)
        let drawingViewModel = DrawingViewModel(manager: manager, converter: commandConverter)
        let logViewModel = LogViewModel(manager: manager, converter: commandConverter)
        
        self.manager = manager
        self.drawingViewModel = drawingViewModel
        self.logViewModel = logViewModel
    }
    
}
