//
//  Device.swift
//  ModuloTech
//
//  Created by Mohamed Amine HAJ MOHAMED on 01/12/2021.
//

class Device {
    
    let id: Int
    var name: String
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}

extension Device {
    
    func getType() -> DeviceType? {
        switch self {
        case is Light:
            return .light
        case is RollerShutter:
            return .rollerShutter
        case is Heater:
            return .heater
        default:
            return nil
        }
    }
}

enum DeviceType {
    case light
    case rollerShutter
    case heater
}
