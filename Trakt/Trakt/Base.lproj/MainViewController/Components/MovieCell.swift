//
//  MovieCell.swift
//  Trakt
//
//  Created by Vinicius on 07/08/17.
//  Copyright © 2017 vm. All rights reserved.
//

import UIKit

struct MovieDTO {
    var imageURL = ""
    var title = ""
    var year = ""
}

class MovieCell: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var yearLbl: UILabel!
    
    func fill(dto: MovieDTO) {
        self.titleLbl.text = dto.title
        self.yearLbl.text = dto.year
    }
}
