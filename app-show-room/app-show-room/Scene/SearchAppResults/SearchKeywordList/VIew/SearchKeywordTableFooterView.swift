//
//  SearchKeywordTableFooterView.swift
//  app-show-room
//
//  Created by Moon Yeji on 2023/01/04.
//

import UIKit

// MARK: - SearchKeywordTableFooterViewDelegate

protocol SearchKeywordTableFooterViewDelegate: AnyObject {
    
    func allSearchKeywordDidDeleted()
    
}

// MARK: - SearchKeywordTableFooterView

final class SearchKeywordTableFooterView: UIView {
    
    weak var searchKeywordTableViewUpdater: SearchKeywordTableFooterViewDelegate?
    
    private var viewModel: SearchKeywordTableFooterViewModel?
    
    private lazy var deleteAllButton: UIButton = {
        let buttton = UIButton()
        buttton.translatesAutoresizingMaskIntoConstraints = false
        buttton.titleLabel?.font = .preferredFont(forTextStyle: .callout)
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
        deleteAllButton.setTitleColor(viewModel.deleteAllButtonTitleColor, for: .normal)
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
        Task {
            await viewModel?.deleteAllButtonDidTapped()
            self.searchKeywordTableViewUpdater?.allSearchKeywordDidDeleted()
        } 
    }
    
}
