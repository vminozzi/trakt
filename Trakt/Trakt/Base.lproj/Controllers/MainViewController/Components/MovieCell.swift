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
    var isSelected = false
    weak var delegate: FavoriteDelegate?
}

class MovieCell: UICollectionViewCell {
    
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var yearLbl: UILabel!
    var traktId: Int?
    
    private weak var delegate: FavoriteDelegate?
    
    func fill(dto: MovieDTO) {
        delegate = dto.delegate
        image.kf.indicatorType = .activity
        image.kf.indicator?.startAnimatingView()
        titleLbl.text = dto.title
        yearLbl.text = dto.year
        traktId = dto.traktId
        favoriteButton.isSelected = dto.isSelected
        fillImage(imageURL: dto.imageURL)
    }
    
    func fillImage(imageURL: String?) {
        if let imageURL = imageURL {
            image.kf.setImage(with: URL(string: imageURL.addIamgePath()), completionHandler: { _,_,_,_ in
                self.image.kf.indicator?.stopAnimatingView()
            })
        }
    }
    
    @IBAction func favorite() {
        if let traktId = traktId {
            delegate?.didFavorite(trakId: traktId)
            favoriteButton.isSelected = !favoriteButton.isSelected
        }
    }
}
