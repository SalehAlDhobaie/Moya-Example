//
//  PostRepoistory.swift
//  Moya-Example
//
//  Created by Saleh AlDhobaie on 15/07/2019.
//  Copyright © 2019 Saleh AlDhobaie. All rights reserved.
//

import Foundation
import RxSwift
import Moya

protocol PostRepoistory {
    func fetchPost(request: String) -> Observable<[Post]>
}




struct PostRepoistoryImp : PostRepoistory, NetworkRepositoryProvider {
    
    let credentialStore = CredentialStore.shared
    func fetchPost(request: String) -> Observable<[Post]> {
        return provider.rx.request(MultiTarget(PostTarget.posts))
            .filterSuccessfulStatusCodes()
            .filterCodesExceptAuthError()
            .retryWithAuthIfNeeded(credentialStore: credentialStore, provider: provider).map { response -> [Post] in
                do {
                    let result = try response.filterSuccessfulStatusCodes()
                    let decoder = JSONDecoder()
                    return try decoder.decode( [Post].self, from: result.data)
                }catch (let error) {
                    //throw AppError.handleError(error: error)
                    throw error
                }
            }.asObservable()
    }
}
