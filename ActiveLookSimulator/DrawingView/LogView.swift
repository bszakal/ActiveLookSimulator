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
        VStack {
            ForEach(viewModel.logs) { log in
                Text(log.title)
            }
        }
    }
}

#Preview {
    
    let activeLookGlassesSimulatorImpl = ActiveLookGlassesSimulatorImpl(bluetoothService: BluetoothServiceImpl(peripheralManager: DrawingView.PreviewPeripheralManager()))
    
    let manager = PreviewSimulatorManager()
    
    let logViewModel = LogViewModel(manager: manager, converter: DrawingCommandConverter())
    
    let _ = manager.decodedCommand_.send(DecodedCommand(commandId: .circ, values: [30,50,10], queryId: 2))
    
    LogView(viewModel: logViewModel)
}
