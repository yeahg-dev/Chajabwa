//
//  BaseAppDetailCollectionViewCell.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/08/15.
//

import UIKit

class BaseAppDetailCollectionViewCell: UICollectionViewCell {
    
    var height: CGFloat {  return CGFloat(50) }
    
    weak var appDetailTableViewCellDelegate: AppDetailTableViewCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubviews()
        self.configureSubviews()
        self.setConstraints()
    }
    
    required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    
    func addSubviews() { }
    
    func configureSubviews() { }

    func setConstraints() { }
    
    func bind(model: BaseAppDetailCollectionViewCellModel) { }
    
}

protocol AppDetailTableViewCellDelegate: AnyObject {
    
}
