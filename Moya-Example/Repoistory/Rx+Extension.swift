//
//  Rx+Extension.swift
//  Moya-Example
//
//  Created by Saleh AlDhobaie on 15/07/2019.
//  Copyright © 2019 Saleh AlDhobaie. All rights reserved.
//

import Foundation
import RxSwift
import Moya

/// Contains the tokens for an active sign in session.
struct Tokens {
    /// The ID token.
    let idToken: String?
    /// The access token.
    let accessToken: String?
    /// The refresh token.
    let refreshToken: String?
    /// Expiration date if available.
    let expiration: Date?
    
    init(idToken: String?, accessToken: String?, refreshToken: String?, expiration: Date?) {
        self.idToken = idToken
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.expiration = expiration
    }
}

enum CredentialStoreError : Error {
    case notLoggedIn
}

class CredentialStore {
    
    private static let SERVICE_NAME  = Bundle.main.bundleIdentifier! + ".AuthClient"
    //private let keychainWrapper: KeychainWrapper = KeychainWrapper.standard
    private let keychainWrapper: UserDefaults = UserDefaults.standard
    
    static let shared = CredentialStore()
    private init() {
        
    }
    
    func clearSavedCredentials() {
        /*
         Since the Documentation mentiond the .signOut() is signed out from current device and you need to clear tokens from localdevice I have to call three functions .clearCredentials(), and .clearKeychain().
         */
        setAuthToken(oauth: nil)
    }
    
    private func resetToken() {
        // referechToken
    }
    
    func authToken() -> String? {
        resetToken()
        guard let oauth = keychainWrapper.object(forKey: CredentialStore.SERVICE_NAME) as? String else {
            return nil
        }
        return "oauth_token"
    }
    
    func setAuthToken(oauth: String?) {
        guard let oauthValue = oauth else {
            keychainWrapper.removeObject(forKey: CredentialStore.SERVICE_NAME)
            return
        }
        keychainWrapper.set(oauthValue, forKey: CredentialStore.SERVICE_NAME)
    }
    
}




extension PrimitiveSequence where TraitType == SingleTrait, ElementType == Response {
    
    func retryWithAuthIfNeeded(credentialStore: CredentialStore, provider: AppNetworkProvider) -> Single<ElementType> {
        
        return retryWhen {  e in
            return Observable.zip(e, Observable.range(start: 1, count: 3), resultSelector: { $1 })
            /*.flatMap { i -> PrimitiveSequence<SingleTrait, Tokens> in
             return AWSMobileClient.sharedInstance().rx
             .refreshToken()
             /***
             Adding 5 seconds more for request timeout just to avoid delay
             of switching between threads (not sure).
             */
             .timeout(RxTimeInterval(65.0), scheduler: MainScheduler.instance)
             .asSingle()
             .catchError { error in
             /*
             Note: Clear Tokens in case AWS SDK can't refresh token or Observable didn't emit any value success or error.
             */
             credentialStore.clearSavedCredentials()
             /*
             Note: Redirect User or context in both cases in above and ask User to Login again.
             */
             UIApplication.appDelegate.showAuthenticationScreen()
             
             throw AppError.handleError(error: AppError.unAuthrized)
             }.flatMap { (token: Tokens) in
             credentialStore.setAuthToken(oauth: token.toOAuthAccess())
             return Single.just(token)
             }*/
        }
    }
}





extension PrimitiveSequence where TraitType == SingleTrait, ElementType == Response {
    
    func filterCodesExceptAuthError() -> Single<ElementType> {
        return flatMap { response -> Single<ElementType> in
            return Single.just(try response.filterCodesExceptAuthError())
        }
    }
}

extension Response {
    
    func filterCodesExceptAuthError() throws -> Response {
        guard statusCode != 401 else {
            throw MoyaError.statusCode(self)
        }
        return self
    }
}




