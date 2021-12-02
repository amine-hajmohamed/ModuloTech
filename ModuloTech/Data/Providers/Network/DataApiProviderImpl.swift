//
//  DataApiProviderImpl.swift
//  ModuloTech
//
//  Created by Mohamed Amine HAJ MOHAMED on 01/12/2021.
//

import RxSwift
import Foundation

class DataApiProviderImpl: DataApiProvider {
    
    // MARK: - Properties
    
    private let httpClient: HTTPClient
    
    // MARK: - Initializer
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    // MARK: - Functions
    
    func getData() -> Single<[Device]> {
        httpClient.request(path: "/data.json")
            .map { data -> DataDTO in
                do {
                    return try JSONDecoder().decode(DataDTO.self, from: data)
                } catch {
                    throw AppError.couldNotLoadData
                }
            }
            .map { $0.devices ?? [] }
            .map { $0.compactMap { DeviceDTOMapper.map($0) } }
    }
}
