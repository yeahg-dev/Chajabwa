//
//  AppSerachSceneText.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/08/12.
//

import Foundation

struct AppSerachSceneText {
    
    let title = "검색할 앱의 ID를 입력해주세요"
    let failureResponse: AlertText = FailureAlertText()
    
    struct FailureAlertText: AlertText {
        
        var title: String? = "ID를 다시 확인해주세요"
        var message: String? = ""
        var alertAction: String? = "확인"
    }
}

protocol AlertText {
    
    var title: String? { get set }
    var message: String? { get set }
    var alertAction: String? { get set }
}
