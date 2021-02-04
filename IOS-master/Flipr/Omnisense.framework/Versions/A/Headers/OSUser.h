//
//  OSUser.h
//  I See U
//
//  Created by Benjamin McMurrich on 17/09/2014.
//  Copyright (c) 2016 I See U. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    OSUserGenderUnknown       = -1,
    OSUserGenderFemale        = 0,
    OSUserGenderMale          = 1
} OSUserGender;

@interface OSUser : NSObject


///---------------------------------------
/// @names Identifiers
///---------------------------------------

/**
 * To identify a user on Omnisense, an email OR the Facebook ID must at least be set.
 * If not, other attributes won't be sync with Omnisense.
 */

@property (nonatomic,strong) NSString * email;

@property (nonatomic,strong) NSString * facebookId;

///---------------------------------------
/// @optin Attributes
///---------------------------------------

@property BOOL registered;
@property BOOL optin;
@property BOOL optinSms;

///---------------------------------------
/// @name Attributes
///---------------------------------------

@property (nonatomic,strong) NSString * firstName;

@property (nonatomic,strong) NSString * lastName;

/**
 User gender is OSUserGenderUnknown by default
 */
@property OSUserGender gender;

@property (nonatomic,strong) NSDate * birthday;

/**
 * Phone number should be in international format in order to use Omnisense SMS tools (ex: +33624902875).
 */
@property (nonatomic,strong) NSString * phone;

@property (nonatomic,strong) NSString * address;

@property (nonatomic,strong) NSString * postalCode;

@property (nonatomic,strong) NSString * city;

/**
 * The country property should be the ISO code, for example "fr" for France.
 */
@property (nonatomic,strong) NSString * country;

/**
 * Custom fields (must be only string values)
 */
@property (nonatomic,strong) NSDictionary<NSString *, NSString *> * metadata;


///---------------------------------------
/// @name Initializers
///---------------------------------------

- (id)initWithFacebookId:(NSString*)facebookId;

- (id)initWithEmail:(NSString*)email;

@end
