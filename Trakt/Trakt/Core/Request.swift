//
//  Request.swift
//  Trakt
//
//  Created by Vinicius on 06/08/17.
//  Copyright © 2017 vm. All rights reserved.
//

import UIKit
import Alamofire

typealias JSONDictionary = [String: AnyObject]

class Request {
    
    let serverAPI = "https://api.trakt.tv/movies/popular"
    
    let headers: HTTPHeaders = [
        "Content-Type": "application/json",
        "trakt-api-version": "2",
        "trakt-api-key": "5afd26eef7ad7f8112f54ea2a1dd300e247c546fc5000e17b371910b7f19fc10"
    ]
    
    func requestAPI(completion: @escaping ((_ result: [Movie]?) -> ())) {
        Alamofire.request(serverAPI, headers: headers).responseJSON { response in
            if let _ = response.result.error {
                completion(nil)
                return
            }
            
            if let json = response.result.value as? [JSONDictionary] {
                var movies = [Movie]()
                json.forEach { movies.append(Movie(JSON: $0) ?? Movie())  }
                completion(movies)
            }
            
            completion(nil)
        }
    }
}
