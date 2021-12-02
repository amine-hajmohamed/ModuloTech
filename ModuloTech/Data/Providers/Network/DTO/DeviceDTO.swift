//
//  DeviceDTO.swift
//  ModuloTech
//
//  Created by Mohamed Amine HAJ MOHAMED on 01/12/2021.
//

struct DeviceDTO: Decodable {
    
    let id : Int?
    let deviceName : String?
    let intensity : Int?
    let mode : String?
    let position: Int?
    let temperature: Float?
    let productType : String?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case deviceName = "deviceName"
        case intensity = "intensity"
        case mode = "mode"
        case position = "position"
        case temperature = "temperature"
        case productType = "productType"
    }
}
