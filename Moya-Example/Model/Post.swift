//
//  Post.swift
//  Moya-Example
//
//  Created by Saleh AlDhobaie on 3/12/17.
//  Copyright © 2017 Saleh AlDhobaie. All rights reserved.
//

import Foundation

public struct Post {
    
    var userId : Int?
    var id: Int?
    var title : String?
    var body : String?
    
}

extension Post {
    public static func modelObject(item: Dictionary<String, Any>) -> Post? {
        var post = Post()
        guard let userId = item["userId"] as? Int, let id = item["id"] as? Int else {
            return nil
        }
        post.userId = userId
        post.id = id
        
        if let title = item["title"] as? String {
            post.title = title
        }
        if let body = item["body"] as? String {
            post.body = body
        }
        return post
    }
    
    public static func modelObjects(objects: [[String: Any]]) -> [Post?] {
        
        return objects.map({item in
            return Post.modelObject(item: item)
        })
    }
}
