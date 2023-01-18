//
//  Device.swift
//  app-show-room
//
//  Created by Moon Yeji on 2023/01/18.
//

import UIKit

enum Device: String {
    
    case iPhone
    case iPad
    case appleWatch
    case mac
    
    var iconImage: UIImage? {
        switch self {
        case .iPhone:
            return UIImage(named: "iPhone")
        case .iPad:
            return UIImage(named: "iPad")
        case .appleWatch:
            return UIImage(named: "appleWatch")
        case .mac:
            return UIImage(named: "mac")
        }
    }
    
    static func create(with deviceName: String) -> Device? {
        if deviceName.contains("iphone") {
            return .iPhone
        } else if deviceName.contains("ipad") {
            return .iPad
        } else if deviceName.contains("watch") {
            return .appleWatch
        } else if deviceName.contains("mac") {
            return .mac
        } else {
            return nil
        }
    }
    
}
