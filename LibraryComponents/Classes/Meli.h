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

@interface Meli : NSObject

+ (instancetype) meli;

- (Identity *) getIdentity;
- (void) startSDK: (NSError **) error;
- (void) startLogin: (UIViewController *) clientViewController;

@end
