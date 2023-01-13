//
//  AppFolderCreatorViewController.swift
//  app-show-room
//
//  Created by Moon Yeji on 2023/01/12.
//

import UIKit

class AppFolderCreatorViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureLayout()
        view.backgroundColor = Design.backgroundColor
        folderNameTextField.becomeFirstResponder()
    }
    
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
        textField.placeholder = "폴더 이름(3자 이상)"
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
        button.setTitle("완료", for: .normal)
        button.setBackgroundColor(Design.normalButtonColor, for: .normal)
        button.setBackgroundColor(Design.disabledButtonColor, for: .disabled)
        button.titleLabel?.font = Design.buttonFont
        return button
    }()
    
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
