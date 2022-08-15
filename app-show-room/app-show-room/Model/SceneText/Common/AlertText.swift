//
//  AlertText.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/08/15.
//

import Foundation

protocol AlertText {
    
    var title: String? { get set }
    var message: String? { get set }
    var alertAction: String? { get set }
}
