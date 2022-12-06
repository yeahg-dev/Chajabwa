//
//  iTunesAPIService.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/08/13.
//

import Foundation

struct iTunesAPIService: APIService {
    
    var session: URLSession
    
    init(session: URLSession = iTunesAPIService.sessionWithDefaultConfiguration) {
        self.session = session
    }
    
    func execute<T: APIRequest>(request: T) async throws -> T.APIResponse {
        guard let urlRequest = request.urlRequest else {
            throw APIError.invalidURL
        }
        
        let (data, response) = try await session.data(for: urlRequest)
        guard let response = response as? HTTPURLResponse,
              (200...299).contains(response.statusCode) else {
            throw APIError.HTTPResponseFailure
        }
        
        guard let parsedData: T.APIResponse = parse(response: data) else {
            throw APIError.invalidParsedData
        }
        
        return parsedData
    }
    
}

extension iTunesAPIService {
    
    static let sessionWithDefaultConfiguration: URLSession = {
        let defaultConfiguration = URLSessionConfiguration.default
        defaultConfiguration.requestCachePolicy = .useProtocolCachePolicy
        return URLSession(configuration: defaultConfiguration)
    }()
    
}
