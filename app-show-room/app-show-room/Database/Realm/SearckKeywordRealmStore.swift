//
//  SearckKeywordRealmStore.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/12/31.
//

import Foundation

import RealmSwift

final class SearckKeywordRealmStore {
    
    var defaultRealm: Realm!
    let serialQueue: DispatchQueue
    
    init?() {
        serialQueue = DispatchQueue(label: "serial-queue")
        do {
            try serialQueue.sync {
                defaultRealm = try Realm(configuration: .defaultConfiguration, queue: serialQueue)
            }
        } catch  {
            print("Error initiating new realm \(error)")
            return nil
        }
    }
    
}
