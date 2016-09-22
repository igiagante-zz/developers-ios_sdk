//
//  Meli.h
//  Pods
//
//  Created by Ignacio Giagante on 6/9/16.
//
//

#import <Foundation/Foundation.h>
#import "Identity.h"

static NSString * const MELI_DEV_SUCCESS = @"success";
static NSString const * MELI_APP_ID_KEY = @"MeliAppId";

@interface Meli : NSObject

+ (Identity *) getIdentity;
+ (void) startSDK: (NSError **) error;
+ (void) startLogin: (UIViewController *) clientViewController;

@end
