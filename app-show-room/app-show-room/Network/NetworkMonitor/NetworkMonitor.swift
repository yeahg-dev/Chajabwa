//
//  NetworkMonitor.swift
//  app-show-room
//
//  Created by Moon Yeji on 2023/03/25.
//

import Foundation
import Network

final class NetworkMonitor {
    
    private let queue = DispatchQueue.global(qos: .background)
    private let monitor = NWPathMonitor()
    
    static let shared = NetworkMonitor()
    
    private init() { }
    
    func startMonitoring(
        statusUpdateHandler: @escaping (NWPath.Status) -> Void)
    {
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                statusUpdateHandler(path.status)
            }
        }
        monitor.start(queue: queue)
    }
    
    func stopMonitoring() {
        monitor.cancel()
    }
    
    func handleNetworkError(by retry: @escaping(() -> Void)) {
        DispatchQueue.main.async {
            SceneDelegate.topMostViewController?.presentNetworkErrorAlertWith(
                retry: { retry() }
            )
        }
    }
    
}
