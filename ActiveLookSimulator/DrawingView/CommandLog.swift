//
//  CommandLog.swift
//  ActiveLookSimulator
//
//  Created by Benjamin Szakal on 12/08/2025.
//

import Foundation

struct CommandLog: Identifiable {
    let id: UUID = UUID()
    let title: String
    let parameters: [CommandParameter]
    let commandId: CommandId
    
    struct CommandParameter {
        let parameterName: String
        let value: Any
    }
}
