//
//  DataUseCase.swift
//  ModuloTech
//
//  Created by Mohamed Amine HAJ MOHAMED on 02/12/2021.
//

import RxSwift

class DataUseCase {
    
    // MARK: - Properties
    
    let disposeBag = DisposeBag()
    
    // MARK: - Providers
    
    private let dataApiProvider: DataApiProvider
    private let memoryCacheProvider: MemoryCacheProvider
    
    // MARK: - Initializer
    
    init(dataApiProvider: DataApiProvider, memoryCacheProvider: MemoryCacheProvider) {
        self.dataApiProvider = dataApiProvider
        self.memoryCacheProvider = memoryCacheProvider
    }
    
    // MARK: - UseCases
    
    func refreshData() {
        // TODO: Load in main thread
        dataApiProvider.getData()
            .subscribe(onSuccess: { [weak self] devices in
                self?.memoryCacheProvider.devices.onNext(devices)
            })
            .disposed(by: disposeBag)
    }
}
