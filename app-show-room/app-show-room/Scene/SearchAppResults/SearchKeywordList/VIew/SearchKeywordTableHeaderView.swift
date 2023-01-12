//
//  SearchKeywordTableHeaderView.swift
//  app-show-room
//
//  Created by Moon Yeji on 2023/01/02.
//

import UIKit

final class SearchKeywordTableHeaderView: UIView {
    
    weak var recentKeywordSavingUpdater: SearchKeywordSavingUpdater?
    
    private var viewModel: SearchKeywordTableHeaderViewModel?

    private let titleLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .title2)
        return label
    }()
    
    private lazy var savingModeSwitch: UISwitch = {
        let savingModeSwitch = UISwitch()
        savingModeSwitch.translatesAutoresizingMaskIntoConstraints = false
        savingModeSwitch.onTintColor = Design.switchOnColor
        savingModeSwitch.addTarget(
            self,
            action: #selector(savingSwitchValueDidChanged(sender:)),
            for: .valueChanged)
        return savingModeSwitch
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    } 
    
    func bind(_ viewModel: SearchKeywordTableHeaderViewModel) {
        self.viewModel = viewModel
        titleLabel.text = viewModel.headerTitle
        savingModeSwitch.isOn = viewModel.isSavingSwithOn
    }

    private func addSubviews() {
        self.addSubview(titleLabel)
        self.addSubview(savingModeSwitch)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            titleLabel.leadingAnchor.constraint(
                equalTo: self.leadingAnchor,
                constant: Design.paddingLeading),
            savingModeSwitch.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            savingModeSwitch.trailingAnchor.constraint(
                equalTo: self.trailingAnchor,
                constant: -Design.paddingTrailing)
        ])
    }
    
    @objc
    private func savingSwitchValueDidChanged(sender: UISwitch) {
        viewModel?.switchStateDidChanged(to: sender.isOn)
        recentKeywordSavingUpdater?.didChangedVaule(to: sender.isOn)
    }

}

private enum Design {
    
    static let paddingLeading: CGFloat = 25
    static let paddingTrailing: CGFloat = 25

    static let switchOnColor: UIColor = Color.lilac

}
