//
//  MemoryCacheProviderImpl.swift
//  ModuloTech
//
//  Created by Mohamed Amine HAJ MOHAMED on 02/12/2021.
//

import RxSwift

class MemoryCacheProviderImpl: MemoryCacheProvider {
    
    // MARK: Devices
    
    let devices = BehaviorSubject<[Device]>(value: [])
}
