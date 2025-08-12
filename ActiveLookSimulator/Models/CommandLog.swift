//
//  CommandLog.swift
//  ActiveLookSimulator
//
//  Created by Benjamin Szakal on 12/08/2025.
//

import Foundation

struct CommandLog: Identifiable {
    let id: UUID = UUID()
    let timestamp: Date
    let title: String
    let parameters: [CommandParameter]
    let commandId: CommandId
    
    init(title: String, parameters: [CommandParameter], commandId: CommandId) {
        self.timestamp = Date()
        self.title = title
        self.parameters = parameters
        self.commandId = commandId
    }
    
    struct CommandParameter {
        let parameterName: String
        let value: Any
    }
    
    var formattedTimestamp: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter.string(from: timestamp)
    }
    
    var parametersString: String {
        parameters.map { "\($0.parameterName): \($0.value)" }.joined(separator: ", ")
    }
}
