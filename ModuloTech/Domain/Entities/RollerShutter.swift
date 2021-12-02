//
//  RollerShutter.swift
//  ModuloTech
//
//  Created by Mohamed Amine HAJ MOHAMED on 01/12/2021.
//

class RollerShutter: Device {
    
    var position: Int
    
    init(id: Int, deviceName: String, position: Int) {
        self.position = position
        super.init(id: id, deviceName: deviceName)
    }
}
