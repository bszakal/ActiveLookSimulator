//
//  ActiveLookGlassesSimulator.swift
//  ActiveLookSimulator
//
//  Created by Benjamin Szakal on 08/08/2025.
//


import CoreBluetooth
import Foundation
import Combine


class ActiveLookGlassesSimulatorImpl: ActiveLookGlassesSimulator {
    
    private let bluetoothService: BluetoothService
    private var services: Services
    weak var delegate: ActiveLookGlassesSimulatorDelegate?
    
    private var bluetoothState_ = CurrentValueSubject<CBManagerState, Never>(.unknown)
    public var bluetoothState: AnyPublisher<CBManagerState, Never> {
        bluetoothState_.eraseToAnyPublisher()
    }
    
    init(bluetoothService: BluetoothService) {
        self.bluetoothService = bluetoothService
        self.services = Services()
        self.bluetoothService.delegate = self
    }
    
    public func startSimulator() throws {
        switch bluetoothState_.value {
        case .poweredOn:
            setupServices()
            startAdvertising()
        default:
            throw(SimulatorError.bluetoothNotAvailable)
        }
    }
    
    private func setupServices () {
        self.bluetoothService.add(services.activeLookService)
        self.bluetoothService.add(services.batteryService)
    }
    
    private func startAdvertising() {
        self.bluetoothService.startAdvertising(values: ActiveLookGlassesSimulatorImpl.advertisementData)
    }
}

extension ActiveLookGlassesSimulatorImpl: BluetoothServiceDelegate {
    func handleBluetoothStateChanged(_ state: CBManagerState) {
        self.bluetoothState_.send(state)
    }
    
    func handleWriteRequests(_ requests: [CBATTRequest]) {
        for request in requests {
            if request.characteristic.uuid == services.rxCharacteristic.uuid {
                let result = delegate?.handleCommand(data: request.value)
                self.bluetoothService.peripheralRespond(to: request, withResult: result ?? .unlikelyError)
            }
        }
    }
}

extension ActiveLookGlassesSimulatorImpl {
    enum SimulatorError: Error {
        case bluetoothNotAvailable
    }
}

extension ActiveLookGlassesSimulatorImpl {
    
    static let advertisementData: [String: Any] = [
        CBAdvertisementDataLocalNameKey: "ActiveLook Glasses",
        CBAdvertisementDataServiceUUIDsKey: [
            CBUUID(string: "0783b03e-8535-b5a0-7140-a304d2495cb7"),
        ]
    ]
    
    struct Services {
        //Services
        let activeLookService: CBMutableService
        let batteryService: CBMutableService
        
        // Characteristics
        let txCharacteristic: CBMutableCharacteristic
        let rxCharacteristic: CBMutableCharacteristic
        let flowControlCharacteristic: CBMutableCharacteristic
        let batteryLevelCharacteristic: CBMutableCharacteristic
        let sensorCharacteristic: CBMutableCharacteristic
        
        init() {
            //| ActiveLook Commands Interface Service
            activeLookService = CBMutableService(type: CBUUID(string: "0783b03e-8535-b5a0-7140-a304d2495cb7"),
                                                 primary: true)
            
            // TX Characteristic (glasses → phone)
            txCharacteristic = CBMutableCharacteristic(type: CBUUID(string: "0783b03e-8535-b5a0-7140-a304d2495cb8"),
                                                       properties: [.notify, .read],
                                                       value: nil,
                                                       permissions: [.readable])
            
            // RX Characteristic (phone → glasses)
            rxCharacteristic = CBMutableCharacteristic(type: CBUUID(string: "0783b03e-8535-b5a0-7140-a304d2495cba"),
                                                       properties: [.write, .writeWithoutResponse],
                                                       value: nil,
                                                       permissions: [.writeable])
            
            // Flow Control Characteristic
            flowControlCharacteristic = CBMutableCharacteristic(type: CBUUID(string: "0783b03e-8535-b5a0-7140-a304d2495cb9"),
                                                                properties: [.read, .notify],
                                                                value: nil,
                                                                permissions: [.readable])
            
            //Sensor Characteristic
            sensorCharacteristic = CBMutableCharacteristic(type: CBUUID(string: "0783b03e-8535-b5a0-7140-a304d2495cbb"),
                                                           properties: [.read],
                                                           value: nil,
                                                           permissions: [.readable])
            
            activeLookService.characteristics = [txCharacteristic, rxCharacteristic, flowControlCharacteristic, sensorCharacteristic]
            
            // Battery Service
            batteryService = CBMutableService(type: CBUUID(string: "0000180f-0000-1000-8000-00805f9b34fb"),
                                              primary: true)
            
            batteryLevelCharacteristic = CBMutableCharacteristic(type: CBUUID(string: "00002a19-0000-1000-8000-00805f9b34fb"),
                                                                 properties: [.read, .notify],
                                                                 value: nil,
                                                                 permissions: [.readable])
            
            batteryService.characteristics = [batteryLevelCharacteristic]
        }
    }
}

