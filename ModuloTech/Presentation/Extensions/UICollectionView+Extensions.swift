//
//  UICollectionView+Extensions.swift
//  ModuloTech
//
//  Created by Mohamed Amine HAJ MOHAMED on 02/12/2021.
//

import UIKit

extension UICollectionView {
    
    func register<T: UICollectionViewCell>(with cellClass: T.Type) {
        register(cellClass, forCellWithReuseIdentifier: "\(cellClass)")
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(with cellClass: T.Type, for indexPath: IndexPath) -> T {
        dequeueReusableCell(withReuseIdentifier: "\(cellClass)", for: indexPath) as! T
    }
}
