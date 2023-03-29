//
//  AppFolderCreatorViewController.swift
//  app-show-room
//
//  Created by Moon Yeji on 2023/01/12.
//

import Combine
import UIKit

protocol AppFolderCreatorViewPresenter: AnyObject {
    
    func refreshView()
    
}

final class AppFolderCreatorViewController: UIViewController {
    
    weak var appFolderCreatorViewPresenting: AppFolderCreatorViewPresenter?
    
    private var viewModel: AppFolderCreatorViewModel! 
    
    private let appFolderName = PassthroughSubject<String?, Never>()
    private let appFolderDescritpion = PassthroughSubject<String?, Never>()
    private var cancellables = Set<AnyCancellable>()
    
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
    
    private let doneButton: UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundColor(Design.normalButtonColor, for: .normal)
        button.setBackgroundColor(Design.disabledButtonColor, for: .disabled)
        button.titleLabel?.font = Design.buttonFont
        button.layer.cornerRadius = Design.doneButtonCornerRadius
        button.layer.masksToBounds = true
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        configureLayout()
        view.backgroundColor = Design.backgroundColor
        folderNameTextField.becomeFirstResponder()
        folderNameTextField.delegate = self
    }
    
    private func bind() {
        viewModel = AppFolderCreatorViewModel(
            appFolderName: appFolderName.eraseToAnyPublisher(),
            appFolderDescription: appFolderDescritpion.eraseToAnyPublisher())
        
        let navigationItem = UINavigationItem(title: viewModel.navigationBarTitle)
        navigationBar.items = [navigationItem]
        
        folderNameTextField.attributedPlaceholder = NSAttributedString(
            string: viewModel.folderNameTextFieldPlaceholder,
            attributes: [.foregroundColor: Design.textFieldPlaceholderTextColor])
        doneButton.setTitle(viewModel.doneButtonTitle, for: .normal)
        viewModel.doneButtonIsEnabled
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                self?.doneButton.isEnabled = $0 }
            .store(in: &cancellables)
        doneButton.addTarget(
            self,
            action: #selector(doneButtonDidTapped),
            for: .touchDown)
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
                    appFolderCreatorViewPresenting?.refreshView()
                    self.dismiss(animated: true)
                case .failure(let alertViewModel):
                    presentAlert(alertViewModel)
                }
            })
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            self.folderNameTextField.resignFirstResponder()
            self.folderDescriptionTextView.resignFirstResponder()
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
    static let textFieldPlaceholderTextColor: UIColor = Colors.shadeLavender.color
    static let textFieldBackgroundColor: UIColor = Colors.grayLavender.color
    static let textViewTextColor: UIColor = .black
    static let textViewBackgroundColor: UIColor = Colors.favoriteLavender.color
    static let disabledButtonColor: UIColor = Colors.lightGray.color
    static let normalButtonColor: UIColor = Colors.lilac.color
    
}
