//
//  AppDelegate.swift
//  Trade Me Task
//
//  Created by Yanbing Peng on 18/04/16.
//  Copyright © 2016 Yanbing Peng. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        print("[Application handleOpenUrl]: \(url.absoluteString)")
        let urlString = url.absoluteString
        let urlComponents = urlString.componentsSeparatedByString("?")
        if urlComponents.count > 1{
            let urlOfInterest = urlComponents[1]
            let urlOfInterestComponents = urlOfInterest.componentsSeparatedByString("&")
            var oauthToken : String? = nil
            var oauthVerifier : String? = nil
            for component in urlOfInterestComponents{
                let keyValuePair = component.componentsSeparatedByString("=")
                if keyValuePair.count > 1{
                    if keyValuePair[0] == "oauth_token"{
                        print("[oauth_token]: \(keyValuePair[1])")
                        oauthToken = keyValuePair[1]
                    }
                    else if keyValuePair[0] == "oauth_verifier"{
                        print("[oauth_verifier]: \(keyValuePair[1])")
                        oauthVerifier = keyValuePair[1]
                    }
                }
            }
            
            if let token = oauthToken, verifier = oauthVerifier{
                if var tempTokenDictionary = NSUserDefaults.standardUserDefaults().objectForKey(Constants.NSUSER_DEFAULT_TEMP_TOKEN_KEY) as? [String:String]{
                    if tempTokenDictionary["oauth_token"] == token{
                        tempTokenDictionary["oauth_verifier"] = verifier
                        NSUserDefaults.standardUserDefaults().setObject(tempTokenDictionary, forKey: Constants.NSUSER_DEFAULT_TEMP_TOKEN_KEY)
                        NSUserDefaults.standardUserDefaults().synchronize()
                    }
                }
            }
        }
        return true
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

