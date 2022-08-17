//
//  BaseAppDetailCollectionViewCellModel.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/08/15.
//

import Foundation

struct BaseAppDetailCollectionViewCellModel {
    
    let app: AppDetail
    
    init(app: AppDetail) {
        self.app = app
    }
    
    var iconImageURL: String? { app.iconImageURL }
    var name: String? { app.appName }
    var provider: String? { app.provider }
    var price: String? { app.price }

}
