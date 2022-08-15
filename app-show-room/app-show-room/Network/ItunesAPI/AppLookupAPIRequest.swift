//
//  AppLookupAPIRequest.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/08/13.
//

import Foundation

struct AppLookupAPIRequest: iTunesAPIRequest {

    typealias APIResponse = AppLookupResults
    
    var httpMethod: HTTPMethod  = .get
    var path: String = "/lookup"
    var query: [String: Any]
    var body: Data? = nil
    
    init(appID: Int) {
        self.query = ["id": appID]
    }
    
}

protocol AppLookupResponse: Decodable {
    
}
