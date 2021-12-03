//
//  Heater.swift
//  ModuloTech
//
//  Created by Mohamed Amine HAJ MOHAMED on 01/12/2021.
//

class Heater: Device {
    
    var mode: Bool
    var temperature: Float
    
    init(id: Int, deviceName: String, mode: Bool, temperature: Float) {
        self.mode = mode
        self.temperature = temperature
        super.init(id: id, deviceName: deviceName)
    }
}
