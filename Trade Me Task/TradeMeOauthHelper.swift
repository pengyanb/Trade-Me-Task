//
//  TradeMeOAuthHelper.swift
//  Trade Me Task
//
//  Created by Yanbing Peng on 20/04/16.
//  Copyright © 2016 Yanbing Peng. All rights reserved.
//

import Foundation
import UIKit

class TradeMeOauthHelper: NSObject {
    // MARK: - Public API
    func handleUserAuthentication(consumerKey:String ,consumerSecret:String){
        if let tempTokenDictionary = NSUserDefaults.standardUserDefaults().objectForKey(Constants.NSUSER_DEFAULT_TEMP_TOKEN_KEY) as? [String:String]{
            if let _ = tempTokenDictionary["oauth_verifier"]{
                if let finalTokenDictionary = NSUserDefaults.standardUserDefaults().objectForKey(Constants.NSUSER_DEFAULT_FINAL_TOKEN_KEY) as? [String:String]{
                    if let _ = finalTokenDictionary["oauth_token"], _ = finalTokenDictionary["oauth_token_secret"]{
                        //print("[Final Token]: \(token) [Final TokenSecret]: \(tokenSecret)")
                    }
                    else{
                        acquiringFinalTokenAndSecret(consumerKey, consumerSecret: consumerSecret)
                    }
                }
                else{
                    acquiringFinalTokenAndSecret(consumerKey, consumerSecret: consumerSecret)
                }
            }
            else{
                acquiringTemporaryTokens(consumerKey, consumerSecret: consumerSecret)
            }
        }
        else{
            acquiringTemporaryTokens(consumerKey, consumerSecret: consumerSecret)
        }
    }
    
    func generateAuthorizationHeader(consumerKey:String ,consumerSecret:String)->String?{
        if let finalTokenDictionary = NSUserDefaults.standardUserDefaults().objectForKey(Constants.NSUSER_DEFAULT_FINAL_TOKEN_KEY) as? [String:String]{
            if let token = finalTokenDictionary["oauth_token"], tokenSecret = finalTokenDictionary["oauth_token_secret"]{
                //print("[Final Token]: \(token) [Final TokenSecret]: \(tokenSecret)")
                let authorizationHeader = "OAuth oauth_consumer_key=\(consumerKey), oauth_token=\(token), oauth_version=1.0, oauth_timestamp=\(Int(NSDate().timeIntervalSince1970)), oauth_nonce=\(generateNonce()), oauth_signature_method=PLAINTEXT, oauth_signature=\(consumerSecret)%26\(tokenSecret)"
                
                return authorizationHeader
            }
            else{
                handleUserAuthentication(consumerKey, consumerSecret: consumerSecret)
            }
        }
        else{
            handleUserAuthentication(consumerKey, consumerSecret: consumerSecret)
        }
        
        return nil
    }
    
    // MARK: - Private Functions
    private func acquiringTemporaryTokens(consumerKey:String ,consumerSecret:String){
        let headerAuthorizationContent = "OAuth oauth_callback=\(Constants.TRADEME_OAUTH_CALLBACK_URL), oauth_consumer_key=\(consumerKey), oauth_version=1.0, oauth_timestamp=\(Int(NSDate().timeIntervalSince1970)), oauth_nonce=\(generateNonce()), oauth_signature_method=PLAINTEXT, oauth_signature=\(consumerSecret)%26"
        //print(headerAuthorizationContent)
        if let url = NSURL.init(string: Constants.TRADEME_OAUTH_REQUEST_TOKEN_URL){
            let request = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "POST"
            request.setValue(headerAuthorizationContent, forHTTPHeaderField: "Authorization")
            request.timeoutInterval = Constants.TIMING_SESSION_REQUEST_TIMEOUT
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) in
                guard error == nil && data != nil else{
                    print("[Error]: \(error)\r\n[data]: \(data)\r\n")
                    return
                }
                
                if let responseString = String.init(data: data!, encoding: NSUTF8StringEncoding){
                    //print("[Response]: \(responseString)")
                    let responseComponents = responseString.componentsSeparatedByString("&")
                    var tempOauthToken : String? = nil
                    var tempOauthTokenSecret : String? = nil
                    for component in responseComponents {
                        let keyValuePair = component.componentsSeparatedByString("=")
                        if keyValuePair.count > 1{
                            if keyValuePair[0] == "oauth_token"{
                                print("[oauth_token]: \(keyValuePair[1])")
                                tempOauthToken = keyValuePair[1]
                            }
                            else if keyValuePair[0] == "oauth_token_secret"{
                                print("[oauth_token_secret]: \(keyValuePair[1])")
                                tempOauthTokenSecret = keyValuePair[1]
                            }
                        }
                    }
                    if let tempToken = tempOauthToken, tempSecret = tempOauthTokenSecret{
                        NSUserDefaults.standardUserDefaults().setObject(["oauth_token":tempToken, "oauth_token_secret":tempSecret], forKey: Constants.NSUSER_DEFAULT_TEMP_TOKEN_KEY)
                        NSUserDefaults.standardUserDefaults().synchronize()
                        let urlString = Constants.TRADEME_OAUTH_AUTHORISING_URL + "?oauth_token=\(tempToken)"
                        print(urlString)
                        if let url = NSURL.init(string: urlString){
                            print("[OpenURL]: \(url.absoluteString)")
                            UIApplication.sharedApplication().openURL(url)
                        }
                    }
                }
            })
            task.resume()
        }
    }
    
    private func acquiringFinalTokenAndSecret(consumerKey:String ,consumerSecret:String){
        print("[acquiringFinalTokenAndSecret]")
        if let tempTokenDictionary = NSUserDefaults.standardUserDefaults().objectForKey(Constants.NSUSER_DEFAULT_TEMP_TOKEN_KEY) as? [String:String]{
            if let verifier = tempTokenDictionary["oauth_verifier"], token = tempTokenDictionary["oauth_token"], tokenSecret = tempTokenDictionary["oauth_token_secret"]{
                let headerAuthorizationContent = "OAuth oauth_verifier=\(verifier), oauth_consumer_key=\(consumerKey), oauth_token=\(token), oauth_version=1.0, oauth_timestamp=\(Int(NSDate().timeIntervalSince1970)), oauth_nonce=\(generateNonce()), oauth_signature_method=PLAINTEXT, oauth_signature=\(consumerSecret)%26\(tokenSecret)"
                print(headerAuthorizationContent)
                if let url = NSURL.init(string: Constants.TRADEME_OAUTH_ACCESS_TOKEN_URL){
                    let request = NSMutableURLRequest(URL: url)
                    request.HTTPMethod = "POST"
                    request.setValue(headerAuthorizationContent, forHTTPHeaderField: "Authorization")
                    request.timeoutInterval = Constants.TIMING_SESSION_REQUEST_TIMEOUT
                    let task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) in
                        guard error == nil && data != nil else{
                            print("[Error]: \(error)\r\n[data]: \(data)\r\n")
                            return
                        }
                        
                        if let responseString = String.init(data: data!, encoding: NSUTF8StringEncoding){
                            print("[Response]: \(responseString)")
                            let responseComponents = responseString.componentsSeparatedByString("&")
                            var finalOauthToken : String? = nil
                            var finalOauthTokenSecret : String? = nil
                            for component in responseComponents {
                                let keyValuePair = component.componentsSeparatedByString("=")
                                if keyValuePair.count > 1{
                                    if keyValuePair[0] == "oauth_token"{
                                        print("[oauth_token]: \(keyValuePair[1])")
                                        finalOauthToken = keyValuePair[1]
                                    }
                                    else if keyValuePair[0] == "oauth_token_secret"{
                                        print("[oauth_token_secret]: \(keyValuePair[1])")
                                        finalOauthTokenSecret = keyValuePair[1]
                                    }
                                }
                            }
                            if let token = finalOauthToken, tokenSecret = finalOauthTokenSecret{
                                NSUserDefaults.standardUserDefaults().setObject(["oauth_token":token, "oauth_token_secret":tokenSecret], forKey: Constants.NSUSER_DEFAULT_FINAL_TOKEN_KEY)
                                NSUserDefaults.standardUserDefaults().synchronize()
                            }
                        }
                    })
                    task.resume()
                }
            }
        }
        
    }
    
    private func generateNonce()->String{
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let nonce : NSMutableString = NSMutableString(capacity: 6)
        for _ in 0 ..< 6{
            nonce.appendFormat("%C", letters.characterAtIndex(Int(arc4random_uniform(UInt32(letters.length)) ) ))
        }
        return nonce as String
        /*
        var nonceUInt8Array = [UInt8]()
        for _ in 0 ..< 8 {
            nonceUInt8Array.append(UInt8.init(arc4random_uniform(UInt32.init(256))))
        }
        let nonceRawData = NSData.init(bytes: nonceUInt8Array, length: nonceUInt8Array.count)
        let nonceBase64String = nonceRawData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
        print("[nonce]: \(nonceBase64String)")
        return nonceBase64String*/
    }
    
}