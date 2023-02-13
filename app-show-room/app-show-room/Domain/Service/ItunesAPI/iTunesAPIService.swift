//
//  iTunesAPIService.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/08/13.
//

import Combine
import Foundation

struct iTunesAPIService: APIService {
    
    var session: URLSession
    
    init(session: URLSession = iTunesAPIService.sessionWithDefaultConfiguration) {
        self.session = session
    }
    
}

extension iTunesAPIService {
    
    static let sessionWithDefaultConfiguration: URLSession = {
        let defaultConfiguration = URLSessionConfiguration.default
        defaultConfiguration.requestCachePolicy = .useProtocolCachePolicy
        return URLSession(configuration: defaultConfiguration)
    }()
    
}
