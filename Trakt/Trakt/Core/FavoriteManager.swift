//
//  FavoriteManager.swift
//  Trakt
//
//  Created by Vinicius on 09/08/17.
//  Copyright © 2017 vm. All rights reserved.
//

import Foundation
import RealmSwift

class FavoriteManager {
    
    func save(movie: Movie, imageURL: String) {
        let favorite = Favorite()
        favorite.traktId = movie.ids?.tmdb ?? 0
        favorite.title = movie.title
        favorite.imageURL = imageURL
        favorite.year = movie.year
        favorite.slug = movie.ids?.slug ?? ""
        
        let realm = try? Realm()
        try? realm?.write {
            realm?.add(favorite)
        }
    }
    
    func remove(favorite: Favorite) {
        let realm = try? Realm()
        try? realm?.write {
            realm?.delete(favorite)
        }
    }
    
    func getAllFavorites() -> [Favorite]? {
        let realm = try? Realm()
        return realm?.objects(Favorite.self).toArray(ofType: Favorite.self)
    }
}

extension Results {
    func toArray<T>(ofType: T.Type) -> [T] {
        var array = [T]()
        for i in 0 ..< count {
            if let result = self[i] as? T {
                array.append(result)
            }
        }
        return array
    }
}
