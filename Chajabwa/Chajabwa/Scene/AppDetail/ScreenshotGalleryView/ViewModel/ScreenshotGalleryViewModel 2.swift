//
//  ScreenshotGalleryViewModel.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/08/29.
//

import Foundation

struct ScreenshotGalleryViewModel {
    
    private let screenshotURLs: [String]?
    let doneButtonTitle = "완료"
    
    init(screenshotURLs: [String]?) {
        self.screenshotURLs = screenshotURLs
    }
    
    var numberOfItems: Int {
        return screenshotURLs?.count ?? .zero
    }
    
    func cellItem(at indexPath: IndexPath) -> String? {
        return screenshotURLs?[indexPath.row]
    }
    
}
