//
//  MockURLProtocol.swift
//  iTunesAPITests
//
//  Created by Moon Yeji on 2022/08/14.
//

import Foundation

class MockURLProtocol: URLProtocol {
    
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data?))?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    // protocol에 명시된 loading을 시작하고, 받은 응답을 URLLoadingSystem에게 전달
    override func startLoading() {
        guard let handler = MockURLProtocol.requestHandler else {
           fatalError("Handler is unavailable.")
         }
           
         do {
           let (response, data) = try handler(request)

           client?.urlProtocol(
            self,
            didReceive: response,
            cacheStoragePolicy: .notAllowed)
           
           if let data = data {
             client?.urlProtocol(self, didLoad: data)
           }
           client?.urlProtocolDidFinishLoading(self)
         } catch {
           client?.urlProtocol(self, didFailWithError: error)
         }
    }
    
    override func stopLoading() {
        print("request가 취소되었습니다")
    }
    
}
