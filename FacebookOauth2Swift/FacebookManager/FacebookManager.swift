//
//  FacebookManager.swift
//  FacebookOauth2Swift
//
//  Created by Rohan Sonawane on 04/12/16.
//  Copyright © 2016 Rohan Sonawane. All rights reserved.
//

import UIKit
import OAuthSwift

/**
 Facebook Manager Constants.
 
 - consumerKey: Facebook application ID.
 - consumerSecret: Facebook application secret.
 - authorizeUrl: Authentication URL.
 - accessTokenUrl: Access Token URL.
 - responseType: Type of response expected.
 
 - callbackURL: Use same URL as redirect URI on facebook.
 - scopePublicProfile: User permission to access public profile.
 - scopeUserPhotos: User permission to access photos.
 - state: Query string.
 
 - facebookPhotosURL: URL to get facebook photos.
 - pageLimit: Pagination limit.
 - pageOffset: Pagination offset.
 */
struct FacebookManagerConstants {
    static let consumerKey = "203995400058678"
    static let consumerSecret = "e7d2a81537e097023fc84ea9e94d74b5"
    static let authorizeUrl = "https://www.facebook.com/dialog/oauth"
    static let accessTokenUrl = "https://graph.facebook.com/oauth/access_token"
    static let responseType = "code"
    
    static let callbackURL = "https://oauthswift.herokuapp.com/callback/facebook"
    static let scopePublicProfile = "public_profile"
    static let scopeUserPhotos = "user_photos"
    static let state = "fb"
    
    static let facebookPhotosURL = "https://graph.facebook.com/me/photos/uploaded?fields=images"
    static let pageLimit = "10000"
    static let pageOffset = "0"
}

open class FacebookManager: NSObject {

    /**
     Facebook authentication and get user photos
     
     @param viewController A viewcontroller who's calling this function. Used for SafariURLHandler.
     
     @param completionWithPhotos Gets photos array and error
     
     @return None.
     */
    func loginWithFacebookAndGetPhotos(viewController:Any, completionWithPhotos: @escaping (_ photosArray: Array<Any>?, _ error:NSError?) -> Void) {
        let oauthswift = OAuth2Swift(
            consumerKey: FacebookManagerConstants.consumerKey,
            consumerSecret: FacebookManagerConstants.consumerSecret,
            authorizeUrl: FacebookManagerConstants.authorizeUrl,
            accessTokenUrl: FacebookManagerConstants.accessTokenUrl,
            responseType: FacebookManagerConstants.responseType
        )
        
        oauthswift.authorizeURLHandler = SafariURLHandler(viewController: viewController as! UIViewController, oauthSwift: oauthswift)
        let _ = oauthswift.authorize(
            withCallbackURL: URL(string: FacebookManagerConstants.callbackURL)!, scope: "\(FacebookManagerConstants.scopePublicProfile), \(FacebookManagerConstants.scopeUserPhotos)", state: FacebookManagerConstants.state,
            success: { credential, response, parameters in
                
                self.getFacebookPhotos(oauthswift, completionWithPhotos: {photosArray, error in
                    completionWithPhotos(photosArray, NSError(domain: "", code: 222, userInfo: nil))
                })
                
        }, failure: { error in
            completionWithPhotos(nil, NSError(domain: error.localizedDescription, code: 111, userInfo: nil))
        }
        )
    }
    
    // MARK: ---------- Private Functions ----------
    
    /**
     Get facebook photos
     
     @param oauthswift OAuth2Swift object to make a valid request to facebook using an access token
     
     @param completionWithPhotos Gets photos array and error
     
     @return None.
     */
    private func getFacebookPhotos(_ oauthswift: OAuth2Swift, completionWithPhotos: @escaping (_ photosArray: Array<Any>?, _ error:NSError?) -> Void) {
        let parameters :Dictionary = ["limit":FacebookManagerConstants.pageLimit, "offset":FacebookManagerConstants.pageOffset]
        let _ = oauthswift.client.get(FacebookManagerConstants.facebookPhotosURL, parameters: parameters, headers: nil, success: { response in
            let responseData = response.data
            
            //parse facebook response
            let parsingManager = ParsingManager()
            parsingManager.parseFacebookPhotos(responseData: responseData, completionWithPhotos: {photosArray, error in
                completionWithPhotos(photosArray!, NSError(domain: "", code: 222, userInfo: nil))
            })
        }, failure: { error in
            completionWithPhotos(nil, NSError(domain: error.localizedDescription, code: 111, userInfo: nil))
        })
    }
}
