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
    
}

extension APIService {
    
    func execute<T: APIRequest>(request: T) async throws -> T.APIResponse {
        guard let urlRequest = request.urlRequest else {
            throw APIError.invalidURL
        }
        
        let (data, response) = try await session.data(for: urlRequest)
        print(response)
        guard let response = response as? HTTPURLResponse,
              (200...299).contains(response.statusCode) else {
            print("\(T.self) failed to receive success response(status code: 200-299)")
            throw APIError.HTTPResponseFailure
        }
        
        guard let parsedData: T.APIResponse = parse(response: data) else {
            print("parsing failed. type: \(T.APIResponse.Type.self) ")
            throw APIError.invalidParsedData
        }
        
        return parsedData
    }
    
    func getResponse<T: APIRequest>(
        request: T)
    -> AnyPublisher<T.APIResponse, Error>
    {
        guard let urlRequest = request.urlRequest else {
            return Result.Publisher(.failure(APIError.invalidURL))
                .eraseToAnyPublisher()
        }
       
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .tryMap { (data, response) -> Data in
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    throw APIError.HTTPResponseFailure
                }
                return data
            }
            .decode(type: T.APIResponse.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func parse<T: Decodable>(response data: Data) -> T? {
        let parsedData = try? JSONDecoder().decode(T.self, from: data)
        return parsedData
    }
    
}
