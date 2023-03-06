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
                return Images.PlatformButton.platformIphone.image
            case .iPad:
                return Images.PlatformButton.platformIpad.image
            case .mac:
                return Images.PlatformButton.platformMac.image
            }
        }
        
        var selectedImage: UIImage? {
            switch self {
            case .iPhone:
                return Images.PlatformButton.platformIphoneSelected.image
            case .iPad:
                return Images.PlatformButton.platformIpadSelected.image
            case .mac:
                return Images.PlatformButton.platformMacSelected.image
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
