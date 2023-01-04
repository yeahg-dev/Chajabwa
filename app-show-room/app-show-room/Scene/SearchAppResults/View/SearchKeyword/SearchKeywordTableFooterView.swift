//
//  SearchKeywordTableFooterView.swift
//  app-show-room
//
//  Created by Moon Yeji on 2023/01/04.
//

import UIKit

protocol SearchKeywordTableViewUpdater: AnyObject {
    
    func allSearchKeywordDidDeleted()
    
}

final class SearchKeywordTableFooterView: UIView {
    
    weak var searchKeywordTableViewUpdater: SearchKeywordTableViewUpdater?
    
    private var viewModel: SearchKeywordTableFooterViewModel?

    private lazy var deleteAllButton: UIButton = {
        let buttton = UIButton()
        buttton.translatesAutoresizingMaskIntoConstraints = false
        buttton.titleLabel?.font = .preferredFont(forTextStyle: .callout)
        buttton.setTitleColor(.systemGray, for: .normal)
        buttton.addTarget(
            self,
            action: #selector(deleteAllButtonDidTapped),
            for: .touchUpInside)
        return buttton
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ viewModel: SearchKeywordTableFooterViewModel) {
        self.viewModel = viewModel
        deleteAllButton.setTitle(viewModel.deleteAllButtonTitle, for: .normal)
    }
    
    private func addSubviews() {
        addSubview(deleteAllButton)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            deleteAllButton.centerYAnchor.constraint(
                equalTo: self.centerYAnchor),
            deleteAllButton.trailingAnchor.constraint(
                equalTo: self.trailingAnchor,
                constant: -25)
        ])
    }

    @objc
    private func deleteAllButtonDidTapped() {
        viewModel?.deleteAllButtonDidTapped {
            self.searchKeywordTableViewUpdater?.allSearchKeywordDidDeleted()
        }
    }
    
}
