//
//  CountryCodeAPIService.swift
//  app-show-room
//
//  Created by Moon Yeji on 2023/02/13.
//

import Foundation

final class CountryCodeAPIService: NSObject {
    
    private lazy var session = URLSession(
        configuration: .default,
        delegate: self,
        delegateQueue: nil)
    
    func fetchCountryCodes() {
        guard let request = CountryCodeListRequest(pageNo: 1, numOfRows: 240).urlRequest else {
            // Noti with error
            return
        }
        let downloadTask = session.downloadTask(with: request)
        downloadTask.resume()
        // Noti with progress
    }
 
}

extension CountryCodeAPIService: URLSessionDownloadDelegate, URLSessionDelegate {
    
    func urlSession(
        _ session: URLSession,
        downloadTask: URLSessionDownloadTask,
        didFinishDownloadingTo location: URL)
    {
        guard let httpResponse = downloadTask.response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            print("\(self) : failed to receive success response(status code: 200-299)")
            // Noti with error
            return
        }
        
        guard let contentType = httpResponse.value(forHTTPHeaderField: "Content-Type"),
        contentType == "application/json;charset=UTF-8" else {
            print("\(self) : response Content-Type is \(String(describing: httpResponse.value(forHTTPHeaderField: "Content-Type")))")
            // Noti with error
            return
        }

        guard let data = try? Data(contentsOf: location) else {
            print("Type[\(self)] data를 읽을 수 없음")
            // Noti with error
            return
        }
        
        guard let parsedData = try? JSONDecoder().decode(CountryCodeList.self, from: data) else {
            print("parsing failed. type: \(CountryCodeList.self) ")
            // Noti with error
            return
        }
        
        appendCountries(countryCodeList: parsedData)
        // Noti with success
    }
    
    private func appendCountries(countryCodeList: CountryCodeList) {
        Country.list += countryCodeList.data.compactMap {$0.toDomain()}
    }
    
}
