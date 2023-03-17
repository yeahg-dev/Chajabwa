//
//  CountryCodeAPIService.swift
//  app-show-room
//
//  Created by Moon Yeji on 2023/02/13.
//

import Foundation

struct CountryCodeAPIService: APIService {
    
    var session: URLSession = URLSession(configuration: .default)
    
    func requestAllCountryCode() async throws -> [CountryCode] {
        let request = CountryCodeListRequest(pageNo: 1, numOfRows: 240)
        let countryCodeList: CountryCodeList = try await getResponse(request: request)
        return countryCodeList.data
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
        
        guard let contentType = response.value(forHTTPHeaderField: "Content-Type"),
        contentType == "application/json;charset=UTF-8" else {
            print("\(T.self) : response Content-Type is \(String(describing: response.value(forHTTPHeaderField: "Content-Type")))")
            throw APIError.HTTPResponseFailure
        }
        
        guard let parsedData: T.APIResponse = parse(response: data) else {
            print("parsing failed. type: \(T.APIResponse.Type.self) ")
            throw APIError.invalidParsedData
        }
        
        return parsedData
    }
    
}
