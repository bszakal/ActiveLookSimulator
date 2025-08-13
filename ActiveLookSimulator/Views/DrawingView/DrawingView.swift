//
//  DrawingView.swift
//  ActiveLookSimulator
//
//  Created by Benjamin Szakal on 12/08/2025.
//

import SwiftUI

struct DrawingView: View {
    
    @ObservedObject var viewModel: DrawingViewModel
    
    var body: some View {
        VStack(spacing: 16) {
            headerView
            Spacer()
            displayArea
            Spacer()
            bottomView
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
    }
    
    private var headerView: some View {
        HStack {
            HStack(alignment: .firstTextBaseline, spacing: 3) {
                Text("ActiveLook")
                    .font(.title)
                    .bold()
                Text("Simulator")
                    .font(.subheadline)
                    .fontWeight(.semibold)
            }
            .foregroundColor(.black)

            Spacer()
            
            HStack(spacing: 12) {
                Button("Clear") {
                    viewModel.clearDrawings()
                }
                .foregroundColor(.blue)
            }
        }
    }
    
    private var displayArea: some View {
        ZStack {
            
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.black)
                .frame(width: 304, height: 256)
            
            
            ForEach(viewModel.drawingCommands) { command in
                Canvas { context, size in
                    viewModel.contextDrawer(&context, command: command)
                }
                .frame(width: 304, height: 256)
            }
            
            if viewModel.drawingCommands.isEmpty {
                Text("Awaiting Commands")
                    .foregroundColor(.gray)
                    .font(.system(size: 14, weight: .medium))
                    .padding(.top, 8)
            }
        }
        .cornerRadius(10)
    }
    
    private var bottomView: some View {
        HStack(spacing: 20) {
            statusBox(title: "Resolution", value: "304 x 256")
            
            let isBluetoothActive = viewModel.isBluetoothActive
            statusBox(title: "Bluetooth", value: isBluetoothActive ? "Active" : "Inactive", valueColor: isBluetoothActive ? .green : .red)
        }
    }
    
    private func statusBox(title: String, value: String, valueColor: Color = .black) -> some View {
        VStack(alignment: .center, spacing: 4) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.black)
            Text(value)
                .font(.system(size: 14))
                .foregroundColor(valueColor)
        }
        .padding(.vertical)
        .frame(maxWidth: .infinity, alignment: .center)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(Color.gray.opacity(0.1))
        }
        
    }
}

#Preview {
    let activeLookGlassesSimulatorImpl = ActiveLookGlassesSimulatorImpl(bluetoothService: BluetoothServiceImpl(peripheralManager: DrawingView.PreviewPeripheralManager()))
    
    let manager = SimulatorManagerImpl(dataInterpreter: DataInterpreterImpl(),
                                       activeLookSimulator: activeLookGlassesSimulatorImpl)
    
    let drawingViewModel = DrawingViewModel(manager: manager,
                                            converter: DrawingCommandConverter(),
                                            contextDrawer: ContextDrawerImpl())
    
    DrawingView(viewModel: drawingViewModel)
}
