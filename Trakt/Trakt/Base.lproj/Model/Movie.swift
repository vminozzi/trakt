//
//  Movie.swift
//  Trakt
//
//  Created by Vinicius on 07/08/17.
//  Copyright © 2017 vm. All rights reserved.
//

import Foundation
import ObjectMapper

struct Movie: Mappable {

    var title = ""
    var year = 0
    var ids: Ids?
    var released = ""
    var runtime = 0
    var tagline = ""
    var overview = ""
    var rating = 0.0
    var genres = [""]
    
    init() {
        
    }
    
    init?(searchMap: Map) {
        title <- searchMap["movie.title"]
        year <- searchMap["movie.year"]
        ids <- searchMap["movie.ids"]
    }
    
    init?(map: Map) {
        mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        title <- map["title"]
        year <- map["year"]
        ids <- map["ids"]
        released <- map["released"]
        runtime <- map["runtime"]
        tagline <- map["tagline"]
        overview <- map["overview"]
        rating <- map["rating"]
        genres <- map["genres"]
    }
}
