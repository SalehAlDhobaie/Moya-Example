//
//  Post.swift
//  Moya-Example
//
//  Created by Saleh AlDhobaie on 3/12/17.
//  Copyright © 2017 Saleh AlDhobaie. All rights reserved.
//

import Foundation

struct Post : Decodable {
    var userId : Int
    var id: Int?
    var title : String?
    var body : String?
    
}

