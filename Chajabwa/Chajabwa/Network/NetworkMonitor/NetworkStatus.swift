//
//  NetworkStatus.swift
//  app-show-room
//
//  Created by Moon Yeji on 2023/03/27.
//

import Foundation

enum NetworkStatus {
    
    case connected
    case disconnected
    
    var description: String {
        switch self {
        case .connected:
            return Texts.network_connected
        case .disconnected:
            return Texts.network_disconnected
        }
    }
    
}
