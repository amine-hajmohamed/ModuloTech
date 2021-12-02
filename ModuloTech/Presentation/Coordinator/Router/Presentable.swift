//
//  Presentable.swift
//  ModuloTech
//
//  Created by Mohamed Amine HAJ MOHAMED on 02/12/2021.
//

import UIKit

protocol Presentable {
    
    func toPresentable() -> UIViewController
}

extension UIViewController: Presentable {
    
    func toPresentable() -> UIViewController {
        self
    }
}
