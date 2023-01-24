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
    case iPod
    
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
        case .iPod:
            return UIImage(named: "iPod")
        }
    }
    
    static func create(with deviceName: String) -> Device? {
        if deviceName.isContainCaseInsensitive(string: Device.iPhone.rawValue) {
            return .iPhone
        } else if deviceName.isContainCaseInsensitive(string: Device.iPad.rawValue) {
            return .iPad
        } else if deviceName.isContainCaseInsensitive(string: Device.watch.rawValue) {
            return .watch
        } else if deviceName.isContainCaseInsensitive(string: Device.mac.rawValue) {
            return .mac
        } else if deviceName.isContainCaseInsensitive(string: Device.iPod.rawValue) {
            return .iPod
        } else {
            return nil
        }
    }
    
}
