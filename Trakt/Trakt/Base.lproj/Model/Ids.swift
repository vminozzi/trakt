//
//  Ids.swift
//  Trakt
//
//  Created by Vinicius on 07/08/17.
//  Copyright © 2017 vm. All rights reserved.
//

import Foundation
import ObjectMapper

struct Ids: Mappable {

    var trakt = 0
    var slug = ""
    var imdb = ""
    var tmdb = 0
        
    init?(map: Map) {
        mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        trakt <- map["trakt"]
        slug <- map["slug"]
        imdb <- map["imdb"]
        tmdb <- map["tmdb"]
    }
}
