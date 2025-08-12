//
//  LogView.swift
//  ActiveLookSimulator
//
//  Created by Benjamin Szakal on 12/08/2025.
//

import SwiftUI
import Combine

struct LogView: View {
    
    @ObservedObject var viewModel: LogViewModel
    
    var body: some View {
        VStack {
            headerView
            commandLogs
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Command Logs")
            Spacer()
            Button("Clear") {
                
            }
        }
    }
    
    private var commandLogs: some View {
        ScrollView {
            VStack {
                ForEach(viewModel.logs) { log in
                    Text(log.title)
                }
            }
        }
        .background(Color.black)
    }
}

#Preview {
    
    let activeLookGlassesSimulatorImpl = ActiveLookGlassesSimulatorImpl(bluetoothService: BluetoothServiceImpl(peripheralManager: DrawingView.PreviewPeripheralManager()))
    
    let manager = SimulatorManagerImpl(dataInterpreter: DataInterpreterImpl(), activeLookSimulator: activeLookGlassesSimulatorImpl)
    
    let logViewModel = LogViewModel(manager: manager, converter: DrawingCommandConverter())
    
    LogView(viewModel: logViewModel)
}
