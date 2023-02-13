//
//  CountryCode.swift
//  app-show-room
//
//  Created by Moon Yeji on 2023/02/13.
//

import Foundation

/**
    [공공데이터포털] 외교부_국가·지역별 표준코드의 응답 data 필드 JSON 포맷
 
     **변수 설명**
     - countryEngNm : 영문 국가명 ("Korea")
     - countryISOAlp2 : ISO 2자리 코드 ("KR")
     - countryNm :  한글 국가명 ("대한민국")
     - isoAlp3 : ISO 3자리 코드 ("KOR")
     - isoNum : ISO 숫자 코드 ("410")
 
    참고 : [공공데이터포털 외교부_국가·지역별 표준코드](https://www.data.go.kr/data/15075346/openapi.do)
*/

struct CountryCode: Codable {
    
    let countryEngNm: String
    let countryISOAlp2: String
    let countryNm: String
    let isoAlp3: String
    let isoNum: String

    enum CodingKeys: String, CodingKey {
        case countryEngNm = "country_eng_nm"
        case countryISOAlp2 = "country_iso_alp2"
        case countryNm = "country_nm"
        case isoAlp3 = "iso_alp3"
        case isoNum = "iso_num"
    }
    
}
