//
//  AppNetwork.swift
//  Moya-Example
//
//  Created by Saleh AlDhobaie on 3/12/17.
//  Copyright © 2017 Saleh AlDhobaie. All rights reserved.
//

import Foundation
import Moya
import RxSwift


protocol AppNetworkProvider: class {
    var rx: Reactive<MoyaProvider<MultiTarget>> { get }
}

// MARK: - DefaultAppNetworkProvider

class DefaultAppNetworkProvider {
    
    var rx: Reactive<MoyaProvider<MultiTarget>> {
        return moyaProvider.rx
    }
    
    fileprivate var moyaProvider: MoyaProvider<MultiTarget>!
    
    init() {
        let plugins = [NetworkLoggerPlugin(verbose: true, responseDataFormatter: JSONResponseDataFormatter)]
        moyaProvider = MoyaProvider<MultiTarget>(endpointClosure: endpointClosure,
                                                 requestClosure: requestClosure,
                                                 stubClosure: stubClosure,
                                                 plugins: plugins)
    }
}

// MARK: AppNetworkProvider Methods

extension DefaultAppNetworkProvider: AppNetworkProvider { }

private extension DefaultAppNetworkProvider {
    
    private func endpointClosure(target: MultiTarget) -> Endpoint {
        let defaultEndpoint = MoyaProvider.defaultEndpointMapping(for: target)
        
        /// X-ACCESS-TOKEN
        switch target.target {
        // case is VimeoTarget:
            //return defaultEndpoint
        default:
            break
        }
        
        // read token from keychaine .. etc
        
        // let cred = CredentialStore.shared
        /*if let oAuth = cred.authToken(), let idToken = oAuth.idToken {
            let endpoint = defaultEndpoint.adding(newHTTPHeaderFields: [ "Authorization": "\(idToken)" ])
            if let accessToken = defaultEndpoint.httpHeaderFields?["x-access-token"] {
                return endpoint.adding(newHTTPHeaderFields: [
                    "x-access-token": "\(accessToken)",
                    ])
            }
            return endpoint
        } else {
            return defaultEndpoint
        }*/
        return defaultEndpoint
        
    }
    
    private func JSONResponseDataFormatter(_ data: Data) -> Data {
        do {
            let dataAsJSON = try JSONSerialization.jsonObject(with: data)
            let prettyData =  try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
            return prettyData
        } catch {
            return data // fallback to original data if it can't be serialized.
        }
    }
    
    func requestClosure(endpoint: Endpoint, done: @escaping MoyaProvider<MultiTarget>.RequestResultClosure) {
        do {
            var request = try endpoint.urlRequest()
            // Modify the request however you like.
            request.httpShouldHandleCookies = false
            done(.success(request))
        } catch {
            done(.failure(MoyaError.underlying(error, nil)))
        }
    }
    
    func stubClosure(target: TargetType) -> Moya.StubBehavior {
        guard let multiTarget = target as? MultiTarget else {
            return .never
        }
        // return .immediate
        return .never
    }
    
    
}
