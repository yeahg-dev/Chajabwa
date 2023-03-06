//
//  AppFolderDetailTableViewEmptyView.swift
//  app-show-room
//
//  Created by Moon Yeji on 2023/01/22.
//

import UIKit

class AppFolderDetailTableViewEmptyView: UIView {
    
    private let guideLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Design.guideLabelFont
        label.textColor = Design.guideLabelTextColor
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    private let goToSearchButtonAction: UIAction
    
    private lazy var goToSearchButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = Design.goToSearchButtonFont
        let magnifierImage = UIImage(systemName: "magnifyingglass")?.withTintColor(
            Design.magnifierImageTintColor,
            renderingMode: .alwaysOriginal)
        button.setImage(magnifierImage, for: .normal)
        button.setBackgroundColor(
            Design.goToSearchButtonBackgroundColor, for: .normal)
        button.addAction(goToSearchButtonAction, for: .touchDown)
        button.layer.cornerRadius = Design.goToSearchButtonCornerRadius
        button.layer.masksToBounds = true
        return button
    }()
    
    init(frame: CGRect, goToSearchButtonAction: UIAction) {
        self.goToSearchButtonAction = goToSearchButtonAction
        super.init(frame: frame)
        addSubviews()
        setConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        addSubview(guideLabel)
        addSubview(goToSearchButton)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            guideLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            guideLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            goToSearchButton.topAnchor.constraint(equalTo: guideLabel.bottomAnchor, constant: Design.spacing),
            goToSearchButton.widthAnchor.constraint(equalToConstant: Design.goToSearchButtonWidth),
            goToSearchButton.heightAnchor.constraint(equalToConstant: Design.goToSearcgButtonHeight),
            goToSearchButton.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
    
    func bind(guideLabelText: String?, goToSearchButtonTitle: String?) {
        guideLabel.text = guideLabelText
        goToSearchButton.setTitle(goToSearchButtonTitle, for: .normal)
    }
    
}

private enum Design {
    
    static let guideLabelFont: UIFont = .preferredFont(forTextStyle: .headline)
    static let goToSearchButtonFont: UIFont = .preferredFont(forTextStyle: .subheadline)
    
    static let guideLabelTextColor: UIColor = Colors.grayLavender.color
    static let magnifierImageTintColor: UIColor = Colors.lightSkyBlue.color
    static let goToSearchButtonBackgroundColor: UIColor = Colors.blueGreen.color
    
    static let goToSearchButtonWidth: CGFloat = 180
    static let goToSearcgButtonHeight: CGFloat = 50
    
    static let goToSearchButtonCornerRadius: CGFloat = 12
    
    static let spacing: CGFloat = 20
    
}
