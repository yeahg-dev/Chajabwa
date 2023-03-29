//
//  DefaultRealmStore.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/12/31.
//

import Foundation

import RealmSwift

final class DefaultRealmStore: RealmStore {
    
    var realm: Realm
    var serialQueue: DispatchQueue
    
    // MARK: - Refactoring
    init?() {
        let queue = DispatchQueue(label: "serial-queue")
        serialQueue = queue
        var initailzedRealm: Realm?
        queue.sync {
            do {
                initailzedRealm = try Realm(
                    configuration: .defaultConfiguration,
                    queue: queue)
            } catch  {
                print("Error initiating new realm \(error)")
            }
        }
        if let initailzedRealm {
            realm = initailzedRealm
        } else {
            return nil
        }
    }
    
}
