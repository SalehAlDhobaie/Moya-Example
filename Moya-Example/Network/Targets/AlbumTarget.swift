//
//  AlbumTarget.swift
//  Moya-Example
//
//  Created by Saleh AlDhobaie on 15/07/2019.
//  Copyright © 2019 Saleh AlDhobaie. All rights reserved.
//

import Foundation
import Moya


enum AlbumTarget {
    // GET /albums
    case albums
}

extension AlbumTarget: TargetType {
    
    var headers: [String : String]? {
        return nil
    }
    
    // Base Url will be used to hit the api
    var baseURL: URL {
        return URL(string: "https://jsonplaceholder.typicode.com")!
    }
    
    // dermine resource path for each end point in 'AppNetwork' enum with Base Url
    var path: String {
        switch self {
        case .albums:
            return "/comments"
        }
        
    }
    
    // detrmine HTTP method "GET, POST, PUT .. etc"
    var method: Moya.Method {
        switch self {
        case .albums:
            return .get
        }
    }
    
    
    // sending parameters with endpoint in the url e.g /posts/1 or in body "depend on the service"
    var parameters: [String: Any]? {
        switch self {
        case .albums:
            return nil
        }
    }
    
    // specify encodeing for each endpoint or service "JSONEncoding, URLEncoding.. etc"
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .albums:
            return JSONEncoding.default
        }
    }
    
    // specify the type for each task "request, upload, .. etc"
    var task: Task {
        switch self {
        case .albums:
            return .requestPlain
        }
    }
    
    var sampleData: Data {
        // mock here
        return Data()
    }
    
    
    
}
