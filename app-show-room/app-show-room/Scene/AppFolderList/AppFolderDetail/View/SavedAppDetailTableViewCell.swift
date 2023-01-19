//
//  SavedAppDetailTableViewCell.swift
//  app-show-room
//
//  Created by Moon Yeji on 2023/01/19.
//

import UIKit

final class SavedAppDetailTableViewCell: UITableViewCell {
    
    //  supportedDeviceStackView
    
    // countryStackView
    
    private let appDetailPreview: AppDetailPreview = {
        let view = AppDetailPreview()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // addSubviews
    
    // setConstraints
    
    // bind
    
    // button 연결

}

private enum Design {
    
    static let supportedDeviceStackViewHeight: CGFloat = 30
    
    static let countryNameLabelFont: UIFont = .preferredFont(forTextStyle: .subheadline)
    static let countryFlagLabelFont: UIFont = .preferredFont(forTextStyle: .subheadline)

}
