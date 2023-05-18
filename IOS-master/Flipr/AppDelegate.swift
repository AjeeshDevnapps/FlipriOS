//
//  AppDelegate.swift
//  Flipr
//
//  Created by Benjamin McMurrich on 15/03/2017.
//  Copyright © 2017 I See U. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics
import UserNotifications
import Alamofire
import IQKeyboardManagerSwift
import SideMenu
import StoreKit
import SafariServices
import FirebaseMessaging
import FirebaseCore
import GoogleMaps
import GooglePlaces

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
//        FirebaseApp.configure()
//
//        // [START set_messaging_delegate]
//        Messaging.messaging().delegate = self
        // [END set_messaging_delegate]
        // Register for remote notifications. This shows a permission dialog on first run, to
        // show the dialog at a more appropriate time move this registration accordingly.
        // [START register_for_notifications]
      /*
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: { _, _ in }
            )
        } else {
            let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        */
        
        SKPaymentQueue.default().add(self)
        GMSServices.provideAPIKey("AIzaSyArjEZJCOynnikc5LuzFs6Ky5IWm7S_SBw")
        GMSPlacesClient.provideAPIKey("AIzaSyArjEZJCOynnikc5LuzFs6Ky5IWm7S_SBw")
        
        Fabric.with([Crashlytics.self])
        
//        Omnisense.setAppIdentifier("flipr", apiKey: "f09e9a70f8c7580003c05ae11c19e079")

        //registerSettingsBundle()
        
        customizeTheme()
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 200
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.shouldShowToolbarPlaceholder = false
        AppSharedData.sharedInstance.isNeedtoCallModulesApiForSideMenu = true

        
        AppReview.shared.activate(appID: "1225898851", feedbackEmails: ["contact@goflipr.com"])
        
        if let remoteNotification = launchOptions?[.remoteNotification] as?  [AnyHashable : Any] {
            debugPrint("Open from remote notification: \(remoteNotification)")
            handleRemoteNotification(info: remoteNotification)
        }
        
//        Messaging.messaging().delegate = self
//        FirebaseApp.configure()
        
        return true
    }
    
    
    func customizeTheme() {
        
        self.window?.tintColor = K.Color.LightBlue
        let navigationBarAppearance = UINavigationBar.appearance()
        navigationBarAppearance.shadowImage = UIImage()
//        navigationBarAppearance.setBackgroundImage(UIImage(), for: .default)
        navigationBarAppearance.tintColor = K.Color.themeBlack
        navigationBarAppearance.barTintColor =  .white
        navigationBarAppearance.titleTextAttributes = convertToOptionalNSAttributedStringKeyDictionary([NSAttributedString.Key.foregroundColor.rawValue:K.Color.DarkBlue])
        if #available(iOS 11.0, *) {
            navigationBarAppearance.largeTitleTextAttributes = convertToOptionalNSAttributedStringKeyDictionary([NSAttributedString.Key.foregroundColor.rawValue:K.Color.DarkBlue])
        }
        
        EmptyStateViewTheme.shared.activityIndicatorType = .orbit
        EmptyStateViewTheme.shared.titleColor = K.Color.DarkBlue
        EmptyStateViewTheme.shared.messageColor = .lightGray
        EmptyStateViewTheme.shared.activityIndicatorColor = K.Color.LightBlue
        
//        SideMenuManager.default.menuPresentMode = .menuSlideIn
//        SideMenuManager.default.menuFadeStatusBar = false
//        SideMenuManager.default.menuWidth = 280
        
        let sb = UIStoryboard.init(name: "Main", bundle: nil)

        SideMenuManager.default.leftMenuNavigationController = sb.instantiateViewController(withIdentifier: "UISideMenuNavigationControllerID") as? SideMenuNavigationController
        var settings = SideMenuSettings()
        settings.presentationStyle = .menuSlideIn
        settings.enableSwipeToDismissGesture = true
//        settings.presentationStyle.onTopShadowRadius = 5
//        settings.presentationStyle.onTopShadowColor = .black
//        settings.presentationStyle.onTopShadowOffset = .zero
//        settings.presentationStyle.onTopShadowOpacity = 1
//        settings.blurEffectStyle = .dark
        SideMenuManager.default.leftMenuNavigationController?.settings = settings
        

    }
    
    func updateUserData() {
        if let user = User.currentUser {
            user.getModule(completion: { (devices,error) in
                if error != nil {
                } else {
                    user.getPool(completion: { (error) in
                        if error != nil {
                        } else {
                            user.getAccount(completion: nil)
                        }
                    })
                }
            })
        }
        
    }
    
    func registerSettingsBundle(){
        //let appDefaults = ["flipr_module_identifier":"192EE4","flipr_data_source":"sigfox"]
        //UserDefaults.standard.register(defaults: appDefaults)
    }
    
    func registerForRemoteNotifications(application: UIApplication){
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
        
        // [START set_messaging_delegate]
        Messaging.messaging().delegate = self

        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            
            // For iOS 10 data message (sent via FCM)
            //FIRMessaging.messaging().remoteMessageDelegate = self
            
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
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
        
        CLLocationManager().requestWhenInUseAuthorization()
        
        RemoteControl.sync(ISEEU_REMOTE_CONTROL_FILE_URL)
        
        if Pool.currentPool != nil {
//            User.currentUser?.getPool(completion: nil)
            //User.currentUser?.getModule(completion: nil)
            //User.currentUser?.getAccount(completion: nil)
            //updateUserData()
        }
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    //Remote notifcation delegate
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print("Remote notification device: \(deviceTokenString)")
//        Messaging.messaging().apnsToken = deviceToken
        
//        Omnisense.registerAppForRemoteNotifications(withDeviceToken: deviceToken)
        
        
        
        /*
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print("Remote notification device: \(deviceTokenString)")
        
        if let deviceToken = UserDefaults.standard.string(forKey: "deviceToken") {
            if deviceToken == deviceTokenString {
                return
            }
        }
        
         
        Alamofire.request(Router.addMobileDevice(token: deviceTokenString)).validate(statusCode: 200..<300).responseJSON(completionHandler: { (response) in
            if let error = response.result.error {
                print("Add mobile device did fail with error: \(error)")
            } else {
                print("Add mobile device - response.result.value: \(response.result.value)")
                UserDefaults.standard.set(deviceTokenString, forKey: "deviceToken")
                UserDefaults.standard.synchronize()
                
            }
        })
        */
        
    }
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        // Print message ID.
          if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
          }

          // Print full message.
          print(userInfo)
        handleRemoteNotification(info: userInfo)
    }
    
    func application(_ application: UIApplication,
                      didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                      fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult)
                        -> Void) {
       // If you are receiving a notification message while your app is in the background,
       // this callback will not be fired till the user taps on the notification launching the application.
       // TODO: Handle data of notification
       // With swizzling disabled you must let Messaging know about the message, for Analytics
       // Messaging.messaging().appDidReceiveMessage(userInfo)
       // Print message ID.
       if let messageID = userInfo[gcmMessageIDKey] {
         print("Message ID: \(messageID)")
       }

       // Print full message.
       print(userInfo)

       completionHandler(UIBackgroundFetchResult.newData)
     }
    
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {

        print("i am not available in simulator \(error)")
        
    }
    
    func handleRemoteNotification(info:[AnyHashable : Any]) {
        
//        Omnisense.handleRemoteNotification(info)
        
        if let extra = info["extra"] as? [String : Any] {
            if let urlString = extra["u"] as? String {
                
                // On ouvre drectement Safari car sinon on a une erreur du type "view is not in the window hierarchy!" avec SafariViewController...
                guard let url = URL(string: urlString) else { return }
                UIApplication.shared.open(url)
    
                /*
                if let url = URL(string: urlString) {
                    print("Push deeplink: \(url.absoluteString)")
                    let vc = SFSafariViewController(url: url, entersReaderIfAvailable: true)
                    self.window?.rootViewController?.present(vc, animated: true)
                }*/
            }
        }
    }


}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}

extension AppDelegate: SKPaymentTransactionObserver {
    
    func paymentQueue(_ queue: SKPaymentQueue,
                      updatedTransactions transactions: [SKPaymentTransaction]) {
        
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchasing:
                handlePurchasingState(for: transaction, in: queue)
            case .purchased:
                handlePurchasedState(for: transaction, in: queue)
            case .restored:
                handleRestoredState(for: transaction, in: queue)
            case .failed:
                handleFailedState(for: transaction, in: queue)
            case .deferred:
                handleDeferredState(for: transaction, in: queue)
            }
        }
        
    }
    
    func handlePurchasingState(for transaction: SKPaymentTransaction, in queue: SKPaymentQueue) {
        print("User is attempting to purchase product id: \(transaction.payment.productIdentifier)")
    }
    
    func handlePurchasedState(for transaction: SKPaymentTransaction, in queue: SKPaymentQueue) {
        print("User purchased product id: \(transaction.payment.productIdentifier)")
        
        SubscriptionService.shared.uploadReceipt { (error) in
            DispatchQueue.main.async {
                if error == nil {
                    NotificationCenter.default.post(name: SubscriptionService.purchaseSuccessfulNotification, object: nil)
                } else {
                    print("User purchased product error: \(error)")
                    NotificationCenter.default.post(name: SubscriptionService.purchaseFailedNotification, object: nil)
                }
            }
        }
    }
    
    func handleRestoredState(for transaction: SKPaymentTransaction, in queue: SKPaymentQueue) {
        print("Purchase restored for product id: \(transaction.payment.productIdentifier)")
        
        queue.finishTransaction(transaction)
        
        SubscriptionService.shared.uploadReceipt { (error) in
            DispatchQueue.main.async {
                if error == nil {
                    NotificationCenter.default.post(name: SubscriptionService.restoreSuccessfulNotification, object: nil)
                } else {
                    NotificationCenter.default.post(name: SubscriptionService.restoreFAiledNotification, object: nil)
                    print("Purchase restored for product with error: \(error)")
                }
            }
        }
    }
    
    func handleFailedState(for transaction: SKPaymentTransaction, in queue: SKPaymentQueue) {
        print("Purchase failed for product id: \(transaction.payment.productIdentifier)")
        SKPaymentQueue.default().finishTransaction(transaction)
        NotificationCenter.default.post(name: SubscriptionService.purchaseCanceledNotification, object: nil)
    }
    
    func handleDeferredState(for transaction: SKPaymentTransaction, in queue: SKPaymentQueue) {
        print("Purchase deferred for product id: \(transaction.payment.productIdentifier)")
    }

}

extension AppDelegate: MessagingDelegate {
  // [START refresh_token]
  func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
    print("Firebase registration token: \(String(describing: fcmToken))")

    let dataDict: [String: String] = ["token": fcmToken ?? ""]
    NotificationCenter.default.post(
      name: Notification.Name("FCMToken"),
      object: nil,
      userInfo: dataDict
    )
      
      User.updateFcmToken(tokenValue: fcmToken ?? "", completion: { (error) in
          if (error != nil) {
              print("Error")

          } else {
              print("Success")

          }
      })
      
    // TODO: If necessary send token to application server.
    // Note: This callback is fired at each app startup and whenever a new token is generated.
  }

  // [END refresh_token]
}


@available(iOS 10, *)
extension AppDelegate: UNUserNotificationCenterDelegate {
  // Receive displayed notifications for iOS 10 devices.
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification,
                              withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions)
                                -> Void) {
    let userInfo = notification.request.content.userInfo

    // With swizzling disabled you must let Messaging know about the message, for Analytics
    // Messaging.messaging().appDidReceiveMessage(userInfo)
    // [START_EXCLUDE]
    // Print message ID.
    if let messageID = userInfo[gcmMessageIDKey] {
      print("Message ID: \(messageID)")
    }
    // [END_EXCLUDE]
    // Print full message.
    print(userInfo)

    // Change this to your preferred presentation option
    completionHandler([[.alert, .sound]])
  }

  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse,
                              withCompletionHandler completionHandler: @escaping () -> Void) {
    let userInfo = response.notification.request.content.userInfo

    // [START_EXCLUDE]
    // Print message ID.
    if let messageID = userInfo[gcmMessageIDKey] {
      print("Message ID: \(messageID)")
    }
    // [END_EXCLUDE]
    // With swizzling disabled you must let Messaging know about the message, for Analytics
    // Messaging.messaging().appDidReceiveMessage(userInfo)
    // Print full message.
    print(userInfo)

    completionHandler()
  }
}

