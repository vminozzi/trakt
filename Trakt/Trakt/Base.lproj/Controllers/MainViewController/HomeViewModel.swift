//
//  HomeViewModel.swift
//  Trakt
//
//  Created by Vinicius on 07/08/17.
//  Copyright © 2017 vm. All rights reserved.
//

import Foundation

protocol FavoriteDelegate: class {
    func didFavorite(trakId: Int)
}

typealias ImageCache = [Int: String]

class HomeViewModel: FavoriteDelegate {

    private weak var delegate: LoadContent?
    private weak var favoriteDelegate: LoadFavorite?
    
    private var movies = [Movie]()
    private var resultMovies = [Movie]()
    private var request = Request()
    private var favoriteManager = FavoriteManager()
    private var favorites: [Favorite]?
    
    private var imageCache = ImageCache() 
    
    private var page = 1
    var shouldMakeRequest = true
    
    
    init(delegate: LoadContent, favoriteDelegate: LoadFavorite) {
        self.delegate = delegate
        self.favoriteDelegate = favoriteDelegate
    }
    
    func loadFavorites() {
        if let favorites = self.favorites, let newFavorites = favoriteManager.getAllFavorites(), favorites != newFavorites {
            self.favorites = newFavorites
            favoriteDelegate?.didLoadFavorites()
        }
    }
    
    func loadContent() {
        favorites = favoriteManager.getAllFavorites()
        
        request.getMovies(page: page) { movies in
            if let movies = movies {
                self.shouldMakeRequest = movies.count > 0
                movies.forEach { self.movies.append($0) }
                self.imagesRequest(movies: movies)
            }
            self.delegate?.didLoadContent(success: movies != nil)
        }
    }
    
    func loadMore() {
        if shouldMakeRequest {
            page += 1
            loadContent()
        }
    }
    
    func seachRequest(text: String)  {
        if text.characters.count > 2 {
            request.searchMovie(query: text) { movies in
                if let movies = movies {
                    self.resultMovies = movies
                    self.imagesRequest(movies: movies)
                    self.delegate?.didLoadContent(success: true)
                }
            }
        } else if  text.characters.count == 0 {
            resultMovies.removeAll()
            delegate?.didLoadContent(success: true)

        }
    }
    
    func imagesRequest(movies: [Movie]) {
        movies.forEach { movie in request.getImages(traktId: movie.ids?.tmdb, completion: { imageURL in
            if let tmdb = movie.ids?.tmdb, let imageURL = imageURL {
                self.imageCache[tmdb] = imageURL
                self.delegate?.didLoadImage(imageURL: imageURL, traktId: movie.ids?.tmdb)
            }
        }) }
    }
    
    func numberOfRows() -> Int {
        return resultMovies.count > 0 ? resultMovies.count : movies.count
    }
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func dtoForRow(row: Int) -> MovieDTO {
        guard let movie =  resultMovies.count > 0 ? resultMovies.object(index: row) : movies.object(index: row), let tmdb = movie.ids?.tmdb else {
            return MovieDTO()
        }
        
        
        return MovieDTO(imageURL: imageCache[tmdb] ?? "",
                        title: movie.title,
                        year: "\(movie.year)",
                        traktId: movie.ids?.tmdb,
                        slug: movie.ids?.slug ?? "",
                        isSelected: favorites?.filter { $0.traktId == movie.ids?.tmdb ?? 0 }.count ?? 0 > 0,
                        delegate: self)
    }
        
    // MARK - FavoriteDelegate
    
    func didFavorite(trakId: Int) {
        if let favorite = favorites?.filter ({ $0.traktId == trakId }).first {
            favoriteManager.remove(favorite: favorite)
            favorites = favoriteManager.getAllFavorites()
            return
        }
        
        if let movie = movies.filter ({ $0.ids?.tmdb == trakId }).first {
            favoriteManager.save(movie: movie, imageURL: imageCache[trakId] ?? "")
            favorites = favoriteManager.getAllFavorites()
        }
    }
}
