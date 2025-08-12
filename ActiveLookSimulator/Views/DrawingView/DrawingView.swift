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
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.black)
                .frame(width: 304, height: 256)
            
            Canvas { context, size in
                for command in viewModel.drawingCommands {
                    switch command.commandType {
                    case .circle(let center, let radius):
                        let path = Path { path in
                            path.addEllipse(in: CGRect(
                                x: center.x - radius,
                                y: center.y - radius,
                                width: radius * 2,
                                height: radius * 2
                            ))
                        }
                        context.stroke(path, with: .color(viewModel.color), lineWidth: 2)
                        
                    case .rectangle(let topLeft, let bottomRight):
                        let rect = CGRect(
                            x: topLeft.x,
                            y: topLeft.y,
                            width: bottomRight.x - topLeft.x,
                            height: bottomRight.y - topLeft.y
                        )
                        let path = Path(rect)
                        context.stroke(path, with: .color(viewModel.color), lineWidth: 2)
                    }
                }
            }
            .frame(width: 304, height: 256)
        }
    }
}

#Preview {
    let activeLookGlassesSimulatorImpl = ActiveLookGlassesSimulatorImpl(bluetoothService: BluetoothServiceImpl(peripheralManager: DrawingView.PreviewPeripheralManager()))
    
    let manager = SimulatorManagerImpl(dataInterpreter: DataInterpreterImpl(),
                                       activeLookSimulator: activeLookGlassesSimulatorImpl)
    let drawingViewModel = DrawingViewModel(manager: manager, converter: DrawingCommandConverter())
    
    DrawingView(viewModel: drawingViewModel)
}
