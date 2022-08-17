//
//  iTunesAppDetailRepositoryTest.swift
//  iTunesAPITests
//
//  Created by Moon Yeji on 2022/08/14.
//

import XCTest
@testable import app_show_room

class iTunesAppDetailRepositoryTest: XCTestCase {
    
    var sut: AppDetailRepository!

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .useProtocolCachePolicy
        configuration.protocolClasses = [MockURLProtocol.self]
        let mockURLSession = URLSession(configuration: configuration)
        
        self.sut = ItunesAppDetailRepository(service: iTunesAPIService(session: mockURLSession))
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        self.sut = nil
    }

    func test_ID_872469884의_AppDetail을_정상적으로_페치해오는지() throws {
        let expectation = XCTestExpectation(description: "response arrived!")
        
        let idiusID = 872469884
        let lookupRequest = AppLookupAPIRequest(appID: idiusID)
        var appDetail: AppDetail?
        
        guard let url = lookupRequest.url else {
            XCTFail("invalid url")
            return
        }
       
        MockURLProtocol.requestHandler = { [weak self] request in
            let dummyIdiusAppDetailData = try self?.getData(fromJSON: "lookupAPISuccessResponse")
            let response = HTTPURLResponse(url: url,
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: nil)!
            return (response, dummyIdiusAppDetailData)
        }
        
        self.sut.fetchAppDetail(of: idiusID) { result in
            switch result {
            case .success(let detail):
                appDetail = detail
                expectation.fulfill()
            case .failure(let error):
                XCTFail("error: \(error.localizedDescription)")
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 5)
        
        XCTAssertEqual(appDetail?.provider, "Backpackr Inc.")
        XCTAssertEqual(appDetail?.appName, "아이디어스(idus)")
        XCTAssertEqual(appDetail?.price, "Free")
    }
    
    func test_유효하지않은_ID를_제공하면_페치가_실패하는지() throws {
        let expectation = XCTestExpectation(description: "response arrived!")
        
        let invalidID = 0
        let lookupRequest = AppLookupAPIRequest(appID: invalidID)
        var appDetail: AppDetail?
        
        guard let url = lookupRequest.url else {
            XCTFail("invalid url")
            return
        }
       
        MockURLProtocol.requestHandler = { [weak self] request in
            let dummyEmptyResultData = try self?.getData(fromJSON: "lookupAPIEmptyResultResponse")
            let response = HTTPURLResponse(url: url,
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: nil)!
            return (response, dummyEmptyResultData)
        }
        
        self.sut.fetchAppDetail(of: invalidID) { result in
            switch result {
            case .success(let detail):
                appDetail = detail
                expectation.fulfill()
            case .failure(_):
                appDetail = nil
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 5)
        
        XCTAssertNil(appDetail)
    }

}
