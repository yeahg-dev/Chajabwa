//
//  APIRequest.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/08/13.
//

import Foundation

protocol APIRequest {
    
    associatedtype APIResponse: Decodable
    
    var httpMethod: HTTPMethod { get }
    var baseURLString: String { get }
    var path: String { get set }
    var query: [String: Any] { get }
    var header: [String: String] { get }
    var body: Data? { get }
    var url: URL? { get }
    
}

extension APIRequest {
    
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
