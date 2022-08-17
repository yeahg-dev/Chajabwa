//
//  EnlargedScreenshotGalleryViewController.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/08/17.
//

import UIKit

final class EnlargedScreenshotGalleryViewController: UIViewController {
    
    private var screenshotGalleryView: ScreenshotGalleryView
    
    init(viewModel: ScreenshotGalleryViewModel) {
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
        self.view.addSubview(screenshotGalleryView)
        self.setConstraints()
    }

    private func setConstraints() {
        self.view.translatesAutoresizingMaskIntoConstraints = false
        self.screenshotGalleryView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            screenshotGalleryView.leadingAnchor.constraint(
                equalTo: self.view.leadingAnchor),
            screenshotGalleryView.topAnchor.constraint(
                equalTo: self.view.topAnchor),
            screenshotGalleryView.trailingAnchor.constraint(
                equalTo: self.view.trailingAnchor),
            screenshotGalleryView.bottomAnchor.constraint(
                equalTo: self.view.bottomAnchor)
        ])

    }
}
