//
//  FolderNameTextField.swift
//  app-show-room
//
//  Created by Moon Yeji on 2023/01/13.
//

import UIKit

class FolderNameTextField: UITextField {

    private lazy var underlineLayer: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = Design.underlineColor.cgColor
        return layer
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.addSublayer(underlineLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        underlineLayer.frame = CGRect(
            x: 0,
            y: frame.height-Design.underlineHeight,
            width: frame.width,
            height: Design.underlineHeight)
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 0, dy: Design.textRectBottomPadding)
    }
    
}

private enum Design {
    
    static let font: UIFont = .preferredFont(forTextStyle: .headline)
    static let underlineColor: UIColor = Color.favoriteLavender
    
    static let underlineHeight: CGFloat = 1
    
    static let textRectBottomPadding: CGFloat = 3
    
}
