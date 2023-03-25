//
//  NetworkMonitor.swift
//  app-show-room
//
//  Created by Moon Yeji on 2023/03/25.
//

import Foundation

final class NetworkMonitor {
    
    static let shared = NetworkMonitor()
    
    private init() { }
    
    func handleNetworkError(error: Error?, with retry: @escaping(() -> Void)) {
        guard let error else {
            return
        }
        if isNSURLErrorNotConnectedToInternet(error) {
            DispatchQueue.main.async {
                SceneDelegate.topMostViewController?.presentNetworkErrorAlertWith(
                    retry: { retry() }
                )
            }
        }
    }
    
    private func isNSURLErrorNotConnectedToInternet(_ error: Error) -> Bool {
        return (error as NSError).code == NSURLErrorNotConnectedToInternet ? true : false
    }
    
}
