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
    case watch
    case mac
    
    var iconImage: UIImage? {
        switch self {
        case .iPhone:
            return UIImage(named: "iPhone")
        case .iPad:
            return UIImage(named: "iPad")
        case .watch:
            return UIImage(named: "appleWatch")
        case .mac:
            return UIImage(named: "mac")
        }
    }
    
    static func create(with deviceName: String) -> Device? {
        if deviceName.lowercased().contains(Device.iPhone.rawValue.lowercased()) {
            return .iPhone
        } else if deviceName.lowercased().contains(Device.iPad.rawValue.lowercased()) {
            return .iPad
        } else if deviceName.lowercased().contains(Device.watch.rawValue.lowercased()) {
            return .watch
        } else if deviceName.lowercased().contains(Device.mac.rawValue.lowercased()) {
            return .mac
        } else {
            return nil
        }
    }
    
}
