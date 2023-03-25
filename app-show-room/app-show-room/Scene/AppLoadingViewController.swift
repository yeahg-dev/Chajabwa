//
//  AppLoadingViewController.swift
//  app-show-room
//
//  Created by Moon Yeji on 2023/03/26.
//

import UIKit

class AppLoadingViewController: UIViewController {
    
    private let loadingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .subheadline, compatibleWith: nil)
        label.text = Texts.loading
        label.textColor = Design.mainColor
        return label
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.color = Design.mainColor
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        activityIndicator.startAnimating()
    }
    
    private func configureView() {
        view.backgroundColor = Design.backgroundColor
        view.addSubview(activityIndicator)
        view.addSubview(loadingLabel)
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(
                equalTo: view.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(
                equalTo: view.centerXAnchor),
            loadingLabel.centerXAnchor.constraint(
                equalTo: view.centerXAnchor),
            loadingLabel.topAnchor.constraint(
                equalTo: activityIndicator.bottomAnchor,
                constant: Design.spacing)
        ])
    }
    
}

private enum Design {
    
    static let backgroundColor = Colors.lilac.color
    static let mainColor = UIColor.black
    
    static let spacing: CGFloat = 13
    
}
