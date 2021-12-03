//
//  AppModule.swift
//  ModuloTech
//
//  Created by Mohamed Amine HAJ MOHAMED on 02/12/2021.
//

import Foundation

protocol AppModule {
    var dataUseCase: DataUseCase { get }
    var deviceUseCase: DeviceUseCase { get }
}

class DefaultAppModule: AppModule {
    
    // MARK: - Clients
    
    private lazy var httpClient: HTTPClient = {
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.timeoutIntervalForRequest = 10
        let session = URLSession(configuration: sessionConfiguration)
        return HTTPClient(session, baseURL: Configurations.current.baseApiURL)
    }()
    
    // MARK: - Providers
    
    private lazy var memoryCacheProvider: MemoryCacheProvider = MemoryCacheProviderImpl()
    private lazy var dataApiProvider: DataApiProvider = DataApiProviderImpl(httpClient: httpClient)
    
    // MARK: - Usecases
    
    private(set) lazy var dataUseCase = DataUseCase(dataApiProvider: dataApiProvider, memoryCacheProvider: memoryCacheProvider)
    private(set) lazy var deviceUseCase = DeviceUseCase(memoryCacheProvider: memoryCacheProvider)
}
