//
//  ParsingTest.swift
//  iTunesAPITests
//
//  Created by Moon Yeji on 2022/08/13.
//

import XCTest
@testable import app_show_room

class ParsingTest: XCTestCase {
    
    private enum JSONFile: String {
        case lookup = "lookupAPISuccessResponse"
        case search = "searchAPISuccessResponse"
        
    }
    
    func test_AppResponse_property() throws {
        let appLookupResults = try parse(
            fileName: JSONFile.lookup.rawValue,
            type: AppLookupResults.self)
       
        guard let app = appLookupResults?.results.first else {
            XCTFail("failed to parsing type: \(App.self)")
            return
        }
        
        XCTAssertEqual(app.trackName, "아이디어스(idus)")
        XCTAssertEqual(app.averageUserRating, 4.7563)
        XCTAssertEqual(app.price, 0)
    }
    
    func test_AppSearchResponse_data가_App으로_정상적으로_파싱되는지() throws {
        let appLookupResults = try parse(
            fileName: JSONFile.search.rawValue,
            type: AppLookupResults.self)

        guard let melon = appLookupResults?.results.first else {
            XCTFail("failed to parsing type: App")
            return
        }
        
        XCTAssertEqual(melon.trackName, "멜론(Melon)")
    }

    private func parse<T: Decodable>(
        fileName: String,
        type targetType: T.Type)
    throws -> T?
    {
        let data = try getData(fromJSON: fileName)
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            XCTFail("failed to parsing type: \(T.self)")
            return nil
        }
    }
}
