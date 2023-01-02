//
//  RecentSearchKeywordViewController.swift
//  app-show-room
//
//  Created by Moon Yeji on 2023/01/02.
//

import UIKit

class RecentSearchKeywordViewController: UIViewController {
    
    private let viewModel = RecentSearchKeywordsViewModel()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .title2)
        return label
    }()
    
    private let switchTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .callout)
        return label
    }()
    
    private lazy var savingSwitch: UISwitch = {
        let switchControl = UISwitch()
        switchControl.translatesAutoresizingMaskIntoConstraints = false
        switchControl.addTarget(
            self,
            action: #selector(savingSwitchValueDidChanged(sender:)),
            for: .valueChanged)
        return switchControl
    }()
    
    private let resultContainterView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let savingModeOffDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .body)
        return label
    }()
    
    private let keywordsTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let deleteAllButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = .preferredFont(forTextStyle: .callout)
        button.titleLabel?.textColor = .gray
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        setConstraints()
        configureKeywordsTableView()
        bindViewModel()
    }
    
    private func addSubviews() {
        view.addSubview(titleLabel)
        view.addSubview(switchTitleLabel)
        view.addSubview(savingSwitch)
        view.addSubview(resultContainterView)
        resultContainterView.addSubview(savingModeOffDescriptionLabel)
        resultContainterView.addSubview(keywordsTableView)
        view.addSubview(deleteAllButton)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: Design.paddingLeading),
            titleLabel.topAnchor.constraint(
                equalTo: view.topAnchor,
                constant: Design.paddingTop),
            savingSwitch.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -Design.paddingTrailing),
            savingSwitch.centerYAnchor.constraint(
                equalTo: titleLabel.centerYAnchor),
            switchTitleLabel.centerYAnchor.constraint(
                equalTo: titleLabel.centerYAnchor),
            switchTitleLabel.trailingAnchor.constraint(
                equalTo: savingSwitch.leadingAnchor,
                constant: -Design.switchTitleLabelTrialingMargin),
            resultContainterView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor),
            resultContainterView.topAnchor.constraint(
                equalTo: titleLabel.bottomAnchor,
                constant: Design.titleLabelBottomMargin),
            resultContainterView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor),
            deleteAllButton.topAnchor.constraint(
                equalTo: resultContainterView.bottomAnchor,
                constant: Design.deleteAllButtonTopMargin),
            deleteAllButton.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -Design.paddingTrailing),
            deleteAllButton.bottomAnchor.constraint(
                equalTo: view.bottomAnchor,
                constant: -Design.deleteAllButtonBottomMargin)
        ])
    }
    
    private lazy var keywordsTableViewConstraints = [
        keywordsTableView.leadingAnchor.constraint(
            equalTo: resultContainterView.leadingAnchor),
        keywordsTableView.topAnchor.constraint(
            equalTo: resultContainterView.topAnchor),
        keywordsTableView.trailingAnchor.constraint(
            equalTo: resultContainterView.trailingAnchor),
        keywordsTableView.bottomAnchor.constraint(
            equalTo: resultContainterView.bottomAnchor)
    ]
    
    private lazy var savingModeOffDescriptionLabelConstraints = [
        resultContainterView.heightAnchor.constraint(
            equalToConstant: Design.resultContainerViewHeight),
        savingModeOffDescriptionLabel.centerYAnchor.constraint(
            equalTo: resultContainterView.centerYAnchor),
        savingModeOffDescriptionLabel.centerXAnchor.constraint(
            equalTo: resultContainterView.centerXAnchor)
    ]
    
    private func setResultContainerViewConstraints(isActivateSaving: Bool) {
        if isActivateSaving == true {
            NSLayoutConstraint.activate(keywordsTableViewConstraints)
            NSLayoutConstraint.deactivate(savingModeOffDescriptionLabelConstraints)
        } else {
            NSLayoutConstraint.activate(savingModeOffDescriptionLabelConstraints)
            NSLayoutConstraint.deactivate(keywordsTableViewConstraints)
        }
    }
    
    private func configureKeywordsTableView() {
        keywordsTableView.delegate = self
        keywordsTableView.dataSource = self
        keywordsTableView.register(cellWithClass: RecentSearchKeywordTableViewCell.self)
    }
    
    private func bindViewModel() {
        guard let viewModel = viewModel else { return }
        titleLabel.text = viewModel.title
        switchTitleLabel.text = viewModel.savingSwtichTitle
        deleteAllButton.titleLabel?.text = viewModel.deleteAllButtonTitle
        savingModeOffDescriptionLabel.text = viewModel.savingModeOffDescription
        
        let isActivateSaving = viewModel.isActivateSavingButton
        savingSwitch.isOn = isActivateSaving
        setResultContainerViewConstraints(isActivateSaving: isActivateSaving)
    }
    
    @objc
    private func savingSwitchValueDidChanged(sender: UISwitch) {
        if sender.isOn {
            setResultContainerViewConstraints(isActivateSaving: true)
        } else {
            setResultContainerViewConstraints(isActivateSaving: false)
        }
    }
    
}

extension RecentSearchKeywordViewController: UITableViewDataSource {
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int)
    -> Int
    {
        return viewModel?.numberOfSearchKeywordCell ?? 0
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath)
    -> UITableViewCell
    {
        let cell = keywordsTableView.dequeueReusableCell(
            withClass: RecentSearchKeywordTableViewCell.self,
            for: indexPath)
        guard let viewModel = viewModel?.searchKeywordCellModel(at: indexPath) else {
            return UITableViewCell()
        }
        cell.bind(viewModel: viewModel)
        return cell
    }
    
}

extension RecentSearchKeywordViewController: UITableViewDelegate {
    
}

private enum Design {
    
    static let paddingLeading: CGFloat = 25
    static let paddingTrailing: CGFloat = 25
    static let paddingTop: CGFloat = 20
    
    static let switchTitleLabelTrialingMargin: CGFloat = 7
    static let titleLabelBottomMargin: CGFloat = 20
    static let deleteAllButtonTopMargin: CGFloat = 13
    static let deleteAllButtonBottomMargin: CGFloat = 13
    
    static let resultContainerViewHeight: CGFloat = 60
    
}
