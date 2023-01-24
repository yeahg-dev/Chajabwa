//
//  AppFolderEditViewController.swift
//  app-show-room
//
//  Created by Moon Yeji on 2023/01/23.
//

import Combine
import UIKit

protocol AppFolderEditPresentingViewUpdater: AnyObject {

    func viewWillAppear()
    
}

class AppFolderEditViewController: UIViewController {

    var appFolderEditPresentingViewUpdater: AppFolderEditPresentingViewUpdater?
    
    private let viewModel: AppFolderEditViewModel
    
    private let navigationBar: UINavigationBar = {
        let bar = UINavigationBar()
        bar.translatesAutoresizingMaskIntoConstraints = false
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = Design.backgroundColor
        appearance.titleTextAttributes = [
            .foregroundColor: Design.navigationBarTitleTextColor,
            .font: UIFont.preferredFont(forTextStyle: .title3)]
        bar.standardAppearance = appearance
        return bar
    }()
    
    private let folderNameTextField: FolderNameTextField = {
        let textField = FolderNameTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .none
        textField.textColor = Design.textFieldTextColor
        return textField
    }()
    
    private let folderDescriptionTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = Design.textViewBackgroundColor
        textView.layer.cornerRadius = Design.descriptionTextViewCornerRadius
        textView.textContainerInset = UIEdgeInsets(
            top: Design.textContainerInsetTop,
            left: Design.textContainerInsetLeft,
            bottom: Design.textContainerInsetBottom,
            right: Design.textContainerInsetRight)
        textView.isScrollEnabled = false
        textView.font = Design.textViewFont
        textView.textColor = Design.textViewTextColor
        return textView
    }()
    
    private lazy var doneButton: UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundColor(Design.normalButtonColor, for: .normal)
        button.setBackgroundColor(Design.disabledButtonColor, for: .disabled)
        button.titleLabel?.font = Design.buttonFont
        button.layer.cornerRadius = Design.doneButtonCornerRadius
        button.layer.masksToBounds = true
        button.addTarget(
            self,
            action: #selector(doneButtonDidTapped),
            for: .touchDown)
        return button
    }()
    
    private let appFolderNameDidChanged = PassthroughSubject<String?, Never>()
    private let appFolderDescritpionDidChanged = PassthroughSubject<String?, Never>()
    private let doneButtondidTapped = PassthroughSubject<AppFolderEditViewModel.AppFolderData, Never>()
    private let cancelButtonDidTapped = PassthroughSubject<Void, Never>()
    
    private var cancellables = Set<AnyCancellable>()
    
    
    init(appFolderIdentifier: String) {
        self.viewModel = AppFolderEditViewModel(appFolderIdentifier: appFolderIdentifier)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Design.backgroundColor
        configureLayout()
        bind()
        folderNameTextField.delegate = self
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
    
    private func bind() {
        let input = AppFolderEditViewModel.Input(
            appFolderNameDidChange: appFolderNameDidChanged.eraseToAnyPublisher(),
            appFolderDescriptionDidChange: appFolderDescritpionDidChanged.eraseToAnyPublisher(),
            saveButtonDidTapped: doneButtondidTapped.eraseToAnyPublisher(),
            closeButtonDidTapped: cancelButtonDidTapped.eraseToAnyPublisher())
        
        let output = viewModel.transform(input)
        
        folderNameTextField.placeholder = output.folderNameTextFieldPlaceholder
        doneButton.setTitle(output.doneButtonTitle, for: .normal)
        folderNameTextField.text = output.appFolderName
        folderDescriptionTextView.text = output.appFolderDescription
        
        let navigationItem = UINavigationItem(title: output.navigationBarTitle)
        navigationBar.items = [navigationItem]
        
        output.doneButtonIsEnabled
            .receive(on: RunLoop.main)
            .sink { [weak self] isEnabled in
                self?.doneButton.isEnabled = isEnabled
            }.store(in: &cancellables)
        
        output.alertViewModel
            .receive(on: RunLoop.main)
            .sink { [weak self] alertViewModel in
                self?.presentAlert(alertViewModel)
            }.store(in: &cancellables)
        
        output.presentingViewWillUpdate
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.appFolderEditPresentingViewUpdater?.viewWillAppear()
            }.store(in: &cancellables)
        
        output.dismiss
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.dismiss(animated: true)
            }.store(in: &cancellables)
  
    }

    @objc private func doneButtonDidTapped() {
        let appFolderData = AppFolderEditViewModel.AppFolderData(
            name: folderNameTextField.text ?? "",
            descritpion: folderDescriptionTextView.text ?? "")
        doneButtondidTapped.send(appFolderData)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            self.folderNameTextField.resignFirstResponder()
            self.folderDescriptionTextView.resignFirstResponder()
        }

}

extension AppFolderEditViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        appFolderNameDidChanged.send(textField.text)
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        folderDescriptionTextView.becomeFirstResponder()
         return true
      }
    
}

private enum Design {
    
    static let spacing: CGFloat = 30
    static let topMargin: CGFloat = 30
    static let leadingMargin: CGFloat = 35
    static let trailinMargin: CGFloat = 35
    static let bottomMargin: CGFloat = 50
    
    static let descriptionTextViewCornerRadius: CGFloat = 10
    static let doneButtonCornerRadius: CGFloat = 10
    
    static let navigationBarHeiht: CGFloat = 60
    static let textFieldHeight: CGFloat = 50
    static let descriptionTextViewHeight: CGFloat = 150
    static let doneButtonHeight: CGFloat = 60
    
    // textContainer
    static let textContainerInsetTop: CGFloat = 10
    static let textContainerInsetLeft: CGFloat = 10
    static let textContainerInsetBottom: CGFloat = 10
    static let textContainerInsetRight: CGFloat = 10
    
    static let textViewFont: UIFont = .preferredFont(forTextStyle: .footnote)
    static let buttonFont: UIFont = .preferredFont(forTextStyle: .headline)
    
    static let backgroundColor: UIColor = .white
    static let navigationBarTitleTextColor: UIColor = .black
    static let textFieldTextColor: UIColor = .black
    static let textFieldPlaceholderTextColor: UIColor = Color.shadeLavender
    static let textFieldBackgroundColor: UIColor = Color.grayLavender
    static let textViewTextColor: UIColor = .black
    static let textViewBackgroundColor: UIColor = Color.favoriteLavender
    static let disabledButtonColor: UIColor = Color.lightGray
    static let normalButtonColor: UIColor = Color.lilac
    
}
