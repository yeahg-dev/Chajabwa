//
//  AppFolderSelectViewController.swift
//  app-show-room
//
//  Created by Moon Yeji on 2023/01/13.
//

import UIKit

class AppFolderSelectViewController: UIViewController {

    private lazy var appFolderCreationButton: AppFolderCreationButton = {
        let action = UIAction { [weak self] _ in
            self?.presentAppFolderCreationView()
        }
        let button = AppFolderCreationButton(frame: .zero, primaryAction: action)
        button.addAction(action)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let appFolderTableView: UITableView = {
       let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("저장", for: .normal)
        button.backgroundColor = Design.saveButtonColor
        button.titleLabel?.textColor = Design.saveButtonTitleColor
        button.titleLabel?.font = Design.saveButtonTitleFont
        button.layer.cornerRadius = Design.saveButtonCornerRadius
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Design.backgroundColor
        configureNavigationBar()
        configureTableView()
        addSubviews()
        setConstraints()
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    private func configureNavigationBar() {
        navigationController?.title = "폴더에 저장하기"
    }
    
    private func configureTableView() {
        appFolderTableView.register(cellWithClass: AppFolderTableViewCell.self)
    }
   
    private func addSubviews() {
        view.addSubview(appFolderCreationButton)
        view.addSubview(appFolderTableView)
        view.addSubview(saveButton)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            appFolderCreationButton.widthAnchor.constraint(
                equalToConstant: view.bounds.width),
            appFolderCreationButton.leadingAnchor.constraint(
                equalTo: view.leadingAnchor),
            appFolderCreationButton.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor),
            appFolderCreationButton.trailingAnchor.constraint(
                equalTo: view.trailingAnchor),
            appFolderTableView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor),
            appFolderTableView.topAnchor.constraint(
                equalTo: appFolderCreationButton.bottomAnchor),
            appFolderTableView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor),
            appFolderTableView.bottomAnchor.constraint(
                equalTo: saveButton.topAnchor,
                constant: -Design.saveButtonPadding),
            saveButton.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: Design.saveButtonPadding),
            saveButton.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -Design.saveButtonPadding),
            saveButton.bottomAnchor.constraint(
                equalTo: view.bottomAnchor,
                constant: -Design.saveButtonPadding),
            saveButton.heightAnchor.constraint(
                equalToConstant: Design.saveButtonHeight)
        ])
    }
    
    private func presentAppFolderCreationView() {
        let view = AppFolderCreatorViewController()
        view.appFolderSelectViewUpdater = self
        modalPresentationStyle = .formSheet
        present(view, animated: true)
    }
}

extension AppFolderSelectViewController: AppFolderSelectViewUpdater {
    
    func refreshAppFolderTableView() {
        appFolderTableView.reloadData()
    }
    
}

private enum Design {
    
    static let saveButtonHeight: CGFloat = 50
    
    static let saveButtonCornerRadius: CGFloat = 10
    
    static let saveButtonPadding: CGFloat = 20
    
    static let backgroundColor: UIColor = Color.lightSkyBlue
    static let saveButtonColor: UIColor = Color.lilac
    static let saveButtonDisableColor: UIColor = Color.lightGray
    
    static let saveButtonTitleColor: UIColor = .white
    static let saveButtonTitleFont: UIFont = .preferredFont(forTextStyle: .headline)
    
}
