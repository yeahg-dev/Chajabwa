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
            return Images.Device.iPhone.image
        case .iPad:
            return Images.Device.iPad.image
        case .mac:
            return Images.Device.mac.image
        }
    }
    
}
