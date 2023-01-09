//
//  Array+Extension.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/12/21.
//

import Foundation

extension Array {
    
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript(safe index: Index) -> Element? {
        
        switch indices.contains(index) {
        case true:
            return self[index]
        case false:
            return nil
        }
    }
  
}
