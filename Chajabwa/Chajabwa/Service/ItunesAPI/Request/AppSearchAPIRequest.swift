//
//  AppSearchAPIRequest.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/12/07.
//

import Foundation

struct AppSearchAPIRequest: iTunesAPIRequest {
    
    typealias APIResponse = AppSearchResults
    
    var httpMethod: HTTPMethod = .get
    var path: String = "/search"
    var query: [String: Any]
    var body: Data? = nil
    
    var url: URL? {
        var urlComponents = URLComponents(string: baseURLString + path)
        urlComponents?.queryItems = query.map {
            URLQueryItem(name: $0.key, value: "\($0.value)") }
        return urlComponents?.url
    }
    
    init(term: String, countryISOCode: String, softwareType: String) {
        self.query = ["term": term, "country": countryISOCode, "entity": softwareType]
    }
    
}
