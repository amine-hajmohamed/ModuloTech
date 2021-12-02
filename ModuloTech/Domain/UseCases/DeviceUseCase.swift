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
}
