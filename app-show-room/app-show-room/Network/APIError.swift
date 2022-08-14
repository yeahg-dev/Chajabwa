//
//  APIError.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/08/13.
//

import Foundation

enum APIError: Error {
    
    case invalidURL
    case invalidParsedData
}

enum DTOError: Error {
    
    case invalidTransform
}
