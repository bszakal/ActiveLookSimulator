//
//  ActiveLookSimulatorApp.swift
//  ActiveLookSimulator
//
//  Created by Benjamin Szakal on 08/08/2025.
//

import SwiftUI
import CoreBluetooth

@main
struct ActiveLookSimulatorApp: App {
    let manager = SimulatorManagerImpl(dataInterpreter: DataInterpreterImpl(), activeLookSimulator: ActiveLookGlassesSimulatorImpl(bluetoothService: BluetoothServiceImpl(peripheralManager: CBPeripheralManager())))
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
