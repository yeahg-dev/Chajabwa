//
//  UICollectionView+Extension.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/08/16.
//

import UIKit

extension UICollectionView {

    func register<T: UICollectionViewCell>(_ cellClass: T.Type) {
        let reuseIdentifier = cellClass.className
        register(cellClass, forCellWithReuseIdentifier: reuseIdentifier)
    }
 
    func dequeueReusableCell<T: UICollectionViewCell>(
        _ cellClass: T.Type,
        for indexPath: IndexPath) -> T {
            guard let cell = dequeueReusableCell(
                withReuseIdentifier: cellClass.className,
                for: indexPath
            ) as? T else {
                fatalError(
                    "Couldn't find UICollectionViewCell for \(String(describing: cellClass.className)), make sure the cell is registered with collection view")
            }
            return cell
    }

}
