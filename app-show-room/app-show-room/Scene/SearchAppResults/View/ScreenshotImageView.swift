//
//  ScreenshotImageView.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/12/09.
//

import UIKit

class ScreenshotImageView: UIImageView {

    let height = Design.height
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(origin: frame.origin, size: CGSize(width: Design.width, height: Design.height)))
        translatesAutoresizingMaskIntoConstraints = false
        contentMode = .scaleAspectFill
        designBorder()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: Design.width, height: Design.height)
    }

    private func designBorder() {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = Design.cornerRadius
        self.layer.borderWidth = Design.borderWidth
        self.layer.borderColor = Design.borderColor
    }
    
}

extension ScreenshotImageView {
    
    // MARK: - Desigin
    
    private enum Design {
        
        // size
        static let height: CGFloat = width / 0.56
        static let width: CGFloat =  UIScreen.main.bounds.width / 3.5
        
        // layer
        static let cornerRadius: CGFloat = 10
        static let borderColor: CGColor = UIColor.systemGray4.cgColor
        static let borderWidth: CGFloat = 0.5
        
    }
    
}
