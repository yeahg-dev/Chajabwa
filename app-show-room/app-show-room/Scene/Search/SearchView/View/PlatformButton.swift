//
//  platformButton.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/12/27.
//

import UIKit

final class PlatformButton: UIButton {
    
    enum PlatformType {
        
        case iPhone
        case iPad
        case mac
        
        var normalImage: UIImage? {
            switch self {
            case .iPhone:
                return UIImage(named: "platform_iphone")
            case .iPad:
                return UIImage(named: "platform_ipad")
            case .mac:
                return UIImage(named: "platform_mac")
            }
        }
        
        var selectedImage: UIImage? {
            switch self {
            case .iPhone:
                return UIImage(named: "platform_iphone_selected")
            case .iPad:
                return UIImage(named: "platform_ipad_selected")
            case .mac:
                return UIImage(named: "platform_mac_selected")
            }
        }
    }
    
    init(type: PlatformType) {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.setImage(type.normalImage, for: .normal)
        self.setImage(type.selectedImage, for: .selected)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
