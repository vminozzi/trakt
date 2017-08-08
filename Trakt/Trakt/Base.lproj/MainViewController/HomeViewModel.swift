//
//  HomeViewModel.swift
//  Trakt
//
//  Created by Vinicius on 07/08/17.
//  Copyright © 2017 vm. All rights reserved.
//

import Foundation

class HomeViewModel {

    private weak var delegate: LoadContent?
    private var movies = [Movie]()
    
    init(delegate: LoadContent) {
        self.delegate = delegate
    }
    
    func loadContent() {
        Request().requestAPI { movies in
            if let movies = movies {
                self.movies = movies
            }
            self.delegate?.didLoadContent(success: movies != nil)
        }
    }
    
    func numberOfRows() -> Int {
        return movies.count
    }
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func dtoForRow(row: Int) -> MovieDTO {
        guard let movie = movies.object(index: row) else {
            return MovieDTO()
        }
        return MovieDTO(imageURL: "", title: movie.title, year: "\(movie.year)")
    }
}
