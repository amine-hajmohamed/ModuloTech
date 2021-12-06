//
//  DevicesFilter.swift
//  ModuloTech
//
//  Created by Mohamed Amine HAJ MOHAMED on 06/12/2021.
//

class DevicesFilter {
    
    var filterDeviceTypes: Set<DeviceType> = []
    
    func filter(devices: [Device]) -> [Device] {
        var devices = devices
        
        if !filterDeviceTypes.isEmpty {
            devices = devices.filter { device in
                guard let deviceType = device.getType() else {
                    return false
                }
                
                return filterDeviceTypes.contains(deviceType)
            }
        }
        
        return devices
    }
}
