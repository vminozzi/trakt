//
//  FavoriteViewModel.swift
//  Trakt
//
//  Created by Vinicius on 09/08/17.
//  Copyright © 2017 vm. All rights reserved.
//

import Foundation


class FavoriteViewModel: FavoriteDelegate {

    private var favorites: [Favorite]?
    private var favoriteManager = FavoriteManager()
    private weak var delegate: LoadFavorite?
    
    init(delegate: LoadFavorite) {
        self.delegate = delegate
    }
    
    func load() {
        favorites = favoriteManager.getAllFavorites()?.reversed()
        delegate?.didLoadFavorites()
    }
    
    func numberOfRows() -> Int {
        return favorites?.count ?? 0
    }
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func dtoForRow(row: Int) -> MovieDTO {
        guard let favorite = favorites?.object(index: row) else {
            return MovieDTO()
        }
        
        return MovieDTO(imageURL: favorite.imageURL,
                        title: favorite.title,
                        year: "\(favorite.year)",
                        traktId: favorite.traktId,
                        slug: favorite.slug,
                        isSelected: favorites?.filter { $0.traktId == favorite.traktId }.count ?? 0 > 0,
                        delegate: self)
    }
    
    // MARK: - FavoriteDelegate
    func didFavorite(trakId: Int) {
        if let favorite = favorites?.filter ({ $0.traktId == trakId }).first {
            favoriteManager.remove(favorite: favorite)
            load()
        }
    }
}
