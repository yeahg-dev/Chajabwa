//
//  BaseAppDetailTableViewCell.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/08/15.
//

import UIKit

class BaseAppDetailTableViewCell: UITableViewCell {
    
    var height: CGFloat { UITableView.automaticDimension }
    
    weak var appDetailTableViewCellDelegate: AppDetailTableViewCellDelegate?
    
    required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configureSubviews()
    }
    
    func configureSubviews() { }
    
    func bind(model: BaseAppDetailTableViewCellModel) { }
    
}

protocol AppDetailTableViewCellDelegate: AnyObject {
    
}
