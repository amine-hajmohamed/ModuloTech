//
//  DeviceControlViewModel.swift
//  ModuloTech
//
//  Created by Mohamed Amine HAJ MOHAMED on 05/12/2021.
//

import RxSwift

class DeviceControlViewModel {
    
    // MARK: - Properties
    
    private let nameSubject = BehaviorSubject<String>(value: "")
    var nameObservable: Observable<String> { nameSubject.asObserver() }
    
    private let valueSubject = BehaviorSubject<Float>(value: 0)
    var valueObservable: Observable<Float> { valueSubject.asObserver() }
    
    private let modeSubject = BehaviorSubject<Bool?>(value: nil)
    var modeObservable: Observable<Bool?> { modeSubject.asObserver() }
    
    private let device: Device
    var deviceType: DeviceType? { device.getType() }
    
    // MARK: - UseCases
    
    private let deviceUseCase: DeviceUseCase
    
    // MARK: - Initializer
    
    init(device: Device, deviceUseCase: DeviceUseCase) {
        self.device = device
        self.deviceUseCase = deviceUseCase
        setupDeviceViewModel(device)
    }
    
    // MARK: - View model
    
    private func setupDeviceViewModel(_ device: Device) {
        nameSubject.onNext(device.name)
        
        switch device {
        case let light as Light:
            modeSubject.onNext(light.mode)
            valueSubject.onNext(Float(light.intensity))
            
        case let rollerShutter as RollerShutter:
            valueSubject.onNext(Float(rollerShutter.position))
            
        case let heater as Heater:
            modeSubject.onNext(heater.mode)
            valueSubject.onNext(heater.temperature)
            
        default:
            break
        }
    }
    
    // MARK: - Events
    
    func onValueChanged(_ value: Float) {
        if let currentValue = try? valueSubject.value(), currentValue == value {
            return
        }
        
        valueSubject.onNext(value)
        deviceUseCase.updateDevice(device, value: value)
    }
    
    func onTurnOnOffTapped() {
        let currentMode = (try? modeSubject.value()) ?? true
        let newMode = !currentMode
        modeSubject.onNext(newMode)
        deviceUseCase.updateDevice(device, mode: newMode)
    }
}
