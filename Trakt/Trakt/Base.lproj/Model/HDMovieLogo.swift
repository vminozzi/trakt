//
//  File.swift
//  Trakt
//
//  Created by Vinicius Minozzi on 08/08/17.
//  Copyright © 2017 vm. All rights reserved.
//

import Foundation
import ObjectMapper

struct HDMovieLogo: Mappable {
    
    var id = ""
    var url = ""
    var lang = ""
    var likes = ""
    
    init() {
        
    }
    
    init?(map: Map) {
        mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        url <- map["url"]
        lang <- map["lang"]
        likes <- map["likes"]
    }
}
