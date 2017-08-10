//
//  DetailCell.swift
//  Trakt
//
//  Created by Vinicius on 10/08/17.
//  Copyright © 2017 vm. All rights reserved.
//

import UIKit

class DetailCell: UITableViewCell {
    
    @IBOutlet weak var titleLbl: UILabel!
    
    func fill(title: String) {
        titleLbl.text = title
    }
}
