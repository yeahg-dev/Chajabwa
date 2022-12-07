//
//  SoftwareType.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/12/07.
//

import Foundation

enum SoftwareType {
    
    case iPhone
    case iPad
    case mac
    
    var entityName: String {
        switch self {
        case .iPhone:
            return "software"
        case .iPad:
            return "iPadSoftware"
        case .mac:
            return "macSoftware"
        }
    }
    
}
