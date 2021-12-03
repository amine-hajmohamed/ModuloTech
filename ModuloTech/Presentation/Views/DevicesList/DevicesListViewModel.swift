//
//  DevicesListViewModel.swift
//  ModuloTech
//
//  Created by Mohamed Amine HAJ MOHAMED on 02/12/2021.
//

import RxSwift

class DevicesListViewModel {
    
    // MARK: - Properties
    
    let devicesObservable: Observable<[Device]>
    
    // MARK: - UseCases
    
    private let dataUseCase: DataUseCase
    private let deviceUseCase: DeviceUseCase
    
    // MARK: - Initializer
    
    init(dataUseCase: DataUseCase, deviceUseCase: DeviceUseCase) {
        self.dataUseCase = dataUseCase
        self.deviceUseCase = deviceUseCase
        
        devicesObservable = deviceUseCase.devicesObservable
    }
    
    // MARK: - Events
    
    func onViewDidLoad() {
        dataUseCase.refreshData()
    }
}
