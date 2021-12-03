//
//  MemoryCacheProvider.swift
//  ModuloTech
//
//  Created by Mohamed Amine HAJ MOHAMED on 02/12/2021.
//

import RxSwift

protocol MemoryCacheProvider {
    
    // MARK: Devices
    
    var devices: BehaviorSubject<[Device]> { get }
}
