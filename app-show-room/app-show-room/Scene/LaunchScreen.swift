//
//  LaunchScreen.swift
//  app-show-room
//
//  Created by Moon Yeji on 2023/02/14.
//

import UIKit

final class LaunchScreenViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let launchScreenImage = UIImage(named: "launchScreen")
        let backgroundImageView = UIImageView.init(frame: self.view.frame)
        backgroundImageView.image = launchScreenImage
        backgroundImageView.contentMode = .scaleAspectFill
        self.view.insertSubview(backgroundImageView, at: 0)
    }
    
}
