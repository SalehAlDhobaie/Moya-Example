//
//  CommentRepoistory.swift
//  Moya-Example
//
//  Created by Saleh AlDhobaie on 15/07/2019.
//  Copyright © 2019 Saleh AlDhobaie. All rights reserved.
//

import Foundation
import RxSwift
import Moya


protocol CommentRepoistory {
    func fetchComments(request: String) -> Observable<[Comment]>
}


struct CommentRepoistoryImp : CommentRepoistory, NetworkRepositoryProvider {
    
    let credentialStore = CredentialStore.shared
    func fetchComments(request: String) -> Observable<[Comment]> {
        return provider.rx.request(MultiTarget(CommentTarget.comment))
            .filterSuccessfulStatusCodes()
            .filterCodesExceptAuthError()
            .retryWithAuthIfNeeded(credentialStore: credentialStore, provider: provider).map { response -> [Comment] in
                do {
                    let result = try response.filterSuccessfulStatusCodes()
                    let decoder = JSONDecoder()
                    return try decoder.decode( [Comment].self, from: result.data)
                }catch (let error) {
                    //throw AppError.handleError(error: error)
                    throw error
                }
            }.asObservable()
    }
}
