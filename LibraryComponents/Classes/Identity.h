//
//  Identity.h
//  Pods
//
//  Created by Ignacio Giagante on 1/9/16.
//
//

#import <Foundation/Foundation.h>
#import "AccessToken.h"


static const NSString * CLIENT_ID = @"app_id";

@interface Identity : NSObject

@property (copy) NSString * clientId;
@property (copy) NSString * userId;
@property (nonatomic, strong) AccessToken * accessToken;

+ (void) createIdentity:(NSDictionary *) loginData;
+ (Identity *) restoreIdentity;

- (void) storeIdentity;

@end
