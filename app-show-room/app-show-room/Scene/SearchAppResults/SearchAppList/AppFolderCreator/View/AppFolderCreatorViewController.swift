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
        configureLayout()
        view.backgroundColor = Design.backgroundColor
    }
    
    private lazy var navigationBar: UINavigationBar = {
        let statusBarHeight: CGFloat = 60
        let bar = UINavigationBar(
            frame: .init(
                x: 0,
                y: 0,
                width: view.frame.width,
                height: statusBarHeight))
        bar.isTranslucent = false
        bar.backgroundColor = Design.backgroundColor
        return bar
    }()
    
    private let folderNameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .none
        textField.backgroundColor = Design.textFieldBackgroundColor
        textField.placeholder = "폴더 이름(3자 이상)"
        return textField
    }()
    
    private let folderDescriptionTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = Design.textViewBackgroundColor
        return textView
    }()
    
    private let doneButton: UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("완료", for: .normal)
        button.setBackgroundColor(Design.normalButtonColor, for: .normal)
        button.setBackgroundColor(Design.disabledButtonColor, for: .disabled)
        return button
    }()
    
    private func configureNavigationBar() {
        let navigationItem = UINavigationItem(title: "새 폴더 만들기")
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
            layoutGuide.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: Design.leadingMargin),
            layoutGuide.topAnchor.constraint(
                equalTo: view.topAnchor,
                constant: Design.topMargin),
            layoutGuide.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -Design.trailinMargin),
            layoutGuide.bottomAnchor.constraint(
                equalTo: view.bottomAnchor,
                constant: -Design.bottomMargin),
            folderNameTextField.leadingAnchor.constraint(
                equalTo: layoutGuide.leadingAnchor),
            folderNameTextField.topAnchor.constraint(
                equalTo: layoutGuide.topAnchor),
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
    
    static let spacing: CGFloat = 15
    static let topMargin: CGFloat = 20
    static let leadingMargin: CGFloat = 20
    static let trailinMargin: CGFloat = 20
    static let bottomMargin: CGFloat = 20
    
    static let descriptionTextViewHeight: CGFloat = 300
    static let doneButtonHeight: CGFloat = 80
    
    static let backgroundColor: UIColor = Color.mauveLavender
    static let textFieldBackgroundColor: UIColor = Color.favoriteLavender
    static let textViewBackgroundColor: UIColor = Color.favoriteLavender
    static let disabledButtonColor: UIColor = Color.lightGray
    static let normalButtonColor: UIColor = Color.lilac
    
}
