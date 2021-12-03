//
//  HTTPClientTests.swift
//  ModuloTechTests
//
//  Created by Mohamed Amine HAJ MOHAMED on 02/12/2021.
//

import XCTest
import RxSwift
@testable import ModuloTech

class HTTPClientTests: XCTestCase {
    
    private var sut: HTTPClient!
    private var disposeBag: DisposeBag!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.protocolClasses = [URLProtocolStub.self]
        let session = URLSession(configuration: sessionConfiguration)
        
        sut = HTTPClient(session, baseURL: "baseUrl")
        disposeBag = DisposeBag()
    }
    
    override func tearDownWithError() throws {
        URLProtocolStub.statusCode = nil
        disposeBag = nil
        sut = nil
        try super.tearDownWithError()
    }
    
    func test_loadData() throws {
        let expectation = XCTestExpectation()
        
        // given
        // when
        sut.request(path: "/data")
            .subscribe(onSuccess: { data in
                // then
                XCTAssertNotNil(data)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_throwsMalformedURL_ifURLIsMalformed() {
        let expectation = XCTestExpectation()
        
        // given
        let path = "// p - ?"
        
        // when
        sut.request(path: path)
            .subscribe(onFailure: { error in
                // then
                XCTAssert((error as? AppError) == .malformedURL)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_throwBadRequestError_ifStatusCodeIs400() throws {
        let expectation = XCTestExpectation()
        
        // given
        URLProtocolStub.statusCode = 400
        
        // when
        sut.request(path: "/data")
            .subscribe(onFailure: { error in
                // then
                XCTAssert((error as? AppError.Network) == .badRequest)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_throwInternalServerError_ifStatusCodeIs500() throws {
        let expectation = XCTestExpectation()
        
        // given
        URLProtocolStub.statusCode = 500
        
        // when
        sut.request(path: "/data")
            .subscribe(onFailure: { error in
                // then
                XCTAssert((error as? AppError.Network) == .internalServerError)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_throwUnknownError() throws {
        let expectation = XCTestExpectation()
        
        // given
        URLProtocolStub.statusCode = 499
        
        // when
        sut.request(path: "/data")
            .subscribe(onFailure: { error in
                // then
                XCTAssert((error as? AppError.Network) == .unknown)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 1)
    }
}

// MARK: - URLProtocolStub

private class URLProtocolStub: URLProtocol {
    
    static var statusCode: Int?
    
    override class func canInit(with request: URLRequest) -> Bool {
        true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }
    
    override func startLoading() {
        guard let url = request.url else {
            client?.urlProtocol(self, didFailWithError: AppError.malformedURL)
            client?.urlProtocolDidFinishLoading(self)
            return
        }
        
        if let response = HTTPURLResponse(url: url, statusCode: URLProtocolStub.statusCode ?? 200, httpVersion: nil, headerFields: nil) {
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        }
        
        client?.urlProtocol(self, didLoad: Data())
        
        client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {
    }
}
