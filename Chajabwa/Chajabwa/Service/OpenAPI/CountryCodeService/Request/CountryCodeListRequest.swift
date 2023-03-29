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
    var body: Data? = nil
    var header: [String: String] = [:]
    
    var url: URL? {
        var urlComponents = URLComponents(string: baseURLString + path)
        urlComponents?.queryItems = query.map {
            URLQueryItem(name: $0.key, value: "\($0.value)") }
        let encodedUrlComponents = percentEncodePlusSign(urlComponents)
        return encodedUrlComponents?.url
    }
    
    init(pageNo: Int, numOfRows: Int) {
        self.query = ["serviceKey": Bundle.main.countryCodeAPIKey,
                      "numOfRows": numOfRows,
                      "pageNo": pageNo]
    }
    
    private func percentEncodePlusSign(_ urlComponents: URLComponents?) -> URLComponents? {
        var encodedUrlComponents = urlComponents
        let encodedQuery = urlComponents?.percentEncodedQuery?.replacingOccurrences(
            of: "+",
            with: "%2B")
        encodedUrlComponents?.percentEncodedQuery = encodedQuery
        return encodedUrlComponents
    }

}
