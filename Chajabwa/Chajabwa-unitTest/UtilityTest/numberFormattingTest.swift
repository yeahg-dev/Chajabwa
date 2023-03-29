//
//  numberFormattingTest.swift
//  app-show-room-unitTest
//
//  Created by Moon Yeji on 2022/09/13.
//

import XCTest
@testable import app_show_room

class numberFormattingTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_123_localized_formattedNumber() throws {
        let number: Int = 123
        let result = number.formattedNumber
        let expected = "123"
        XCTAssertEqual(result, expected)
    }
    
    func test_1234_localized_formattedNumber() throws {
        let number: Int = 1234
        let result = number.formattedNumber
        let koreanExpected = "1,234"
        let englishExpected = "1K"
        
        switch Locale.preferredLanguages.first {
        case "ko":
            XCTAssertEqual(result, koreanExpected)
        default:
            XCTAssertEqual(result, englishExpected)
        }
    }
    
    func test_78912_localized_formattedNumber() throws {
        let number: Int = 78912
        let result = number.formattedNumber
        let koreanExpected = "7만"
        let englishExpected = "78K"
        
        switch Locale.preferredLanguages.first {
        case "ko":
            XCTAssertEqual(result, koreanExpected)
        default:
            XCTAssertEqual(result, englishExpected)
        }
    }
    
    func test_789120_localized_formattedNumber() throws {
        let number: Int = 789120
        let result = number.formattedNumber
        let koreanExpected = "70만"
        let englishExpected = "789K"
        
        switch Locale.preferredLanguages.first {
        case "ko":
            XCTAssertEqual(result, koreanExpected)
        default:
            XCTAssertEqual(result, englishExpected)
        }
    }
    
    func test_2022110_localized_formattedNumber() throws {
        let number: Int = 2022110
        let result = number.formattedNumber
        let koreanExpected = "202만"
        let englishExpected = "2M"
        
        switch Locale.preferredLanguages.first {
        case "ko":
            XCTAssertEqual(result, koreanExpected)
        default:
            XCTAssertEqual(result, englishExpected)
        }
    }
    
    func test_20221107_localized_formattedNumber() throws {
        let number: Int = 20221107
        let result = number.formattedNumber
        let koreanExpected = "2,022만"
        let englishExpected = "20M"
        
        switch Locale.preferredLanguages.first {
        case "ko":
            XCTAssertEqual(result, koreanExpected)
        default:
            XCTAssertEqual(result, englishExpected)
        }
    }
    
    func test_202211070_localized_formattedNumber() throws {
        let number: Int = 202211070
        let result = number.formattedNumber
        let koreanExpected = "2억"
        let englishExpected = "202M"
        
        switch Locale.preferredLanguages.first {
        case "ko":
            XCTAssertEqual(result, koreanExpected)
        default:
            XCTAssertEqual(result, englishExpected)
        }
    }
    
    func test_2022110700_localized_formattedNumber() throws {
        let number: Int = 2022110700
        let result = number.formattedNumber
        let koreanExpected = "20억"
        let englishExpected = "2B"
        
        switch Locale.preferredLanguages.first {
        case "ko":
            XCTAssertEqual(result, koreanExpected)
        default:
            XCTAssertEqual(result, englishExpected)
        }
    }
    
    func test_20221107000_localized_formattedNumber() throws {
        let number: Int = 20221107000
        let result = number.formattedNumber
        let koreanExpected = "202억"
        let englishExpected = "20B"
        
        switch Locale.preferredLanguages.first {
        case "ko":
            XCTAssertEqual(result, koreanExpected)
        default:
            XCTAssertEqual(result, englishExpected)
        }
    }
    
    func test_202211070000_localized_formattedNumber() throws {
        let number: Int = 202211070000
        let result = number.formattedNumber
        let koreanExpected = "2022억"
        let englishExpected = "202B"
        
        switch Locale.preferredLanguages.first {
        case "ko":
            XCTAssertEqual(result, koreanExpected)
        default:
            XCTAssertEqual(result, englishExpected)
        }
    }
    
    func test_2022110700000_localized_formattedNumber() throws {
        let number: Int = 2022110700000
        let result = number.formattedNumber
        let koreanExpected = "2조"
        let englishExpected = "2T"
        
        switch Locale.preferredLanguages.first {
        case "ko":
            XCTAssertEqual(result, koreanExpected)
        default:
            XCTAssertEqual(result, englishExpected)
        }
    }

}
