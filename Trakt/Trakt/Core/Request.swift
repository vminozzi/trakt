//
//  Request.swift
//  Trakt
//
//  Created by Vinicius on 06/08/17.
//  Copyright © 2017 vm. All rights reserved.
//

import UIKit
import Alamofire

typealias JSONDictionary = [String: Any]

class Request {
    
    private let traktAPI = "https://api.trakt.tv/movies/popular"
    private let imageURL = "https://api.themoviedb.org/3/movie/"
    private let imageAPIKey = "fabd1d13e13b8b25c567f0e097a4cb70"
    
    let traktHeaders: HTTPHeaders = [
        "Content-Type": "application/json",
        "trakt-api-version": "2",
        "trakt-api-key": "5afd26eef7ad7f8112f54ea2a1dd300e247c546fc5000e17b371910b7f19fc10"
    ]
    
    func getMovies(completion: @escaping ((_ movies: [Movie]?) -> ())) {
        Alamofire.request(traktAPI, headers: traktHeaders).responseJSON { response in
            if let _ = response.result.error {
                completion(nil)
                return
            }
            if let json = response.result.value as? [JSONDictionary] {
                var movies = [Movie]()
                json.forEach { movies.append(Movie(JSON: $0) ?? Movie()) }
                completion(movies)
                return
            }
            completion(nil)
        }
    }
    
    func getImages(traktId: Int?, completion: @escaping ((_ imageURL: String?) -> ())) {
        guard let traktId = traktId else {
            completion(nil)
            return
        }
        
        Alamofire.request(imageURL + "\(traktId)", parameters: ["api_key" : imageAPIKey]).responseJSON { response in
            if let _ = response.result.error {
                completion(nil)
                return
            }
            
            if let json = response.result.value as? JSONDictionary, let imageURL = json["poster_path"] as? String {
                completion(imageURL)
                return
            }
            completion(nil)
        }
    }
}
