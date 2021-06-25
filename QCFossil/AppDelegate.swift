//
//  AppDelegate.swift
//  QCFossil
//
//  Created by Yin Huang on 14/12/15.
//  Copyright © 2015 kira. All rights reserved.
//

import UIKit

@objc open class MyClass: NSObject {
    open static let myConst = "aConst"
}

private let sharedLocalizeInstance = MylocalizedString()

@objc class MylocalizedString: NSObject  {
    @objc var language = "en"
    @objc var bundle = Bundle(path: Bundle.main.path(forResource: "en", ofType: "lproj")!)
    
    @objc func setMyLanguage(_ lang:String="en") {
        language = lang
        bundle = Bundle(path: Bundle.main.path(forResource: lang, ofType: "lproj")!)
    }
    
    @objc func getLanguage() ->String {
        return language
    }
    
    @objc func getLocalizedString(_ key:String)->String {
        return (bundle?.localizedString(forKey: key, value: nil, table: nil))!
    }
    
    @objc class var sharedLocalizeManager : MylocalizedString {
        return sharedLocalizeInstance
    }
    
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var backgroundSessionCompletionHandler: (()->Void)?
    
    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
        /*
         Store the completion handler. The completion handler is invoked by the view controller's checkForAllDownloadsHavingCompleted method (if all the download tasks have been completed).
         */
        self.backgroundSessionCompletionHandler = completionHandler
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            _VERSION = version
            let defaults = UserDefaults.standard
            
            let versionCode = defaults.string(forKey: "version_preference")
            
            if version != versionCode {
                defaults.set(_VERSION, forKey: "version_preference")
                
                //Do any update here...
                _NEEDDATAUPDATE = true
            }
        }
        
        if(UIApplication.instancesRespond(to: #selector(UIApplication.registerUserNotificationSettings(_:)))) {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [UIUserNotificationType.alert, UIUserNotificationType.badge], categories: nil))
        }
        
        UIApplication.shared.isIdleTimerDisabled = true
        
        return true
    }

    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        NotificationCenter.default.post(name: Notification.Name(rawValue: "triggerBackgroundRun"), object: nil,userInfo: nil)
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        application.applicationIconBadgeNumber = 0
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        NotificationCenter.default.post(name: Notification.Name(rawValue: "runTasksDidBecomeActive"), object: nil,userInfo: nil)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

