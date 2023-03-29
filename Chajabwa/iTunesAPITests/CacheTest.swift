//
//  CacheTest.swift
//  iTunesAPITests
//
//  Created by Moon Yeji on 2022/08/13.
//

import XCTest
@testable import app_show_room

class CacheTest: XCTestCase {
    
    var sut: URLSession = iTunesAPIService.sessionWithDefaultConfiguration
    var cachedResponse: URLResponse!
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        self.cachedResponse = nil
    }
    
    func test_데이터가_변경되지_않았을때_캐시를_리턴하는지() throws {
        let expectation = XCTestExpectation(description: "response arrived")
        let apiRequest = AppLookupAPIRequest(
            appID: 362057947,
            country: "KR",
            softwareType: "software")
        var cachedURLResponse: CachedURLResponse?
        
        guard let urlRequest = apiRequest.urlRequest else {
            XCTFail("invalid url")
            return
        }
        
        let dataTask = iTunesAPIService.sessionWithDefaultConfiguration.dataTask(
            with: urlRequest) { data, urlResponse, error in
                
                // cachedResponse가 nil인 문제
                if let cachedData = self.sut.configuration.urlCache?.cachedResponse(for: urlRequest) {
                    cachedURLResponse = cachedData
                    expectation.fulfill()
                }
                
                if let _ = error {
                    self.cachedResponse = urlResponse
                    XCTFail("error response")
                    expectation.fulfill()
                }
                
                guard let data = data else {
                    XCTFail("no data")
                    expectation.fulfill()
                    return
                }
    
                let newcachedURLResponse = CachedURLResponse(
                    response: urlResponse!,
                    data: data,
                    userInfo: ["id": 100],
                    storagePolicy: .allowedInMemoryOnly)
                self.sut.configuration.urlCache?.storeCachedResponse(
                    newcachedURLResponse,
                    for: urlRequest)
                // urlRequest당 하나의 response 저장되는 것 확인
                print("메모리 사용량: \(String(self.sut.configuration.urlCache?.currentMemoryUsage ?? 0))")
                expectation.fulfill()
            }
        dataTask.resume()
        
        wait(for: [expectation], timeout: 5)
        
        XCTAssertEqual(
            cachedURLResponse?.value(forKey: "id") as? Int,
            100)
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
