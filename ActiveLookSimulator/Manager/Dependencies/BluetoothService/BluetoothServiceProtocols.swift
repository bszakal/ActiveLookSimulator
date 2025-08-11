//
//  BluetoothServiceProtocols.swift
//  ActiveLookSimulator
//
//  Created by Benjamin Szakal on 11/08/2025.
//
import CoreBluetooth

protocol BluetoothServiceDelegate: AnyObject {
    func handleBluetoothStateChanged(_ state: CBManagerState)
    func handleWriteRequests(_ requests: [CBATTRequest]) throws
}

protocol BluetoothService: AnyObject, CBPeripheralManagerDelegate {
    func peripheralRespond(to request: CBATTRequest, withResult result: CBATTError.Code)
    func startAdvertising(values: [String: Any])
    func add(_ service: CBMutableService)
    func updateValue(_ data: Data, for characteristic: CBMutableCharacteristic, onSubscribedCentrals: [CBCentral]?)
    var delegate: BluetoothServiceDelegate? { get set }
}

protocol CBPeripheralManagerProtocol where Self: CBPeripheralManager {}
extension CBPeripheralManager: CBPeripheralManagerProtocol {}
