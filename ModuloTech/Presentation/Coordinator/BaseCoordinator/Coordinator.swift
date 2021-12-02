//
//  Coordinator.swift
//  ModuloTech
//
//  Created by Mohamed Amine HAJ MOHAMED on 02/12/2021.
//

protocol Coordinator: AnyObject, Presentable {
    
    var onCompletion: (() -> Void)? { get }
    
    func start()
}
