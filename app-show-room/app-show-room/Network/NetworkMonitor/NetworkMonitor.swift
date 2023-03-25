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
    
    func handleNetworkError(by retry: @escaping(() -> Void)) {
            DispatchQueue.main.async {
                SceneDelegate.topMostViewController?.presentNetworkErrorAlertWith(
                    retry: { retry() }
                )
            }
    }
    
}
