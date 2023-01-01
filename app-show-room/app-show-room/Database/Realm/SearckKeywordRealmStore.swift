//
//  SearckKeywordRealmStore.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/12/31.
//

import Foundation

import RealmSwift

final class SearckKeywordRealmStore {
    
    let defaultRealm: Realm!
    
    init?() {
        do {
            defaultRealm = try Realm()
        } catch  {
            print("Error initiating new realm \(error)")
            return nil
        }
    }
    
}
