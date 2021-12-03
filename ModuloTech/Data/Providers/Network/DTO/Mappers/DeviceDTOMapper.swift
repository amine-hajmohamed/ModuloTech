//
//  DeviceDTOMapper.swift
//  ModuloTech
//
//  Created by Mohamed Amine HAJ MOHAMED on 01/12/2021.
//

private let kModeOnValue = "ON"

enum DeviceDTOMapper {
    
    static func map(_ dto: DeviceDTO) -> Device? {
        switch dto.productType {
        case "Light":
            return mapToLight(dto)
            
        case "RollerShutter":
            return mapToRollerShutter(dto)
            
        case "Heater":
            return mapToHeater(dto)
            
        default:
            return nil
        }
    }
    
    private static func mapToLight(_ dto: DeviceDTO) -> Light? {
        guard let id = dto.id, let deviceName = dto.deviceName, let mode = dto.mode, let intensity = dto.intensity else {
            return nil
        }
        
        return Light(id: id, deviceName: deviceName, mode: mode == kModeOnValue, intensity: intensity)
    }
    
    private static func mapToRollerShutter(_ dto: DeviceDTO) -> RollerShutter? {
        guard let id = dto.id, let deviceName = dto.deviceName, let position = dto.position else {
            return nil
        }
        
        return RollerShutter(id: id, deviceName: deviceName, position: position)
    }
    
    private static func mapToHeater(_ dto: DeviceDTO) -> Heater? {
        guard let id = dto.id, let deviceName = dto.deviceName, let mode = dto.mode, let temperature = dto.temperature else {
            return nil
        }
        
        return Heater(id: id, deviceName: deviceName, mode: mode == kModeOnValue, temperature: temperature)
    }
}
