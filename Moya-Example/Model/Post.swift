//
//  Post.swift
//  Moya-Example
//
//  Created by Saleh AlDhobaie on 3/12/17.
//  Copyright © 2017 Saleh AlDhobaie. All rights reserved.
//

import Foundation
import Mapper
// Conform to the Mappable protocol

public struct Post: Mappable {
    
    let userId : Int
    let id: Int
    let title : String
    let body : String
    
    public init(map: Mapper) throws {
        try userId               = map.from("userId")
        try id                   = map.from("id")
        try title                = map.from("title")
        try body                 = map.from("body")
    }
    
    
}
