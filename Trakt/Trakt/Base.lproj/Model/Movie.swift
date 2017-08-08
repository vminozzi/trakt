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
    var logo: HDMovieLogo?
    
    init() {
        
    }
    
    init?(map: Map) {
        mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        title <- map["title"]
        year <- map["year"]
        ids <- map["ids"]
    }
}
