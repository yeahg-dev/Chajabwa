//
//  AppFolderDetailHeaderView.swift
//  app-show-room
//
//  Created by Moon Yeji on 2023/01/22.
//

import UIKit

class AppFolderDetailHeaderView: UIView {
    
    private let blurBackgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    private let appFolderIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = Design.appFolderIconImageViewCornerRadius
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let appFolderNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Design.appFolderNameLabelFont
        label.textColor = Design.appFolderNameLabelTextColor
        return label
    }()
    
    private let appFolderDescriptionTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = Design.appFolderDescriptionTextViewFont
        textView.textColor = Design.appFolderDescriptionTextViewTextColor
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.textAlignment = .natural
        textView.backgroundColor = Design.appFolderDescriptionTextViewBackgroundColor
        return textView
    }()
    
    private var cancellableTasks = [CancellableTask?]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        cancellableTasks.forEach { task in
            task.cancelTask()
        }
    }
    
    private func addSubviews() {
        addSubview(blurBackgroundImageView)
        addSubview(appFolderIconImageView)
        addSubview(appFolderNameLabel)
        addSubview(appFolderDescriptionTextView)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            blurBackgroundImageView.leadingAnchor.constraint(
                equalTo: self.leadingAnchor),
            blurBackgroundImageView.topAnchor.constraint(
                equalTo: self.topAnchor),
            blurBackgroundImageView.trailingAnchor.constraint(
                equalTo: self.trailingAnchor),
            blurBackgroundImageView.bottomAnchor.constraint(
                equalTo: self.bottomAnchor),
            appFolderIconImageView.widthAnchor.constraint(
                equalToConstant: Design.appFolderIconImageViewWidth),
            appFolderIconImageView.heightAnchor.constraint(
                equalTo: appFolderIconImageView.widthAnchor),
            appFolderIconImageView.centerXAnchor.constraint(
                equalTo: self.centerXAnchor),
            appFolderIconImageView.topAnchor.constraint(
                equalTo: self.topAnchor,
                constant: Design.iconImageViewMarginTop),
            appFolderNameLabel.centerXAnchor.constraint(
                equalTo: self.centerXAnchor),
            appFolderNameLabel.topAnchor.constraint(
                equalTo: appFolderIconImageView.bottomAnchor,
                constant: Design.iconImageViewMarginBottom),
            appFolderNameLabel.heightAnchor.constraint(
                equalToConstant: Design.appFolderNameLabelHeight),
            appFolderDescriptionTextView.leadingAnchor.constraint(
                equalTo: blurBackgroundImageView.leadingAnchor,
                constant: Design.appFolderDescriptionTextViewMarginLeading),
            appFolderDescriptionTextView.topAnchor.constraint(
                equalTo: appFolderNameLabel.bottomAnchor,
                constant: Design.sapcing),
            appFolderDescriptionTextView.trailingAnchor.constraint(
                equalTo: blurBackgroundImageView.trailingAnchor,
                constant: -Design.appFolderDescriptionTextViewMarginTrailing),
            appFolderDescriptionTextView.heightAnchor.constraint(
                equalToConstant: Design.appFolderDescriptionTextViewHeight),
            appFolderDescriptionTextView.bottomAnchor.constraint(
                equalTo: blurBackgroundImageView.bottomAnchor,
                constant: -Design.appFolderDescriptionTextViewMarginBottom),
        ])
    }
    
    func bind(iconImageURL: String?, blurImageURL: String?, name: String?, description: String?) {
        appFolderNameLabel.text = name
        appFolderDescriptionTextView.text = description
        Task {
            let iconImageViewTask = try await appFolderIconImageView.setImage(
                with: iconImageURL,
                defaultImage: UIImage(withBackground: Color.mauveLavender))
            let backgroundImageTask = try await blurBackgroundImageView.setImage(
                with: blurImageURL,
                applying: 40,
                defaultImage: UIImage(withBackground: Color.mauveLavender))
            cancellableTasks.append(contentsOf: [iconImageViewTask, backgroundImageTask])
        }
    }
    
}

private enum Design {

    static let appFolderIconImageViewWidth: CGFloat = 120
    static let appFolderIconImageViewCornerRadius: CGFloat = 12
    static let appFolderNameLabelHeight: CGFloat = 20
    static let appFolderDescriptionTextViewHeight: CGFloat = 60
    
    static let iconImageViewMarginTop: CGFloat = 100
    static let iconImageViewMarginBottom: CGFloat = 30
    static let appFolderDescriptionTextViewMarginLeading: CGFloat = 20
    static let appFolderDescriptionTextViewMarginTrailing: CGFloat = 20
    static let appFolderDescriptionTextViewMarginBottom: CGFloat = 15
    static let sapcing: CGFloat = 10
    
    static let appFolderNameLabelFont: UIFont = .preferredFont(forTextStyle: .title2)
    static let appFolderDescriptionTextViewFont: UIFont = .preferredFont(forTextStyle: .callout)
    
    static let appFolderNameLabelTextColor: UIColor = .white
    static let appFolderDescriptionTextViewTextColor: UIColor = .white
    static let appFolderDescriptionTextViewBackgroundColor: UIColor = .clear
}
