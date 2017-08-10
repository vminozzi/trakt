//
//  DetailViewModel.swift
//  Trakt
//
//  Created by Vinicius on 10/08/17.
//  Copyright © 2017 vm. All rights reserved.
//

import Foundation

typealias TableValues = [[String]]

class DetailViewModel {
    
    private var movie: Movie?
    
    private var movieValues: TableValues?
    private weak var delegate: LoadDetail?
    
    init(delegate: LoadDetail) {
        self.delegate = delegate
    }
    
    func load(slug: String) {
        Request().getMovieDetail(slug: slug) { movie in
            self.movie = movie
            self.manipulateMovieData()
            self.delegate?.didLoadDetail(error: movie == nil)
        }
    }
    
    func manipulateMovieData() {
        var values = [String]()
        
        if let title = movie?.title {
            values.append(title)
        }
        
        if let year = movie?.year {
            values.append("\(year)")
        }
        
        if let released = movie?.released {
            values.append(released)
        }
        
        if let runtime = movie?.runtime {
            values.append("\(runtime)")
        }
        
        if let tagline = movie?.tagline {
            values.append(tagline)
        }
        
        if let overview = movie?.overview {
            values.append(overview)
        }
        
        if let rating = movie?.rating {
            values.append("\(rating)")
        }
        
        var tableValues = TableValues()
        tableValues.append(values)
        
        values = [String]()
        if let geners = movie?.genres {
            geners.forEach { values.append($0) }
            tableValues.append(values)
        }
        
        movieValues = tableValues
    }

    
    func numberOfRows(section: Int) -> Int {
        return movieValues?.object(index: section)?.count ?? 0
    }
    
    func numberOfSections() -> Int {
        return movieValues?.count ?? 0
    }
    
    func getTitleFor(row: Int, at section: Int) -> String {
        return movieValues?.object(index: section)?.object(index: row) ?? ""
    }
}
