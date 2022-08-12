//
//  APIRequest.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/08/13.
//

import Foundation

protocol APIRequest {
    
    associatedtype Response: APIResponse
    
    var httpMethod: HTTPMethod { get }
    var baseURLString: String { get }
    var path: String { get }
    var queryItems: [String: Any] { get }
    var header: [String: String] { get }
    var body: Data? { get }
    
}

extension APIRequest {
    
    var url: URL? {
        var urlComponents = URLComponents(string: baseURLString + path)
        urlComponents?.queryItems = queryItems.map {
            URLQueryItem(name: $0.key, value: "\($0.value)") }
        return urlComponents?.url
    }
    
    var urlRequest: URLRequest? {
        guard let url = url else {
            return nil
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod.rawValue
        urlRequest.allHTTPHeaderFields = header
        urlRequest.httpBody = body
        return urlRequest
    }
}

protocol APIResponse: Decodable {
    
}
