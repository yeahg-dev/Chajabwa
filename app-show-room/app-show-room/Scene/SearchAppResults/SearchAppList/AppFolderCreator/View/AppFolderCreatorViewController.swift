//
//  AppFolderCreatorViewController.swift
//  app-show-room
//
//  Created by Moon Yeji on 2023/01/12.
//

import Combine
import UIKit

protocol AppFolderSelectViewUpdater: AnyObject {
    
    func refreshAppFolderTableView()
    
}

final class AppFolderCreatorViewController: UIViewController {
    
    weak var appFolderSelectViewUpdater: AppFolderSelectViewUpdater?
    
    private var viewModel: AppFolderCreatorViewModel!
    
    private let appFolderName = PassthroughSubject<String?, Never>()
    private let appFolderDescritpion = PassthroughSubject<String?, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    private let navigationBar: UINavigationBar = {
        let bar = UINavigationBar()
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.isTranslucent = false
        bar.backgroundColor = Design.backgroundColor
        return bar
    }()
    
    private let folderNameTextField: FolderNameTextField = {
        let textField = FolderNameTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .none
        return textField
    }()
    
    private let folderDescriptionTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = Design.textViewBackgroundColor
        textView.layer.cornerRadius = Design.cornerRadius
        textView.textContainerInset = UIEdgeInsets(
            top: Design.textContainerInsetTop,
            left: Design.textContainerInsetLeft,
            bottom: Design.textContainerInsetBottom,
            right: Design.textContainerInsetRight)
        textView.isScrollEnabled = false
        textView.font = Design.textViewFont
        return textView
    }()
    
    private let doneButton: UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundColor(Design.normalButtonColor, for: .normal)
        button.setBackgroundColor(Design.disabledButtonColor, for: .disabled)
        button.titleLabel?.font = Design.buttonFont
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        configureNavigationBar()
        configureLayout()
        view.backgroundColor = Design.backgroundColor
        folderNameTextField.becomeFirstResponder()
        folderNameTextField.delegate = self
    }
    
    private func bind() {
        viewModel = AppFolderCreatorViewModel(
            appFolderName: appFolderName.eraseToAnyPublisher(),
            appFolderDescription: appFolderDescritpion.eraseToAnyPublisher())
        
        folderNameTextField.placeholder = viewModel.folderNameTextFieldPlaceholder
        doneButton.setTitle(viewModel.doneButtonTitle, for: .normal)
        viewModel.doneButtonIsEnabled
            .receive(on: RunLoop.main)
            .sink {
                self.doneButton.isEnabled = $0 }
            .store(in: &cancellables)
        doneButton.addTarget(
            self,
            action: #selector(doneButtonDidTapped),
            for: .touchDown)
    }
    
    private func configureNavigationBar() {
        let navigationItem = UINavigationItem(title: "새로운 폴더 만들기")
        navigationBar.titleTextAttributes = [ .font: UIFont.preferredFont(forTextStyle: .title3)]
        navigationBar.items = [navigationItem]
    }
    
    private func configureLayout() {
        let layoutGuide = UILayoutGuide()
        view.addLayoutGuide(layoutGuide)
        view.addSubview(navigationBar)
        view.addSubview(folderNameTextField)
        view.addSubview(folderDescriptionTextView)
        view.addSubview(doneButton)
        
        NSLayoutConstraint.activate([
            navigationBar.leadingAnchor.constraint(
                equalTo: view.leadingAnchor),
            navigationBar.topAnchor.constraint(
                equalTo: view.topAnchor),
            navigationBar.trailingAnchor.constraint(
                equalTo: view.trailingAnchor),
            navigationBar.heightAnchor.constraint(
                equalToConstant: Design.navigationBarHeiht),
            navigationBar.bottomAnchor.constraint(
                equalTo: layoutGuide.topAnchor),
            layoutGuide.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: Design.leadingMargin),
            layoutGuide.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -Design.trailinMargin),
            layoutGuide.bottomAnchor.constraint(
                equalTo: view.bottomAnchor,
                constant: -Design.bottomMargin),
            folderNameTextField.leadingAnchor.constraint(
                equalTo: layoutGuide.leadingAnchor),
            folderNameTextField.topAnchor.constraint(
                equalTo: layoutGuide.topAnchor,
                constant: Design.topMargin),
            folderNameTextField.trailingAnchor.constraint(
                equalTo: layoutGuide.trailingAnchor),
            folderDescriptionTextView.leadingAnchor.constraint(
                equalTo: layoutGuide.leadingAnchor),
            folderDescriptionTextView.topAnchor.constraint(
                equalTo: folderNameTextField.bottomAnchor,
                constant: Design.spacing),
            folderDescriptionTextView.trailingAnchor.constraint(
                equalTo: layoutGuide.trailingAnchor),
            folderDescriptionTextView.heightAnchor.constraint(
                equalToConstant: Design.descriptionTextViewHeight),
            doneButton.leadingAnchor.constraint(
                equalTo: layoutGuide.leadingAnchor),
            doneButton.trailingAnchor.constraint(
                equalTo: layoutGuide.trailingAnchor),
            doneButton.heightAnchor.constraint(
                equalToConstant: Design.doneButtonHeight),
            doneButton.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor)
        ])
        
    }
    
    @objc private func doneButtonDidTapped() {
        print(doneButton.isEnabled)
        Task {
            let result = await viewModel.doneButtonDidTapped(
                name: folderNameTextField.text,
                description: folderDescriptionTextView.text)
            await MainActor.run(body: {
                switch result {
                case .success(_):
                    appFolderSelectViewUpdater?.refreshAppFolderTableView()
                    self.dismiss(animated: true)
                case .failure(let alertViewModel):
                    presentAlert(alertViewModel)
                }
            })
        }
    }
    
    private func presentAlert(_ alertViewModel: AlertViewModel) {
        let alertController = UIAlertController(
            title: alertViewModel.alertController.title,
            message: alertViewModel.alertController.message,
            preferredStyle: alertViewModel.alertController.preferredStyle.value)
        if let alertActions = alertViewModel.alertActions {
            alertActions.forEach { actionViewModel in
                let action = UIAlertAction(
                    title: actionViewModel.title,
                    style: actionViewModel.style.value)
                alertController.addAction(action)
            }
        }
        
        present(alertController, animated: false)
    }
    
}

extension AppFolderCreatorViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        appFolderName.send(textField.text)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        appFolderName.send(textField.text)
        return true
    }
    
}

private enum Design {
    
    static let spacing: CGFloat = 30
    static let topMargin: CGFloat = 30
    static let leadingMargin: CGFloat = 35
    static let trailinMargin: CGFloat = 35
    static let bottomMargin: CGFloat = 50
    
    static let cornerRadius: CGFloat = 10
    
    static let navigationBarHeiht: CGFloat = 60
    static let textFieldHeight: CGFloat = 50
    static let descriptionTextViewHeight: CGFloat = 150
    static let doneButtonHeight: CGFloat = 60
    
    // textContainer
    static let textContainerInsetTop: CGFloat = 7
    static let textContainerInsetLeft: CGFloat = 5
    static let textContainerInsetBottom: CGFloat = 7
    static let textContainerInsetRight: CGFloat = 5
    
    static let textViewFont: UIFont = .preferredFont(forTextStyle: .footnote)
    static let buttonFont: UIFont = .preferredFont(forTextStyle: .headline)
    
    static let backgroundColor: UIColor = .white
    static let textFieldBackgroundColor: UIColor = Color.favoriteLavender
    static let textViewBackgroundColor: UIColor = Color.favoriteLavender
    static let disabledButtonColor: UIColor = Color.lightGray
    static let normalButtonColor: UIColor = Color.lilac
    
}
