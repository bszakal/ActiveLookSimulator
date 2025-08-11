//
//  ActiveLookSimulatorMacOSApp.swift
//  ActiveLookSimulatorMacOS
//
//  Created by Benjamin Szakal on 11/08/2025.
//

import SwiftUI
import CoreBluetooth

@main
struct ActiveLookSimulatorMacOSApp: App {
    
    let manager = SimulatorManagerImpl(dataInterpreter: DataInterpreterImpl(), activeLookSimulator: ActiveLookGlassesSimulatorImpl(bluetoothService: BluetoothServiceImpl(peripheralManager: CBPeripheralManager())))
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
