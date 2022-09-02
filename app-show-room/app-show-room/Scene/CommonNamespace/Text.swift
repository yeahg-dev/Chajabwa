//
//  Text.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/09/01.
//

import Foundation

enum Text: String {
    
    case provider = "제공자"
    case fileSize = "크기"
    case contentAdvisoryRating = "등급"
    case genre = "카테고리"
    case minimumOSVersion = "최소 OS 버전"
    case developerWebsite = "개발자 웹 사이트"
    case version = "버전"
    
    case download = "받기"
    case moreDetails = "더 보기"
    case preview = "간략히"
    
    var value: String {
        return self.rawValue
    }
    
}
