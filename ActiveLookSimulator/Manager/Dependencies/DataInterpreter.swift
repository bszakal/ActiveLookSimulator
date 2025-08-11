//
//  DataInterpreter.swift
//  ActiveLookSimulator
//
//  Created by Benjamin Szakal on 10/08/2025.
//

import Foundation

protocol DataInterpreter {
    func decodeCommand(from data: Data) -> DecodedCommand?
}

struct DataInterpreterImpl: DataInterpreter {

    public func decodeCommand(from data: Data) -> DecodedCommand? {
        // Need at least: header + cmdId + cmdFormat + length(1 or 2 bytes) + footer
        guard data.count >= 5 else { return nil }
        
        var offset = 0
        
        // Header check
        guard data[offset] == 0xFF else { return nil }
        offset += 1
        
        // Command ID
        let commandId = data[offset]
        offset += 1
        
        // Command Format
        let commandFormat = data[offset]
        offset += 1
        
        // Determine length (total frame length)
        let isTwoByteLength = (commandFormat & 0x10) != 0
        let length: Int
        if isTwoByteLength {
            guard offset + 2 <= data.count else { return nil }
            length = Int(UInt16(data[offset]) << 8 | UInt16(data[offset + 1]))
            offset += 2
        } else {
            guard offset + 1 <= data.count else { return nil }
            length = Int(data[offset])
            offset += 1
        }
        
        // Now we can ensure we have the entire packet
        guard data.count >= length else { return nil }
        
        // Check if query ID is present
        let hasQueryId = (commandFormat & 0x01) != 0
        var queryId: UInt8? = nil
        if hasQueryId {
            guard offset < length else { return nil }
            queryId = data[offset]
            offset += 1
        }
        
        // Footer should be at end of declared length
        let footerIndex = length - 1
        guard data[footerIndex] == 0xAA else { return nil }
        
        // Extract payload values (from after queryId up to before footer)
        let payload = Array(data[offset..<footerIndex])
        
        return DecodedCommand(commandId: CommandId(rawValue: commandId) ?? .unknown, values: payload, queryId: queryId)
    }
}
