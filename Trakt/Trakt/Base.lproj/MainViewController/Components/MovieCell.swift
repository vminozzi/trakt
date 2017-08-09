//
//  MovieCell.swift
//  Trakt
//
//  Created by Vinicius on 07/08/17.
//  Copyright © 2017 vm. All rights reserved.
//

import UIKit
import Kingfisher

struct MovieDTO {
    var imageURL: String?
    var title = ""
    var year = ""
    var traktId: Int?
}

class MovieCell: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var yearLbl: UILabel!
    var traktId: Int?
    
    func fill(dto: MovieDTO) {
        titleLbl.text = dto.title
        yearLbl.text = dto.year
        traktId = dto.traktId
        fillImage(imageURL: dto.imageURL)
    }
    
    func fillImage(imageURL: String?) {
        if let imageURL = imageURL {
            self.image.kf.setImage(with: URL(string: imageURL.addIamgePath()))
        }
    }
}
