//
//  CollectionViewCell+Extension.swift
//  Trakt
//
//  Created by Vinicius on 07/08/17.
//  Copyright © 2017 vm. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionViewCell {
    class func createCell<T: UICollectionViewCell>(collectionView: UICollectionView, indexPath: IndexPath) -> T {
        if let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: T.self), for: indexPath) as? T {
            return cell
        }
        return T()
    }
}
