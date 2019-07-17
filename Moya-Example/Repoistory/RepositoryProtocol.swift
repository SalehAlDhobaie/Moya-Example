//
//  RepositoryProtocol.swift
//  Moya-Example
//
//  Created by Saleh AlDhobaie on 15/07/2019.
//  Copyright © 2019 Saleh AlDhobaie. All rights reserved.
//

import Foundation

protocol RepositoryProvider {
    associatedtype T
    var provider: T {get}
}

protocol NetworkRepositoryProvider : RepositoryProvider where T == AppNetworkProvider  {
    
}

extension NetworkRepositoryProvider {
    var provider: AppNetworkProvider {
        return DefaultAppNetworkProvider()
    }
}

