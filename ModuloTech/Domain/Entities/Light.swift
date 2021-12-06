//
//  Light.swift
//  ModuloTech
//
//  Created by Mohamed Amine HAJ MOHAMED on 01/12/2021.
//

class Light: Device {
    
    var mode: Bool
    var intensity: Int
    
    init(id: Int, deviceName: String, mode: Bool, intensity: Int) {
        self.mode = mode
        self.intensity = intensity
        super.init(id: id, name: deviceName)
    }
}
