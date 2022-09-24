//
//  ByteFormattingTest.swift
//  app-show-room-unitTest
//
//  Created by Moon Yeji on 2022/08/31.
//

import XCTest
@testable import app_show_room

class ByteFormattingTest: XCTestCase {

    func test_124640256byte를_정상적으로_반환하는지() throws {
        let byte: String = "124640256"
        let formattedByte = byte.formattedByte
        
        XCTAssertEqual(formattedByte, "118.9MB")
    }
    
    func test_3051489280byte를_정상적으로_반환하는지() throws {
        let byte: String = "3051489280"
        let formattedByte = byte.formattedByte
        
        XCTAssertEqual(formattedByte, "2.8GB")
    }

    func test_문자를_변환할때_실패하는지() throws {
        let byte: String = "문자"
        let formattedByte = byte.formattedByte
        
        XCTAssertEqual(formattedByte, "제공하지 않음")
    }

}
