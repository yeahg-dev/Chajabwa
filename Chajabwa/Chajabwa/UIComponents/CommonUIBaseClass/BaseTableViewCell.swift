//
//  BaseTableViewCell.swift
//  app-show-room
//
//  Created by Moon Yeji on 2023/01/09.
//

import UIKit

class BaseTableViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubviews()
        self.setConstraints()
    }

    required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    
    func addSubviews() { }

    func setConstraints() { }

}
