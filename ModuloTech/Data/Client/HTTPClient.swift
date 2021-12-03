//
//  HTTPClient.swift
//  ModuloTech
//
//  Created by Mohamed Amine HAJ MOHAMED on 01/12/2021.
//

import Foundation
import RxSwift

// MARK: - HTTPMethod

enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
}

// MARK: - HTTPClient

class HTTPClient {
    
    // MARK: - Properties
    
    private let session: URLSession
    private let baseURL: String
    
    // MARK: - Initializer
    
    init(_ session: URLSession, baseURL: String) {
        self.session = session
        self.baseURL = baseURL
    }
    
    // MARK: - Functions
    
    func request(path: String, method: HTTPMethod = .get) -> Single<Data> {
        Single.create { [weak self] observer in
            guard let self = self else {
                observer(.failure(AppError.couldNotLoadData))
                return Disposables.create()
            }
            
            guard let url = URL(string: self.baseURL + path) else {
                observer(.failure(AppError.malformedURL))
                return Disposables.create()
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = method.rawValue
            
            let dataTask = self.dataTask(request: request) { data, error in
                if let error = error {
                    observer(.failure(error))
                    return
                }
                
                guard let data = data else {
                    observer(.failure(AppError.couldNotLoadData))
                    return
                }
                
                observer(.success(data))
            }
            
            dataTask.resume()
            
            return Disposables.create {
                dataTask.cancel()
            }
        }
    }
}

// MARK: - Privates

private extension HTTPClient {
    
    func dataTask(request: URLRequest, onCompletion: @escaping (Data?, Error?) -> Void) -> URLSessionDataTask {
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                onCompletion(nil, error)
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                onCompletion(nil, AppError.couldNotLoadData)
                return
            }
            
            if (400...599).contains(response.statusCode) {
                let networkError = AppError.Network(rawValue: response.statusCode) ?? .unknown
                onCompletion(nil, networkError)
                return
            }
            
            onCompletion(data, nil)
        }
    }
}
