//
//  APIService.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/08/13.
//

import Combine
import Foundation

protocol APIService {
    
    var session: URLSession { get set }
    
    func getResponse<T: APIRequest>(request: T) async throws -> T.APIResponse
    
    func getResponse<T: APIRequest>(
        request: T)
    -> AnyPublisher<T.APIResponse, Error>
    
}

extension APIService {
    
    func parse<T: Decodable>(response data: Data) -> T? {
        let parsedData = try? JSONDecoder().decode(T.self, from: data)
        return parsedData
    }
    
}
