//
//  DeviceUseCase.swift
//  ModuloTech
//
//  Created by Mohamed Amine HAJ MOHAMED on 02/12/2021.
//

import RxSwift

class DeviceUseCase {
    
    // MARK: - Providers
    
    private let memoryCacheProvider: MemoryCacheProvider
    
    // MARK: - Initializer
    
    init(memoryCacheProvider: MemoryCacheProvider) {
        self.memoryCacheProvider = memoryCacheProvider
    }
    
    // MARK: - UseCases
    
    lazy var devicesObservable: Observable<[Device]> = memoryCacheProvider.devices.asObserver()
    
    func updateDevice(_ device: Device, value: Float) {
        switch device {
        case let light as Light:
            light.intensity = Int(value)
            
        case let rollerShutter as RollerShutter:
            rollerShutter.position = Int(value)
            
        case let heater as Heater:
            heater.temperature = value
            
        default:
            break
        }
        
        refreshDevicesList()
    }
    
    func updateDevice(_ device: Device, mode: Bool) {
        switch device {
        case let light as Light:
            light.mode = mode
            
        case let heater as Heater:
            heater.mode = mode
            
        default:
            break
        }
        
        refreshDevicesList()
    }
    
    
    private func refreshDevicesList() {
        let devices = (try? memoryCacheProvider.devices.value()) ?? []
        memoryCacheProvider.devices.onNext(devices)
    }
}
