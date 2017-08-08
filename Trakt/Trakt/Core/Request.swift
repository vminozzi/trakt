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
    private let fanartAPIKey = "b1728b6862599fbb65b1aaa78b90db7c"
    private let fanartAPI = "https://webservice.fanart.tv/v3/movies/"
    
    let traktHeaders: HTTPHeaders = [
        "Content-Type": "application/json",
        "trakt-api-version": "2",
        "trakt-api-key": "5afd26eef7ad7f8112f54ea2a1dd300e247c546fc5000e17b371910b7f19fc10"
    ]
    
    func traktAPI(completion: @escaping ((_ result: [Movie]?) -> ())) {
        Alamofire.request(traktAPI, headers: traktHeaders).responseJSON { response in
            if let _ = response.result.error {
                completion(nil)
                return
            }
            
            if let json = response.result.value as? [JSONDictionary] {
                var movies = [Movie]()
                var count = 0
                json.forEach {
                    if let movie = Movie(JSON: $0) {
                        var trakt = movie
                        count += 1
                        self.fanartAPI(traktId: movie.ids?.tmdb ?? 0, completion: { (movieLogo) in
                            
                            trakt.logo = movieLogo
                            movies.append(trakt)
                            
                            if movies.count == count {
                                completion(movies)
                            }
                        })
                    }
                }
            }
        }
    }
    
    private func fanartAPI(traktId: Int, completion: @escaping ((_ movieLogo: HDMovieLogo?) -> ())) {
        Alamofire.request(fanartAPI + "\(traktId)", parameters: ["api_key" : fanartAPIKey]).responseJSON { response in
            if let _ = response.result.error {
                completion(nil)
                return
            }
            
            if let json = response.result.value as? JSONDictionary {
                if let hdmovie = json["hdmovielogo"] as? [JSONDictionary] {
                    if let movie = hdmovie.first {
                        completion(HDMovieLogo(JSON: movie) ?? HDMovieLogo())
                        return
                    }
                }
            }
            completion(nil)
        }
    }
}
