//
//  Loader.swift
//  Trakt
//
//  Created by Vinicius on 07/08/17.
//  Copyright © 2017 vm. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func showLoader() {
        let loader = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        loader.center = view.center
        UIApplication.shared.keyWindow?.addSubview(loader)
        loader.startAnimating()
    }
    
    func dismissLoader() {
        if let loader = UIApplication.shared.keyWindow?.subviews.filter({ $0 is UIActivityIndicatorView }).first as? UIActivityIndicatorView {
            loader.stopAnimating()
            loader.removeFromSuperview()
        }
    }
}
