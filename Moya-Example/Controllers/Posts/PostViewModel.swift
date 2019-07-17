//
//  PostViewModel.swift
//  Moya-Example
//
//  Created by Saleh AlDhobaie on 17/07/2019.
//  Copyright © 2019 Saleh AlDhobaie. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class PostViewModel {
    
    private let postRepo: PostRepoistory!
    init(postRepo: PostRepoistory) {
        self.postRepo = postRepo
    }
    
    let disposableBag = DisposeBag()
    
    private let isLoadingSubject = BehaviorRelay<Bool>(value: false)
    var isLoading : Observable<Bool> {
        return isLoadingSubject.asObservable()
    }
    
    
    private let fetchErrorSubject = BehaviorRelay<Error?>(value: nil)
    var fetchError: Observable<Error?> {
        return fetchErrorSubject.asObservable()
    }
    
    private let postsSubject = BehaviorRelay<[Post]>(value: [])
    var posts: Observable<[Post]> {
        return postsSubject.asObservable()
    }
    
    func numberOfItems() -> Int {
        return postsSubject.value.count
    }
    
    func itemAtRow(row: Int) -> Post? {
        guard row < postsSubject.value.count else { return nil }
        return postsSubject.value[row]
    }
    
    func fetchPosts(request: String){
        self.isLoadingSubject.accept(true)
        postRepo.fetchPost(request: request)
            .subscribe(onNext: { [unowned self] result in
                self.isLoadingSubject.accept(false)
                self.postsSubject.accept(result)
                }, onError: { [unowned self] error in
                    self.isLoadingSubject.accept(false)
                    self.fetchErrorSubject.accept(error)
            }).disposed(by: disposableBag)
    }
    
    
}
