//
//  CountryCodeAPIService.swift
//  app-show-room
//
//  Created by Moon Yeji on 2023/02/13.
//

import Foundation

final class CountryCodeAPIService: NSObject {
    
    private let session: URLSession = URLSession(
        configuration: .default,
        delegate: nil,
        delegateQueue: nil)
    
    func fetchCountryCodes() {
        guard let request = CountryCodeListRequest(pageNo: 1, numOfRows: 240).urlRequest else {
            return
        }
        let downloadTask = session.dataTask(with: request) { [weak self] ( data, urlResponse, error) in
        
            if error != nil {
                NetworkMonitor.shared.handleNetworkError {
                    DispatchQueue.global().async { [weak self] in
                        self?.fetchCountryCodes()
                    }
                }
                return
            }
            
            guard let httpResponse = urlResponse as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("\(String(describing: self)) : failed to receive success response(status code: 200-299)")
                return
            }
            
            guard let contentType = httpResponse.value(forHTTPHeaderField: "Content-Type"),
                  contentType == "application/json;charset=UTF-8" else {
                print("\(String(describing: self)) : response Content-Type is \(String(describing: httpResponse.value(forHTTPHeaderField: "Content-Type")))")
                return
            }
            
            guard let data,
                  let parsedData = try? JSONDecoder().decode(CountryCodeList.self, from: data) else {
                print("parsing failed. type: \(CountryCodeList.self) ")
                return
            }
            
            self?.appendCountries(countryCodeList: parsedData)
        }
        
        downloadTask.resume()
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
