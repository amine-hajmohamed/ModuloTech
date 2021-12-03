//
//  DataApiProvider.swift
//  ModuloTech
//
//  Created by Mohamed Amine HAJ MOHAMED on 01/12/2021.
//

import RxSwift

protocol DataApiProvider {
    func getData() -> Single<[Device]>
}
