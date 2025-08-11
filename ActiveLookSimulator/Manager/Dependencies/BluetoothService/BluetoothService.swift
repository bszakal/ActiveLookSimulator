//
//  BluetoothService.swift
//  ActiveLookSimulator
//
//  Created by Benjamin Szakal on 11/08/2025.
//

import Foundation
import CoreBluetooth
import Combine

class BluetoothServiceImpl: NSObject, BluetoothService {
    
    private var peripheralManager: CBPeripheralManagerProtocol
    weak var delegate: BluetoothServiceDelegate?
    
    init(peripheralManager: CBPeripheralManagerProtocol) {
        self.peripheralManager = peripheralManager
        super.init()
        self.peripheralManager.delegate = self
        self.delegate?.handleBluetoothStateChanged(peripheralManager.state)
    }
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        self.delegate?.handleBluetoothStateChanged(peripheral.state)
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest])  {
        try? self.delegate?.handleWriteRequests(requests)
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveRead request: CBATTRequest) {
        peripheralRespond(to: request, withResult: .success)
        //only implemented so the SDK doesn't crash when trying to ready the batterie value when connecting to the simulator
    }
    
    func peripheralRespond(to request: CBATTRequest, withResult result: CBATTError.Code) {
        peripheralManager.respond(to: request, withResult: result)
    }
    
    func startAdvertising(values: [String: Any]) {
        guard peripheralManager.state == .poweredOn else { return }
        peripheralManager.startAdvertising(values)
    }
    
    func add(_ service: CBMutableService) {
        self.peripheralManager.add(service)
    }
    
    func updateValue(_ data: Data, for characteristic: CBMutableCharacteristic, onSubscribedCentrals: [CBCentral]?) {
        self.peripheralManager.updateValue(data, for: characteristic, onSubscribedCentrals: onSubscribedCentrals)
    }
}
