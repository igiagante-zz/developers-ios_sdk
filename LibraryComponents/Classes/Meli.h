//
//  Meli.h
//  Pods
//
//  Created by Ignacio Giagante on 6/9/16.
//
//

#import <Foundation/Foundation.h>
#import "MeliDevIdentity.h"

static NSString * const MELI_DEV_SUCCESS = @"success";
static NSString const * MELI_APP_ID_KEY = @"MeliAppId";

@interface Meli : NSObject

+ (MeliDevIdentity *) getMeliDevIdentity;
+ (void) startSDK: (NSString *) clientId withRedirectUrl:(NSString *) redirectUrl error:(NSError **) error;
+ (void) startLogin: (UIViewController *) clientViewController;

@end
