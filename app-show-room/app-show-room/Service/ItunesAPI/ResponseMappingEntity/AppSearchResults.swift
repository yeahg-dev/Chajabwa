//
//  AppSearchResults.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/12/21.
//

import Foundation

struct AppSearchResults: AppLookupResponse {
    
    let resultCount: Int
    let results: [AppSummary]
    
}
