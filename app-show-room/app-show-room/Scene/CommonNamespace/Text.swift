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
    case genre = "장르"
    case minimumOSVersion = "최소 OS 버전"
    case developerWebsite = "개발자 웹 사이트"
    case version = "버전"
    case age = "연령"
    case old = "세"
    case developer = "개발자"
    case language = "언어"
    
    case newFeature = "새로운 기능"
    case screenshotView = "미리보기"
    case information = "정보"
    
    case download = "받기"
    case moreDetails = "더 보기"
    case preview = "간략히"
    
    case ratingCount
    case languageCount
    
    var value: String {
        return self.rawValue
    }
    
    func value(with number: Int) -> String? {
        let formattedNumber = number.formattedNumber
        switch self {
        case .ratingCount:
            return "\(formattedNumber)개의 평가"
        case .languageCount:
            return "\(formattedNumber)개의 언어"
        default :
            return nil
        }
    }
    
}
