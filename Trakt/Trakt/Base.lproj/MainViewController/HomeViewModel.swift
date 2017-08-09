//
//  HomeViewModel.swift
//  Trakt
//
//  Created by Vinicius on 07/08/17.
//  Copyright © 2017 vm. All rights reserved.
//

import Foundation

typealias Imagelala = [Int: String]

class HomeViewModel {

    private weak var delegate: LoadContent?
    private var movies = [Movie]()
    private var request = Request()
    
    private var lala = Imagelala()
    
    init(delegate: LoadContent) {
        self.delegate = delegate
    }
    
    func loadContent() {
        request.getMovies { movies in
            if let movies = movies {
                self.movies = movies
                self.imagesRequest()
            }
            self.delegate?.didLoadContent(success: movies != nil)
        }
    }
    
    func imagesRequest() {
        movies.forEach { movie in request.getImages(traktId: movie.ids?.tmdb, completion: { imageURL in
            if let tmdb = movie.ids?.tmdb, let imageURL = imageURL {
                self.lala[tmdb] = imageURL
                self.delegate?.didLoadImage(imageURL: imageURL, traktId: movie.ids?.tmdb)
            }
        }) }
    }
    
    func numberOfRows() -> Int {
        return movies.count
    }
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func dtoForRow(row: Int) -> MovieDTO {
        guard let movie = movies.object(index: row), let tmdb = movie.ids?.tmdb else {
            return MovieDTO()
        }
        
        return MovieDTO(imageURL: lala[tmdb] ?? "", title: movie.title, year: "\(movie.year)", traktId: movie.ids?.tmdb)
    }
}
