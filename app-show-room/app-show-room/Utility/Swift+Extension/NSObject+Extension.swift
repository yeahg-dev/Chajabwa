//
//  NSObject+Extension.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/08/16.
//

import Foundation

extension NSObject {

    var className: String {
        return String(describing: type(of: self))
    }

    class var className: String {
        return String(describing: self)
    }

}
