//
//  AppSearchAPIRequest.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/12/07.
//

import Foundation

struct AppSearchAPIRequest: iTunesAPIRequest {
    
    typealias APIResponse = AppLookupResults
    
    var httpMethod: HTTPMethod = .get
    var path: String = "/search"
    var query: [String: Any]
    var body: Data? = nil
    
    init(term: String, country: String, softwareType: String) {
        self.query = ["term": term, "country": country, "software": softwareType]
    }
    
}
