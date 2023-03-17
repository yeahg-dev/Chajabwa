//
//  AppLookupAPIRequest.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/08/13.
//

import Foundation

struct AppLookupAPIRequest: iTunesAPIRequest {

    typealias APIResponse = AppLookupResults
    
    var httpMethod: HTTPMethod = .get
    var path: String = "/lookup"
    var query: [String: Any]
    var body: Data? = nil
    
    var url: URL? {
        var urlComponents = URLComponents(string: baseURLString + path)
        urlComponents?.queryItems = query.map {
            URLQueryItem(name: $0.key, value: "\($0.value)") }
        return urlComponents?.url
    }
    
    init(appID: Int, countryISOCode: String, softwareType: String) {
        self.query = ["id": appID, "country": countryISOCode, "software": softwareType]
    }
    
}

protocol AppLookupResponse: Decodable {
    
}
