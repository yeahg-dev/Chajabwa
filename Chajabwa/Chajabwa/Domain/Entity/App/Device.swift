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
            return Images.Device.iPhone.image
        case .iPad:
            return Images.Device.iPad.image
        case .watch:
            return Images.Device.appleWatch.image
        case .mac:
            return Images.Device.mac.image
        case .iPod:
            return Images.Device.iPod.image
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
