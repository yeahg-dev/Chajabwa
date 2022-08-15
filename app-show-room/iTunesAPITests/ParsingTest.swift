//
//  ParsingTest.swift
//  iTunesAPITests
//
//  Created by Moon Yeji on 2022/08/13.
//

import XCTest
@testable import app_show_room

class ParsingTest: XCTestCase {
    
    var sut: AppLookupResults!
    let mockJSONName = "lookupAPISuccessResponse"

    override func setUpWithError() throws {
        try super.setUpWithError()
        let responseData = try getData(fromJSON: mockJSONName)
        self.sut = try JSONDecoder().decode(AppLookupResults.self, from: responseData)
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        self.sut = nil
    }

    func test_AppLookupResponse_resultCount() throws {
        XCTAssertEqual(sut.resultCount, 1)
    }
    
    func test_AppResponse_property() throws {
        guard let appResponse = sut.results.first else {
            XCTFail("AppResponse nil")
            return
        }
        
        XCTAssertEqual(appResponse.trackName, "아이디어스(idus)")
        XCTAssertEqual(appResponse.averageUserRating, 4.7563)
        XCTAssertEqual(appResponse.price, 0)
    }

}
