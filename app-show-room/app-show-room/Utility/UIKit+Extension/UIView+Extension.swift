//
//  UIView+Extension.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/08/17.
//

import UIKit

extension UIView {
    
    func invalidateTranslateAutoResizingMasks(of views: [UIView]) {
        for view in views {
            view.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    func toImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
              return renderer.image { rendererContext in
                  layer.render(in: rendererContext.cgContext)
              }
      }
    
}
