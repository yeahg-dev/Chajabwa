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
    
    func execute<T: APIRequest>(
        _ request: T,
        _ completion: ((Result<T.APIResponse, Error>) -> Void)? ) {
            guard let urlRequest = request.urlRequest else {
                completion?(.failure(APIError.invalidURL))
                return
            }
            
            let dataTask = session.dataTask(with: urlRequest) { data, urlResponse, error in
                if let error = error {
                    completion?(.failure(error))
                    return
                }
                
                guard let data = data,
                      let parsedData: T.APIResponse = parse(response: data) else {
                    completion?(.failure(APIError.invalidParsedData))
                    return }
                
                completion?(.success(parsedData))
            }
            dataTask.resume()
        }
    
}

extension iTunesAPIService {
    
    static let sessionWithDefaultConfiguration: URLSession = {
        let defaultConfiguration = URLSessionConfiguration.default
        defaultConfiguration.requestCachePolicy = .useProtocolCachePolicy
        return URLSession(configuration: defaultConfiguration)
    }()
    
}
