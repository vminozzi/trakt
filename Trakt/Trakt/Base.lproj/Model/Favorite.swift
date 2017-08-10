//
//  Favorite.swift
//  Trakt
//
//  Created by Vinicius on 09/08/17.
//  Copyright © 2017 vm. All rights reserved.
//

import Foundation
import RealmSwift

class Favorite: Object {

    dynamic var traktId = 0
    dynamic var title = ""
    dynamic var year = 0
    dynamic var imageURL = ""
}
