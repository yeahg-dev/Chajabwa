//
//  CountryCodeList.swift
//  app-show-room
//
//  Created by Moon Yeji on 2023/02/13.
//

import Foundation

/**
    [공공데이터포털] 외교부_국가·지역별 표준코드의 응답 JSON 포맷
 
    참고 : [공공데이터포털 외교부_국가·지역별 표준코드](https://www.data.go.kr/data/15075346/openapi.do)
*/

struct CountryCodeList: Decodable {
    
    let currentCount: Int
    let data: [CountryCode]
    let numOfRows: Int
    let pageNo: Int
    let resultCode: Int
    let resultMsg: String
    let totalCount: Int
    
}
