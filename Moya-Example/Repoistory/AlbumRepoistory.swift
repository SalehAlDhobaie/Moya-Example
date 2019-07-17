//
//  AlbumRepoistory.swift
//  Moya-Example
//
//  Created by Saleh AlDhobaie on 15/07/2019.
//  Copyright © 2019 Saleh AlDhobaie. All rights reserved.
//

import Foundation
import Moya
import RxSwift


protocol AlbumRepoistory {
    func fetchAlbum(request: String) -> Observable<[Album]>
}


struct AlbumRepoistoryImp : AlbumRepoistory, NetworkRepositoryProvider {
    let credentialStore = CredentialStore.shared
    func fetchAlbum(request: String) -> Observable<[Album]> {
        return provider.rx.request(MultiTarget(AlbumTarget.albums))
            .filterSuccessfulStatusCodes()
            .filterCodesExceptAuthError()
            .retryWithAuthIfNeeded(credentialStore: credentialStore, provider: provider).map { response -> [Album] in
                do {
                    let result = try response.filterSuccessfulStatusCodes()
                    let decoder = JSONDecoder()
                    return try decoder.decode( [Album].self, from: result.data)
                }catch (let error) {
                    //throw AppError.handleError(error: error)
                    throw error
                }
            }.asObservable()
    }
}
