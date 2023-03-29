//
//  RealmStore.swift
//  app-show-room
//
//  Created by Moon Yeji on 2023/01/10.
//

import Foundation

import RealmSwift

protocol RealmStore {
    
    var realm: Realm { get }
    var serialQueue: DispatchQueue { get }
}
