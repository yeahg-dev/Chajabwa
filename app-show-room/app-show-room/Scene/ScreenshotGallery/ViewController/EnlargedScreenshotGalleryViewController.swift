//
//  ScreenshotGalleryViewController.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/08/17.
//

import UIKit

final class ScreenshotGalleryViewController: UIViewController {
    
    private var screenshotGalleryView: ScreenshotGalleryView
    
    init(viewModel: ScreenshotGalleryViewDataSource) {
        self.screenshotGalleryView = ScreenshotGalleryView(
            viewModel: viewModel,
            style: .enlarged)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(screenshotGalleryView)
        setConstraints()
    }

    private func setConstraints() {
        view.translatesAutoresizingMaskIntoConstraints = false
        screenshotGalleryView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            screenshotGalleryView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor),
            screenshotGalleryView.topAnchor.constraint(
                equalTo: view.topAnchor),
            screenshotGalleryView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor),
            screenshotGalleryView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor)
        ])

    }
}
