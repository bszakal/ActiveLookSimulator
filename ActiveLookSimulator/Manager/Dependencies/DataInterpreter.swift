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
    
    private func extractTextFromBytes(commandId: CommandId, rawBytes: [UInt8]) -> String? {
        switch commandId {
        case .txt:
            // Extract string from bytes 7 onwards (after x, y, r, f, c)
            guard rawBytes.count > 7 else { return nil }
            let textBytes = Array(rawBytes[7...])
            return String(bytes: textBytes, encoding: .utf8)
        default:
            return nil
        }
    }
    
    private func parseCommandParameters(commandId: CommandId, rawBytes: [UInt8]) -> [Int] {
        switch commandId {
        case .circ, .circf:
            // s16 x, s16 y, u8 r (5 bytes -> 3 values)
            guard rawBytes.count == 5 else { return rawBytes.map { Int($0) } }
            let x = Int(rawBytes[0]) << 8 | Int(rawBytes[1])
            let y = Int(rawBytes[2]) << 8 | Int(rawBytes[3])
            let r = Int(rawBytes[4])
            return [x, y, r]
            
        case .point:
            // s16 x, s16 y (4 bytes -> 2 values)
            guard rawBytes.count == 4 else { return rawBytes.map { Int($0) } }
            let x = Int(rawBytes[0]) << 8 | Int(rawBytes[1])
            let y = Int(rawBytes[2]) << 8 | Int(rawBytes[3])
            return [x, y]
            
        case .rect, .rectf, .line:
            // s16 x0, s16 y0, s16 x1, s16 y1 (8 bytes -> 4 values)
            guard rawBytes.count == 8 else { return rawBytes.map { Int($0) } }
            let x0 = Int(rawBytes[0]) << 8 | Int(rawBytes[1])
            let y0 = Int(rawBytes[2]) << 8 | Int(rawBytes[3])
            let x1 = Int(rawBytes[4]) << 8 | Int(rawBytes[5])
            let y1 = Int(rawBytes[6]) << 8 | Int(rawBytes[7])
            return [x0, y0, x1, y1]
            
        case .txt:
            // s16 x, s16 y, u8 r, u8 f, u8 c, str string (min 6 bytes -> 5 values + string)
            guard rawBytes.count >= 6 else { return rawBytes.map { Int($0) } }
            let x = Int(rawBytes[0]) << 8 | Int(rawBytes[1])
            let y = Int(rawBytes[2]) << 8 | Int(rawBytes[3])
            let r = Int(rawBytes[4])  // rotation
            let f = Int(rawBytes[5])  // font size
            let c = Int(rawBytes[6])  // color
            return [x, y, r, f, c]
            
        case .grey:
            // u8 lvl (1 byte -> 1 value)
            guard rawBytes.count == 1 else { return rawBytes.map { Int($0) } }
            return [Int(rawBytes[0])]
            
        case .shift:
            // s16 x, s16 y (4 bytes -> 2 values)
            guard rawBytes.count == 4 else { return rawBytes.map { Int($0) } }
            let x = Int(rawBytes[0]) << 8 | Int(rawBytes[1])
            let y = Int(rawBytes[2]) << 8 | Int(rawBytes[3])
            return [x, y]
            
        case .color:
            // u8 color (1 byte -> 1 value)
            guard rawBytes.count == 1 else { return rawBytes.map { Int($0) } }
            return [Int(rawBytes[0])]
            
        case .circf:
            // s16 x, s16 y, u8 r (5 bytes -> 3 values) - same as .circ
            guard rawBytes.count == 5 else { return rawBytes.map { Int($0) } }
            let x = Int(rawBytes[0]) << 8 | Int(rawBytes[1])
            let y = Int(rawBytes[2]) << 8 | Int(rawBytes[3])
            let r = Int(rawBytes[4])
            return [x, y, r]
            
        case .rectf:
            // s16 x0, s16 y0, s16 x1, s16 y1 (8 bytes -> 4 values) - same as .rect
            guard rawBytes.count == 8 else { return rawBytes.map { Int($0) } }
            let x0 = Int(rawBytes[0]) << 8 | Int(rawBytes[1])
            let y0 = Int(rawBytes[2]) << 8 | Int(rawBytes[3])
            let x1 = Int(rawBytes[4]) << 8 | Int(rawBytes[5])
            let y1 = Int(rawBytes[6]) << 8 | Int(rawBytes[7])
            return [x0, y0, x1, y1]
            
        default:
            // For other commands, just return raw bytes as Int values
            return rawBytes.map { Int($0) }
        }
    }

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
        
        // Extract payload values (actual command parameters only)
        let lengthBytes = isTwoByteLength ? 2 : 1
        let queryIdBytes = hasQueryId ? 1 : 0
        let fixedBytes = 1 + 1 + 1 + lengthBytes + queryIdBytes + 1 // header + cmdId + cmdFormat + length + queryId + footer
        let expectedDataSize = length - fixedBytes
        let parameterEndIndex = offset + expectedDataSize
        let rawPayload = Array(data[offset..<parameterEndIndex])
        
        // Parse raw bytes into proper parameter values based on command type
        let commandIdEnum = CommandId(rawValue: commandId) ?? .unknown
        let payload = parseCommandParameters(commandId: commandIdEnum, rawBytes: rawPayload)
        let textValue = extractTextFromBytes(commandId: commandIdEnum, rawBytes: rawPayload)
        
        return DecodedCommand(commandId: commandIdEnum, values: payload, textValue: textValue, queryId: queryId)
    }
}
