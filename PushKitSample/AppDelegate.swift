//
//  AppDelegate.swift
//  PushKitSample
//
//  Copyright © 2016年 imamurh. All rights reserved.
//

import UIKit
import PushKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, PKPushRegistryDelegate {

    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        let state: String
        switch application.applicationState {
        case .Active:
            state = "Active"
        case .Inactive:
            state = "Inactive"
        case .Background:
            state = "Background"
        }
        NSLog("didFinishLaunchingWithOptions: \(state)")
        
        let voipRegistry: PKPushRegistry = PKPushRegistry(queue: dispatch_get_main_queue())
        voipRegistry.delegate = self
        voipRegistry.desiredPushTypes = [PKPushTypeVoIP]

        let types: UIUserNotificationType = [.Badge, .Sound, .Alert]
        let notificationSettings = UIUserNotificationSettings(forTypes:types, categories:nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
    }

    func applicationDidEnterBackground(application: UIApplication) {
    }

    func applicationWillEnterForeground(application: UIApplication) {
    }

    func applicationDidBecomeActive(application: UIApplication) {
    }

    func applicationWillTerminate(application: UIApplication) {
    }
    
    // MARK:- PKPushRegistryDelegate
    
    func pushRegistry(registry: PKPushRegistry!, didUpdatePushCredentials credentials: PKPushCredentials!, forType type: String!) {
        NSLog("didUpdatePushCredentials: \(credentials.token)")
    }
    
    func pushRegistry(registry: PKPushRegistry!, didReceiveIncomingPushWithPayload payload: PKPushPayload!, forType type: String!) {
        NSLog("didReceiveIncomingPushWithPayload: \(payload.dictionaryPayload)")
        
        if UIApplication.sharedApplication().applicationState == .Background {
            let notification: UILocalNotification = UILocalNotification()
            notification.fireDate = NSDate()
            notification.timeZone = NSTimeZone.defaultTimeZone()
            if let message = payload.dictionaryPayload["message"] as? String {
                notification.alertBody = message
            }
            notification.soundName = UILocalNotificationDefaultSoundName
            UIApplication.sharedApplication().scheduleLocalNotification(notification);
        }
    }

    func pushRegistry(registry: PKPushRegistry!, didInvalidatePushTokenForType type: String!) {
        NSLog("didInvalidatePushTokenForType")
    }
    
}

