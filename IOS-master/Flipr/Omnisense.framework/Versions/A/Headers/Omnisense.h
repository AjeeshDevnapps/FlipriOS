//
//  Omnisense.h
//  I See U
//
//  Created by Benjamin McMurrich on 01/09/14.
//  Copyright (c) 2016 I See U. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>
#import <AdSupport/ASIdentifierManager.h>

#import "OSUser.h"

@interface Omnisense : NSObject

///---------------------------------------
/// @name Lifecycle
///---------------------------------------

/**
 * Initializes Omnisense and performs all necessary setup. This creates the shared instance, loads
 * configuration values, initializes the analytics, reporting and conversion tracking
 * modules and creates a current OSUser if one does not already exist.
 *
 * This method *must* be called from your application delegate's
 * `application:didFinishLaunchingWithOptions:` method, and it may be called
 * only once.
 *
 * @param identifier The app identifier
 * @param apiKey The app API Key
 */
+ (void) setAppIdentifier:(NSString*)identifier apiKey:(NSString*)apiKey;


///---------------------------------------
/// @name Remote Notifications
///---------------------------------------

/**
 * To register the current device for push, call UIApplication's registerForRemoteNotifications method 
 * from the app delegate's application:didFinishLaunchingWithOptions:
 *
 * If the registration is successful, the callback method application:didRegisterForRemoteNotificationsWithDeviceToken:
 * in the application delegate will be executed. You will need to implement this method and use it to inform Omnisense 
 * about this new device.
 *
 * @param token A dictionary of string values
 */
+ (void) registerAppForRemoteNotificationsWithDeviceToken:(NSData *)token;

/**
 * Handle incoming push notifications.
 * When a push notification is openned on iOS while the associated application is running in the background,
 * the callback method application:didReceiveRemoteNotification: in the application delegate will be executed.
 * You will need to implement this method and use it to inform Omnisense about the openning of the push notification.
 *
 * @param userInfo The notification as NSDictionary.
 */
+ (void) handleRemoteNotification:(NSDictionary*)userInfo;

/** 
 * When a push notification is received on iOS while the associated application is not in the foreground, 
 * it is displayed in the iOS Notification Center and/or a banner will appear at the top of the screen. 
 * However, if the notification is received while the associated app is in the foreground, 
 * it is up to the application to handle the display of said notification if desired. 
 * Depending on your use case, you may want to show an alert to the user, 
 * or fetch new data from the server in order to refresh the UI.
 *
 * Whatever the case, you will need to implement the application:didReceiveRemoteNotification: method
 * in the app delegate in order to handle incoming remote notifications while the app is in the foreground.
 */

///---------------------------------------
/// @name User data recording
///---------------------------------------

/**
 * Indetify the current user after login or sign up. An email OR Facebook ID must be set to sync with Omnisense.
 * Cf. OSUser.h for attributes
 * @param user The current user after login or sign up.
 */
+ (void) setCurrentUser:(OSUser*)user;
+ (void) setCurrentUser:(OSUser*)user completion:(void (^)(BOOL succeeded, NSError *error))block;

/**
 * Get the current user.
 */
+ (OSUser*) currentUser;

/**
 * Save current user attributes after changes.
 */
+ (void) saveCurrentUser;
+ (void) saveCurrentUser:(void (^)(BOOL succeeded, NSError *error))block;

/**
 * Reset the current user and creates a new current OSUser (logout process)
 */
+ (void) resetCurrentUser;

/**
 * Triggers an analytics event.
 * @param key The event to be triggered
 * @param segmentation A dictionary of string values
 */
+ (void) recordEvent:(NSString *)key segmentation:(NSDictionary<NSString *, NSString *> *)segmentation;

 
 ///---------------------------------------
 /// @name Conversion data
 ///---------------------------------------
 
 /**
  * In case you want to use Omnisense conversion data at first launch in your app,
  * you can use the following method before setting the Api Key (does not work for Facbook app install)
  */
+ (void) conversionDataHandler:(void (^)(NSDictionary* conversionData, NSError *error))block;

/**
 * Conversion data are disk cached, you can get it anywhere in the app using this method.
 */
+ (NSDictionary*) conversionData;

/**
 * To track Facebook app install, set a specific Omnisense link into the deferred app link parameter of your Facebook campaign.
 * This method handle the Omnisense link to track the Facebook app install and return the real app link if it exist.
 */
+ (NSURL*) handleFacebookDeferredAppLink:(NSURL*)url;

///---------------------------------------
/// @name Debug mode
///---------------------------------------

+ (void) setDebugMode:(BOOL)debug;

@end
