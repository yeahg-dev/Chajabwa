//
//  DeviceIconImageView.swift
//  app-show-room
//
//  Created by Moon Yeji on 2023/01/22.
//

import UIKit

class DeviceIconImageView: UIImageView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        contentMode = .scaleAspectFit
        setConstarints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConstarints() {
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: Design.width),
            self.heightAnchor.constraint(equalToConstant: Design.height)
        ])
    }
    
}

private enum Design {
    
    static let width: CGFloat = 27
    static let height: CGFloat = 27
}
