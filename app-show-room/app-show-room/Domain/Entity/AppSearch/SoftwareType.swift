//
//  SoftwareType.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/12/07.
//

import UIKit

enum SoftwareType: String {
    
    case iPhone = "software"
    case iPad = "iPadSoftware"
    case mac = "macSoftware"
    
    var iconImage: UIImage? {
        switch self {
        case .iPhone:
            return UIImage(named: "iPhone")
        case .iPad:
            return UIImage(named: "iPad")
        case .mac:
            return UIImage(named: "mac")
        }
    }
    
}
