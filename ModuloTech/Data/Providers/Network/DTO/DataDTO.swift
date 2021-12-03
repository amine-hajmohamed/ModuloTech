//
//  DataDTO.swift
//  ModuloTech
//
//  Created by Mohamed Amine HAJ MOHAMED on 01/12/2021.
//

struct DataDTO: Decodable {
    
    let devices : [DeviceDTO]?

    enum CodingKeys: String, CodingKey {
        case devices = "devices"
    }
}
