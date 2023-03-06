//
//  iTunesAPIRequest.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/08/13.
//

import Foundation

protocol iTunesAPIRequest: APIRequest {
    
}

extension iTunesAPIRequest {

    var baseURLString: String {
        "http://itunes.apple.com"
    }
    
    var header: [String: String] {
        ["Content-Type": "application/json",
         "Accept": "application/json",
         "Cache-control": "no-cache"]
    }
    
}
