//
//  AppError.swift
//  ModuloTech
//
//  Created by Mohamed Amine HAJ MOHAMED on 02/12/2021.
//

// MARK: - AppError

enum AppError: Error {
    case couldNotLoadData
    case malformedURL
}

// MARK: - NetworkError

extension AppError {
    
    enum Network: Int, Error {
        case badRequest = 400
        case unauthorized = 401
        case forbidden = 403
        case notFound = 404
        case internalServerError = 500
        case unknown
    }
}
