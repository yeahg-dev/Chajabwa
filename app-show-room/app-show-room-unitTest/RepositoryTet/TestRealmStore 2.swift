//
//  TestRealmStore.swift
//  app-show-room-unitTest
//
//  Created by Moon Yeji on 2023/01/10.
//

@testable import app_show_room
import Foundation

import RealmSwift

final class TestRealmStore: RealmStore {
    
    var realm: Realm
    var serialQueue: DispatchQueue
    
    init(configuration: Realm.Configuration) {
        realm = try! Realm(configuration: configuration)
        serialQueue = DispatchQueue.main
    }
    
}
