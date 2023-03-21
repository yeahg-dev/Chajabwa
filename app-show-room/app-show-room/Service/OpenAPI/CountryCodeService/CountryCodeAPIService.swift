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
            notifyEndWithError()
            return
        }
        let downloadTask = session.downloadTask(with: request)
        downloadTask.resume()
        notifyPrepareStart(with: downloadTask.progress)
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
            notifyEndWithError()
            return
        }
        
        guard let contentType = httpResponse.value(forHTTPHeaderField: "Content-Type"),
        contentType == "application/json;charset=UTF-8" else {
            print("\(self) : response Content-Type is \(String(describing: httpResponse.value(forHTTPHeaderField: "Content-Type")))")
            notifyEndWithError()
            return
        }

        guard let data = try? Data(contentsOf: location) else {
            print("Type[\(self)] data를 읽을 수 없음")
            notifyEndWithError()
            return
        }
        
        guard let parsedData = try? JSONDecoder().decode(CountryCodeList.self, from: data) else {
            print("parsing failed. type: \(CountryCodeList.self) ")
            notifyEndWithError()
            return
        }
        
        appendCountries(countryCodeList: parsedData)
        notifyEndWithSuccess()
    }
    
    private func appendCountries(countryCodeList: CountryCodeList) {
        Country.list += countryCodeList.data.compactMap {$0.toDomain()}
    }
    
}

extension CountryCodeAPIService: AppOrganizerDelegate {
    
    func notifyPrepareStart(with progress: Progress) {
        NotificationCenter.default.post(
            name: .prepareStart,
            object: progress)
    }
    
    func notifyEndWithError() {
        NotificationCenter.default.post(name: .prepareEndWithError, object: nil)
    }
    
    func notifyEndWithSuccess() {
        NotificationCenter.default.post(name: .prepareEndWithSuccess, object: nil)
    }
    
}
