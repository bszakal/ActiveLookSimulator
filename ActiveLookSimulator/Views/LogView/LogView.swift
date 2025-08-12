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
            Text("System Logs")
                .font(.headline)
                .foregroundColor(.black)
            Spacer()
            Button("Clear") {
                viewModel.clearLogs()
            }
            .foregroundColor(.blue)
        }
        .padding(.horizontal)
        .padding(.top)
    }
    
    private var commandLogs: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 4) {
                ForEach(viewModel.logs) { log in
                    logEntry(log)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
        }
        .background(Color.black)
        .cornerRadius(10)
        .padding(.horizontal)
    }
    
    private func logEntry(_ log: CommandLog) -> some View {
        HStack(alignment: .top, spacing: 0) {
            Text("[\(log.formattedTimestamp)] ")
                .foregroundColor(.green)
                .font(.system(size: 12))
            
            VStack(alignment: .leading, spacing: 2) {
                Text(log.title)
                    .foregroundColor(.green)
                    .font(.system(size: 12))
                
                if !log.parameters.isEmpty {
                    Text(log.parametersString)
                        .foregroundColor(.green.opacity(0.8))
                        .font(.system(size: 11))
                }
            }
            
            Spacer()
        }
    }
}

#Preview {
    
    let activeLookGlassesSimulatorImpl = ActiveLookGlassesSimulatorImpl(bluetoothService: BluetoothServiceImpl(peripheralManager: DrawingView.PreviewPeripheralManager()))
    
    let manager = SimulatorManagerImpl(dataInterpreter: DataInterpreterImpl(), activeLookSimulator: activeLookGlassesSimulatorImpl)
    
    let logViewModel = LogViewModel(manager: manager, converter: DrawingCommandConverter())
    
    LogView(viewModel: logViewModel)
}
