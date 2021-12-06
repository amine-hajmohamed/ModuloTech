//
//  Float+Extension.swift
//  ModuloTech
//
//  Created by Mohamed Amine HAJ MOHAMED on 05/12/2021.
//

extension Float {
    
    func toString(showDecimalNumberIfEqualToZero: Bool = false) -> String {
        var format = "%.1f"
        if !showDecimalNumberIfEqualToZero && truncatingRemainder(dividingBy: 1) == 0 {
            format = "%.0f"
        }
        return String(format: format, self)
    }
}
