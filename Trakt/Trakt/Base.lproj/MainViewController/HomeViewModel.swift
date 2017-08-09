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
    private var resultMovies = [Movie]()
    private var request = Request()
    
    private var lala = Imagelala()
    
    private var page = 1
    private var shouldMakeRequest = true
    
    
    init(delegate: LoadContent) {
        self.delegate = delegate
    }
    
    func loadContent() {
        request.getMovies(page: page) { movies in
            if let movies = movies {
                self.shouldMakeRequest = movies.count > 0
                movies.forEach { self.movies.append($0) }
                self.imagesRequest()
                
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
                    self.imagesRequest()
                    self.delegate?.didLoadContent(success: true)
                }
            }
        } else if  text.characters.count == 0 {
            resultMovies.removeAll()
            delegate?.didLoadContent(success: true)

        }
    }
    
    func imagesRequest() {
        let movies = resultMovies.count > 0 ? resultMovies : self.movies
        movies.forEach { movie in request.getImages(traktId: movie.ids?.tmdb, completion: { imageURL in
            if let tmdb = movie.ids?.tmdb, let imageURL = imageURL {
                self.lala[tmdb] = imageURL
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
        return MovieDTO(imageURL: lala[tmdb] ?? "", title: movie.title, year: "\(movie.year)", traktId: movie.ids?.tmdb)
    }
}
