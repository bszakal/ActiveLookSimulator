//
//  ContentView.swift
//  ActiveLookSimulator
//
//  Created by Benjamin Szakal on 08/08/2025.
//

import SwiftUI

struct ContainerView: View {
    
    @StateObject var viewModel = ContainerViewModel()
    
    var body: some View {
        
        HStack(spacing: 30) {
            DrawingView(viewModel: viewModel.drawingViewModel)
            LogView(viewModel: viewModel.logViewModel)
        }
        
    }
}

#Preview {
    ContainerView()
}
