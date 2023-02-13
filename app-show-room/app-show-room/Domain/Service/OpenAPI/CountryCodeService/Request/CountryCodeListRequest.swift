//
//  CountryCodeListRequest.swift
//  app-show-room
//
//  Created by Moon Yeji on 2023/02/13.
//

import Foundation

struct CountryCodeListRequest: APIRequest {
    
    typealias APIResponse = CountryCodeList
    
    var httpMethod: HTTPMethod  = .get
    var baseURLString: String = "http://apis.data.go.kr/1262000/CountryCodeService2"
    var path: String = "/getCountryCodeList2"
    var query: [String: Any]
    var header: [String: String] = [:]
    var body: Data?
    
    init(pageNo: Int, numOfRows: Int) {
        self.query = ["pageNo": pageNo, "numOfRows": numOfRows]
    }
    
}
