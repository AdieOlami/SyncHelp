//
//  AppDelegate.swift
//  Sync-Schedule
//
//  Created by Olar's Mac on 8/25/18.
//  Copyright © 2018 trybetech LTD. All rights reserved.
//

import UIKit
import RealmSwift
import UserNotifications
import SyncKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let defaults = UserDefaults.standard
    let center = UNUserNotificationCenter.current()
    
    
    lazy var realmConfiguration: Realm.Configuration = {
        var configuration = Realm.Configuration()
        configuration.schemaVersion = 1
        configuration.migrationBlock = { migration, oldSchemaVersion in
            
            if (oldSchemaVersion < 1) {
            }
        }
        
        configuration.objectTypes = [CategoryModel.self, TodoListModel.self]
        return configuration
    }()
    
    var realm: Realm!
    lazy var synchronizer: QSCloudKitSynchronizer! = QSCloudKitSynchronizer.cloudKitPrivateSynchronizer(containerName: "your-container-name",
                                                                                                        configuration: self.realmConfiguration)
    lazy var sharedSynchronizer: QSCloudKitSynchronizer! = QSCloudKitSynchronizer.cloudKitSharedSynchronizer(containerName: "your-container-name", configuration: self.realmConfiguration)
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch. *131*105#
        
        print(".count Delegae \(defaults.integer(forKey: Constants.NOTIFICATION_COUNT))")
        let navigation = UINavigationBar.appearance()
        let attributes = [NSAttributedStringKey.font: UIFont(name: Theme.current.mainFontName, size: 17)!]
        UINavigationBar.appearance().titleTextAttributes = attributes
        
        let navigationFont = UIFont(name: Theme.current.mainFontName, size: 20)
        let navigationLargeFont = UIFont(name: Theme.current.mainFontName, size: 34) //34 is Large Title size by default
        
        navigation.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: navigationFont!]
        
        if #available(iOS 11, *){
            navigation.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: navigationLargeFont!]
        }
        
        if !UserDefaults.standard.bool(forKey: "didSee") {
            UserDefaults.standard.set(true, forKey: "didSee")
            let storyboard = UIStoryboard(name: "OnBoardingSB", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: Constants.ON_BOARDING_VC)
            self.window?.rootViewController = viewController
            self.window?.makeKeyAndVisible()
        }
        
        appTheme()
        
        appNotification()
        
        do {
            realm = try Realm(configuration: realmConfiguration)
            
        } catch {
            print("error initializing real \(error)")
        }
        syncFunc()
        
        return true
    }
    
    
    func syncFunc() -> Void {
        
        if let navigationController = window?.rootViewController as? UINavigationController,
            let companyVC = navigationController.topViewController as? CategoryVC {
                companyVC.synchronizer = synchronizer
        }
        
    }
    
    //MARK: - Accepting shares
    
    func application(_ application: UIApplication, userDidAcceptCloudKitShareWith cloudKitShareMetadata: CKShare.Metadata) {
        
        let container = CKContainer(identifier: cloudKitShareMetadata.containerIdentifier)
        let acceptSharesOperation = CKAcceptSharesOperation(shareMetadatas: [cloudKitShareMetadata])
        acceptSharesOperation.qualityOfService = .userInteractive
        acceptSharesOperation.acceptSharesCompletionBlock = { error in
            if let error = error {
                let alertController = UIAlertController(title: "Error", message: "Could not accept CloudKit share: \(error.localizedDescription)", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            } else {
                self.sharedSynchronizer.synchronize(completion: nil)
            }
        }
        container.add(acceptSharesOperation)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
//        UIApplication.shared.applicationIconBadgeNumber = defaults.integer(forKey: Constants.NOTIFICATION_COUNT)
//        center.getDeliveredNotifications { (notification) in
//            
//            
//            UserDefaults.standard.set(notification.count, forKey: Constants.NOTIFICATION_COUNT)
//            print("///notification.count \(notification.count)")
//            print(".count noti//// \(UserDefaults.standard.integer(forKey: Constants.NOTIFICATION_COUNT))")
//            
//        }
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
    
    
    fileprivate func appTheme() {
        
        var lightTheme: String {
            get {
                return defaults.value(forKey: Constants.LIGHT_THEME) as? String ?? ""
            }
        }
        
        if lightTheme != "" {
            
            Theme.current = LightTheme()
            
        }
        
        var darkTheme: String {
            
            get {
                return defaults.value(forKey: Constants.DARK_THEME) as? String ?? ""
            }

            
        }
        
        if darkTheme != "" {
            
            Theme.current = DarkTheme()
            
        }
        
        var redTheme: String {
            get {
                return defaults.value(forKey: Constants.RED_THEME) as? String ?? ""
            }
        }
        
        if redTheme != "" {
            
            Theme.current = RedTheme()
            
        }
        
        var pinkTheme: String {
            
            get {
                return defaults.value(forKey: Constants.PINK_THEME) as? String ?? ""
            }
            
            
        }
        
        if pinkTheme != "" {
            
            Theme.current = PinkTheme()
            
        }
    }
    
    
    
    
    
    
    fileprivate func appNotification() {
        
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        
        
        center.requestAuthorization(options: options) {[weak self]
            (granted, error) in
            if !granted {
                print("Something went wrong")
            }
        }
        
        center.getNotificationSettings { (settings) in
            if settings.authorizationStatus != .authorized {
                // Notifications not allowed
            }
        }
        let snoozeAction = UNNotificationAction(identifier: "Snooze",
                                                title: "Snooze", options: [])
        let deleteAction = UNNotificationAction(identifier: "UYLDeleteAction",
                                                title: "Delete", options: [.destructive])
        let category = UNNotificationCategory(identifier: "UYLReminderCategory",
                                              actions: [snoozeAction,deleteAction],
                                              intentIdentifiers: [], options: [])
        
        center.setNotificationCategories([category])
    }


}

