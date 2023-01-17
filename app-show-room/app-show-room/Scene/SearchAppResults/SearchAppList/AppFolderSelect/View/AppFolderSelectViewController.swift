//
//  AppFolderSelectViewController.swift
//  app-show-room
//
//  Created by Moon Yeji on 2023/01/13.
//

import Combine
import UIKit

class AppFolderSelectViewController: UIViewController {
    
    private var cancellables = Set<AnyCancellable>()
    
    private let viewModel: AppFolderSelectViewModel
    
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
    
    private lazy var saveButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundColor(Design.saveButtonColor, for: .normal)
        button.setBackgroundColor(Design.saveButtonDisableColor, for: .disabled)
        button.titleLabel?.textColor = Design.saveButtonTitleColor
        button.titleLabel?.font = Design.saveButtonTitleFont
        button.layer.cornerRadius = Design.saveButtonCornerRadius
        button.layer.masksToBounds = true
        button.addTarget(
            self,
            action: #selector(saveButtonDidTapped),
            for: .touchDown)
        button.isEnabled = false
        return button
    }()
    
    init(appUnit: AppUnit, iconImageURL: String?) {
        viewModel = AppFolderSelectViewModel(
            appUnit: appUnit,
            iconImageURL: iconImageURL)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Design.backgroundColor
        configureNavigationBar()
        configureTableView()
        addSubviews()
        setConstraints()
        bind(viewModel: viewModel)
        refreshAppFolderTableView()
    }
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.tintColor = Design.navigationBarTintColor
    }
    
    private func configureTableView() {
        appFolderTableView.register(cellWithClass: AppFolderTableViewCell.self)
        appFolderTableView.delegate = self
        appFolderTableView.dataSource = viewModel
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
                constant: -Design.saveButtonPaddingLeading),
            saveButton.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: Design.saveButtonPaddingLeading),
            saveButton.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -Design.saveButtonPaddingLeading),
            saveButton.bottomAnchor.constraint(
                equalTo: view.bottomAnchor,
                constant: -Design.saveButtonPaddingBottom),
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
    
    private func bind(viewModel: AppFolderSelectViewModel) {
        saveButton.setTitle(viewModel.saveButtonTitle, for: .normal)
        navigationItem.title = viewModel.navigationTitle
        viewModel.saveButtonIsEnabled
            .receive(on: RunLoop.main)
            .sink {
                self.saveButton.isEnabled = $0 }
            .store(in: &cancellables)
    }
    
    @objc
    private func saveButtonDidTapped() {
        Task {
            let result = await viewModel.saveButtonDidTapped()
            await MainActor.run {
                switch result {
                case .success(_):
                    navigationController?.popViewController(animated:true)
                case .failure(let alertViewModel):
                    presentAlert(alertViewModel)
                }
            }
        }
    }
    
}

extension AppFolderSelectViewController: UITableViewDelegate {
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.didSelectCell(at: indexPath)
        appFolderTableView.reloadRows(at: [indexPath], with: .none)
    }
    
}

extension AppFolderSelectViewController: AppFolderSelectViewUpdater {
    
    func refreshAppFolderTableView() {
        Task {
            await viewModel.fetchLatestData()
            await MainActor.run {
                appFolderTableView.reloadData()
            }
        }
    }
    
}

private enum Design {
    
    static let saveButtonHeight: CGFloat = 60
    
    static let saveButtonCornerRadius: CGFloat = 10
    
    static let saveButtonPaddingLeading: CGFloat = 20
    static let saveButtonPaddingBottom: CGFloat = 40
    
    static let navigationBarTintColor = Color.blueGreen
    static let backgroundColor: UIColor = Color.lightSkyBlue
    static let saveButtonColor: UIColor = Color.lilac
    static let saveButtonDisableColor: UIColor = Color.lightGray
    
    static let saveButtonTitleColor: UIColor = .white
    static let saveButtonTitleFont: UIFont = .preferredFont(forTextStyle: .headline)
    
}
