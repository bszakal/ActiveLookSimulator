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
        VStack {
            headerView
                .clipShape(RoundedRectangle(cornerRadius: 10))
            drawingView
        }
        .frame(width: 500, height: 400)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("ActiveLook Display")
                .font(.headline)
                .foregroundColor(.black)
            Spacer()
        }
        .padding()
    }
    
    private var drawingView: some View {
        ZStack {
            Canvas { context, size in
                for command in viewModel.drawingCommands {
                    viewModel.contextDrawer(&context, command: command)
                }
            }
        }
        .frame(width: 304, height: 256)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.black)
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
