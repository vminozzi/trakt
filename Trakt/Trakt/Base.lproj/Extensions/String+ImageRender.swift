//
//  String+ImageRender.swift
//  Trakt
//
//  Created by Vinicius on 08/08/17.
//  Copyright © 2017 vm. All rights reserved.
//

import Foundation

extension String {
    func addIamgePath() -> String {
        return "https://image.tmdb.org/t/p/w500" + self
    }
}
