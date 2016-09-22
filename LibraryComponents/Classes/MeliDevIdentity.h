//
//  MeliDevIdentity.h
//  Pods
//
//  Created by Ignacio Giagante on 1/9/16.
//
//

#import <Foundation/Foundation.h>
#import "MeliDevAccessToken.h"

static NSString const * CLIENT_ID = @"app_id";

@interface MeliDevIdentity : NSObject

@property (copy) NSString * clientId;
@property (copy) NSString * userId;
@property (nonatomic, strong) MeliDevAccessToken * accessToken;

+ (void) createMeliDevIdentity:(NSDictionary *) loginData;
+ (MeliDevIdentity *) restoreMeliDevIdentity: (NSString *) clientId;

- (NSString *) getMeliDevAccessTokenValue;

@end
