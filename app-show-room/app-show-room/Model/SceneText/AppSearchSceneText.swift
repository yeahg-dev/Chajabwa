//
//  AppSearchSceneText.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/08/12.
//

import Foundation

enum AppSearchSceneText {
    
    static var searchBarPlaceholder: String { "ID를 입력해주세요" }
    static var invalidInputAlertText: AlertText { InvalidInputAlertText() }
    static var searchFailureAlertText: AlertText { SearchFailureAlertText() }
    
    struct InvalidInputAlertText: AlertText {
        
        var title: String? = "ID를 다시 확인해주세요"
        var message: String? = "숫자만 입력할 수 있어요"
        var alertAction: String? = "확인"
    }
    
    struct SearchFailureAlertText: AlertText {
        
        var title: String? = "검색에 실패했습니다"
        var message: String? = "다시 시도해주세요🙏🏻"
        var alertAction: String? = "확인"
    }
    
}
