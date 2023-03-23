//
//  PrepareProgressViewController.swift
//  app-show-room
//
//  Created by Moon Yeji on 2023/03/22.
//

import UIKit

class PrepareProgressViewController: UIViewController {
    
    private let progress: Progress
    
    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.trackTintColor = Colors.skyBlue.color
        progressView.progressTintColor = Colors.blueGreen.color
        progressView.observedProgress = progress
        return progressView
    }()
 
    init(progress: Progress) {
        self.progress = progress
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
    }
    
    private func configureLayout() {
        view.addSubview(progressView)
        progressView.frame = CGRect(x: 0, y: 0, width: Design.width, height: Design.height)
        self.preferredContentSize = progressView.frame.size
    }
    
}

private enum Design {
    
    static let width: CGFloat = 170
    static let height: CGFloat = 30
    
}
