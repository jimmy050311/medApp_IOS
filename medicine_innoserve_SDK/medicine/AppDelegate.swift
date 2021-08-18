//
//  AppDelegate.swift
//  medicine
//
//  Created by amkdajmal on 2019/5/6.
//  Copyright © 2019年 amkdajmal. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate{

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: { granted, error in
            if granted {
                print("使用者同意了，願意收到通知")
            }
            else {
                print("使用者不同意，不願意收到通知")
            }
            
        })
        
        UNUserNotificationCenter.current().delegate = self
        
//        let likeAction = UNNotificationAction(identifier: "like", title: "我吃了", options: [.foreground])
//        let dislikeAction = UNNotificationAction(identifier: "dislike", title: "我不想吃", options: [])
//        let category = UNNotificationCategory(identifier: "luckyMessage", actions: [likeAction, dislikeAction], intentIdentifiers: [], options: [])
//        UNUserNotificationCenter.current().setNotificationCategories([category])

        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
//    func chilkatCode() {
//        let json = CkoJsonObject()!
//        
//        var success: Bool
//        
//        // The only reason for failure in the following lines of code would be an out-of-memory condition,
//        // which isn't going to happen...
//        
//        //  An index value of -1 is used to append at the end.
//        success = json.addString(at: -1, name: "Title", value: "Pan's Labyrinth")
//        if (success) {
//            success = json.addString(at: -1, name: "Director", value: "Guillermo del Toro")
//        }
//        if (success) {
//            success = json.addString(at: -1, name: "Original_Title", value: "El laberinto del fauno")
//        }
//        if (success) {
//            success = json.addInt(at: -1, name: "Year_Released", value: 2006)
//        }
//        
//        json.emitCompact = false
//        //print("\(json.emit()!)")
//        
//    }
//
//    func applicationDidFinishLaunching(_ aNotification: Notification) {
//        // Insert code here to initialize your application
//        // test creating and using a Chilkat object.
//        chilkatCode();
//        
//    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        /*let storyboard = UIStoryboard(name: "Main", bundle: nil)
        completionHandler([.badge, .sound, .alert])
        if  let conversationVC = storyboard.instantiateViewController(withIdentifier: "ConversationViewController") as? ConversationViewController {
            
            // set the view controller as root
            self.window?.rootViewController = conversationVC
        }*/
        //self.window?.rootViewController = conversationVC
        completionHandler([.badge, .sound, .alert])
        
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler:  @escaping () -> Void) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //completionHandler([.badge, .sound, .alert]
        let content = response.notification.request.content
        if content.title == "睡前吃藥通知"{
            if  let conversationVC1 = storyboard.instantiateViewController(withIdentifier: "BeforeBedViewController") as? BeforeBedViewController {
                // set the view controller as root
                self.window?.rootViewController = conversationVC1
            }
        }else if content.title == "早餐前吃藥通知"{
            if  let conversationVC2 = storyboard.instantiateViewController(withIdentifier: "BeforeBreakfastViewController") as? BeforeBreakfastViewController {
                // set the view controller as root
                self.window?.rootViewController = conversationVC2
            }
        }else if content.title == "午餐前吃藥通知"{
            if  let conversationVC3 = storyboard.instantiateViewController(withIdentifier: "BeforeLunchViewController") as? BeforeLunchViewController {
                // set the view controller as root
                self.window?.rootViewController = conversationVC3
            }
        }else if content.title == "晚餐前吃藥通知"{
            if  let conversationVC4 = storyboard.instantiateViewController(withIdentifier: "BeforeDinnerViewController") as? BeforeDinnerViewController {
                // set the view controller as root
                self.window?.rootViewController = conversationVC4
            }
        }else if content.title == "早餐後吃藥通知"{
            if  let conversationVC5 = storyboard.instantiateViewController(withIdentifier: "AfterBreakfastViewController") as? AfterBreakfastViewController {
                // set the view controller as root
                self.window?.rootViewController = conversationVC5
            }
        }else if content.title == "午餐後吃藥通知"{
            if  let conversationVC6 = storyboard.instantiateViewController(withIdentifier: "AfterLunchViewController") as? AfterLunchViewController {
                // set the view controller as root
                self.window?.rootViewController = conversationVC6
            }
        }else if content.title == "晚餐後吃藥通知"{
            if  let conversationVC7 = storyboard.instantiateViewController(withIdentifier: "AfterDinnerViewController") as? AfterDinnerViewController {
                // set the view controller as root
                self.window?.rootViewController = conversationVC7
            }
        }
        
        
//        if  let conversationVC = storyboard.instantiateViewController(withIdentifier: "BeforeBedViewController") as? BeforeBedViewController {
//            // set the view controller as root
//            self.window?.rootViewController = conversationVC
//        }

        print("title \(content.title)")
        print("userInfo \(content.body)")
        print("actionIdentifier \(response.actionIdentifier)")

        completionHandler()
    }
    
    
}
