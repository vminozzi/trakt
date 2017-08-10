//
//  UITableViewCell+Extension.swift
//  Trakt
//
//  Created by Vinicius on 10/08/17.
//  Copyright © 2017 vm. All rights reserved.
//

import UIKit

extension UITableViewCell {
    class func createCell<T: UITableViewCell>(tableView: UITableView, indexPath: IndexPath) -> T {
        if let cell =  tableView.dequeueReusableCell(withIdentifier: String(describing: T.self), for: indexPath) as? T {
            return cell
        }
        return T()
    }
}
