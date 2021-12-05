//
//  DataApiProviderImplTests.swift
//  ModuloTechTests
//
//  Created by Mohamed Amine HAJ MOHAMED on 01/12/2021.
//

import XCTest
import RxSwift
@testable import ModuloTech

class DataApiProviderImplTests: XCTestCase {
    
    private var sut: DataApiProviderImpl!
    private var disposeBag: DisposeBag!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.protocolClasses = [URLProtocolStub.self]
        let session = URLSession(configuration: sessionConfiguration)
        let httpClient = HTTPClient(session, baseURL: "baseurl")
        sut = DataApiProviderImpl(httpClient: httpClient)
        disposeBag = DisposeBag()
    }
    
    override func tearDownWithError() throws {
        URLProtocolStub.fileName = ""
        disposeBag = nil
        sut = nil
        try super.tearDownWithError()
    }
    
    func test_getData_success() throws {
        let expectation = XCTestExpectation()
        
        // given
        URLProtocolStub.fileName = "DataStub"
        
        // when
        sut.getData()
            .subscribe(onSuccess: { devices in
                // then
                XCTAssertEqual(devices.count, 12)
                
                let light = devices[0] as? Light
                XCTAssertEqual(light?.id, 1)
                XCTAssertEqual(light?.name, "Lampe - Cuisine")
                XCTAssertEqual(light?.intensity, 50)
                XCTAssertEqual(light?.mode, true)
                
                let rollerShutter = devices[1] as? RollerShutter
                XCTAssertEqual(rollerShutter?.id, 2)
                XCTAssertEqual(rollerShutter?.name, "Volet roulant - Salon")
                XCTAssertEqual(rollerShutter?.position, 70)
                
                let heater = devices[2] as? Heater
                XCTAssertEqual(heater?.id, 3)
                XCTAssertEqual(heater?.name, "Radiateur - Chambre")
                XCTAssertEqual(heater?.mode, false)
                XCTAssertEqual(heater?.temperature, 20)
                
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_getData_fail() throws {
        let expectation = XCTestExpectation()
        
        // given
        URLProtocolStub.fileName = "EmptyDataStub"
        
        // when
        sut.getData()
            .subscribe(onFailure: { error in
                // then
                XCTAssert((error as? AppError) == .couldNotLoadData)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 1)
    }
}

// MARK: - URLProtocolStub
private class URLProtocolStub: URLProtocol {
    
    static var fileName = ""
    
    override class func canInit(with request: URLRequest) -> Bool {
        true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }
    
    override func startLoading() {
        guard let fileUrl = Bundle(for: URLProtocolStub.self).url(forResource: URLProtocolStub.fileName, withExtension: "json"),
              let data = try? Data(contentsOf: fileUrl) else {
                  client?.urlProtocolDidFinishLoading(self)
                  return
              }
        
        if let response = HTTPURLResponse(url: fileUrl, statusCode: 200, httpVersion: nil, headerFields: nil) {
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        }
        
        client?.urlProtocol(self, didLoad: data)
        
        client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {
        
    }
}
