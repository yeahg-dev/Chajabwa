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
    
    func getResponse<T: APIRequest>(request: T) async throws -> T.APIResponse {
        guard let urlRequest = request.urlRequest else {
            throw APIError.invalidURL
        }
        
        let (data, response) = try await session.data(for: urlRequest)
        
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
    
}

extension iTunesAPIService {
    
    static let sessionWithDefaultConfiguration: URLSession = {
        let defaultConfiguration = URLSessionConfiguration.default
        defaultConfiguration.requestCachePolicy = .useProtocolCachePolicy
        return URLSession(configuration: defaultConfiguration)
    }()
    
    static let dateFormatter = ISO8601DateFormatter()
    
}
